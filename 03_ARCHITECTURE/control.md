# D03 · Phần điều khiển (Control)

---

## 1. Kiến trúc điều khiển của D03

D03 có phần điều khiển **thật sự**, và nó có một đặc điểm hiếm: **tín hiệu điều khiển chính
lại chính là tín hiệu ra**. Bit `out` vừa là sản phẩm của khối, vừa là chân chọn quyết định
nửa chu kỳ tiếp theo dài bao nhiêu.

```
   ┌──────────────── VÒNG ĐIỀU KHIỂN CỐT LÕI ─────────────────────────┐
   │                                                                  │
   │   ┌───────┐                                                      │
   │   │  out  │──── chọn ───▶ half_len = out ? ⌈N/2⌉ : ⌊N/2⌋         │
   │   │ (REG) │                          │                           │
   │   └───▲───┘                          ▼                           │
   │       │                  phase == half_len − 1 ?                 │
   │       │                          │                               │
   │       │       CÓ ──────────▶ out ← ~out ; phase ← 0              │
   │       └───────────────────────┘                                  │
   │               KHÔNG ─────────▶ phase ← phase + 1                 │
   └──────────────────────────────────────────────────────────────────┘
```

Vòng này chính là **đường tới hạn thật** theo STA (`block_diagram.md` §4) — điều khiển và
timing ở đây là cùng một câu chuyện.

## 2. Bảng tín hiệu điều khiển và tác dụng

### Điều khiển từ bên ngoài

| Tín hiệu | Mức tích cực | Tác dụng chính xác | Ưu tiên |
|---|---|---|---:|
| `rst_n` | **thấp** | `n_reg←1`, `phase←0`, `out←0`. **Đồng bộ** (trong `always_ff`) | 1 |
| `load_n` | cao | `n_reg←(n_in==0 ? 1 : n_in)`, **đồng thời** `phase←0`, `out←0` | 2 |

Lưu ý tên: `load_n` **không** phải tín hiệu tích cực thấp dù có hậu tố `_n`. Đọc RTL dòng 27:
`else if (load_n)` ⟹ tích cực **cao**. Đây là cái bẫy đặt tên; phải ghi rõ trong tài liệu bàn
giao để tầng ngoài không nối nhầm.

### Điều khiển sinh **bên trong** (từ datapath)

| Tín hiệu | Biểu thức | Vai trò | Ưu tiên |
|---|---|---|---:|
| `n_reg == 8'd1` | so sánh hằng 8 bit | Kích hoạt **nhánh đặc biệt**: `out←1` mãi mãi, `phase←0`. Bỏ qua toàn bộ cơ chế `half_len` | 3 |
| `out` | bit trạng thái | **Chọn** `half_len` giữa `⌈N/2⌉` và `⌊N/2⌋` — **toàn bộ cơ chế xử lý N lẻ** | (tổ hợp) |
| `n_reg ≤ 8'd1` | so sánh hằng | Ép `half_len = 1` để `half_len − 1 = 0` không bị tràn ngược (INV-3) | (tổ hợp) |
| `phase == half_len − 1` | so sánh bằng 8 bit | **Tín hiệu "hết nửa chu kỳ"** — quyết định lật `out` hay tăng `phase` | 4 |

## 3. 🔎 `out` là tín hiệu lưỡng dụng — phân tích

Đây là điểm kiến trúc đáng chú ý nhất của D03.

| Góc nhìn | `out` là gì |
|---|---|
| Với tầng ngoài | Tín hiệu **nhịp lấy mẫu** — sản phẩm của khối |
| Với datapath | Chân **chọn** của mux `half_len` |
| Với FSM | **Bit trạng thái duy nhất** của máy trạng thái điều khiển (xem `fsm.md`) |

**Lợi:** không tốn thêm flip-flop nào cho phần điều khiển. Đây là lý do 17 FF của netlist khớp
chính xác 17 bit trạng thái RTL, và khớp luôn "dấu hiệu làm đúng" của Charter mục 10.

**Hại:** `out` nằm trên đường tới hạn. Nó có **fanout 6** và clk→Q **0,30 ns** — nó vừa phải
ra cổng, vừa phải lái cả cây `half_len` bên trong.

**Nếu tách đôi:** dùng một bit trạng thái `phase_hi` riêng cho điều khiển và giữ `out` chỉ làm
đầu ra. Chi phí +1 FF, lợi ích: có thể chèn đệm cho `out` mà không ảnh hưởng đường trong. Ở
quy mô này (slack +7,42 ns) **không cần** — ghi lại chỉ để trả lời khi bảo vệ.

## 4. Quan hệ điều khiển ↔ datapath

```
  ĐIỀU KHIỂN                              DATAPATH
  ──────────                              ────────
  rst_n  ────────┐
  load_n ────────┼──▶ mux ưu tiên ──▶ D(n_reg[7:0]) ──▶[REG]──▶ n_reg
                 │                                              │
                 │                            ┌─────────────────┘
                 │                            ▼
                 │                    [>>1] , [N − N>>1]
                 │                            │
  out  ──────────┼──── chọn ────────────▶ [MUX half_len]
    ▲            │                            │
    │            │                            ▼
    │            └──▶ mux ưu tiên ──▶ [SO SÁNH == ] ◀── phase
    │                                         │
    │                                         ▼
    │                           "hết nửa chu kỳ" (1 bit)
    │                                    │        │
    └────────────────────────────────────┘        └──▶ D(phase) = 0 hoặc phase+1
              lật out
```

**Đặc điểm:** điều khiển **sinh ra từ datapath** (`phase == half_len−1`, `n_reg == 1`) rồi quay
lại lái chính datapath đó. Không có FSM độc lập ra lệnh. Đây là kiểu *datapath-driven control*,
giống D02 nhưng vòng hồi tiếp ở D03 **dài hơn nhiều** vì phải qua bộ trừ và bộ so sánh 8 bit.

## 5. Bảng ưu tiên đầy đủ (đọc từ `always_ff` dòng 22–40)

| Ưu tiên | Điều kiện | Tác động lên `n_reg` | lên `phase` | lên `out` |
|---:|---|---|---|---|
| 1 | `!rst_n` | ← 1 | ← 0 | ← 0 |
| 2 | `load_n` | ← `n_in==0 ? 1 : n_in` | ← 0 | ← 0 |
| 3 | `n_reg == 1` | giữ | ← 0 | ← **1** |
| 4 | `phase == half_len − 1` | giữ | ← 0 | ← `~out` |
| 5 | (còn lại) | giữ | ← `phase + 1` | **giữ** |

> ⚠️ **Chi tiết dễ bỏ sót:** ở nhánh 5, RTL **không** gán `out` (dòng 37–39 chỉ có
> `phase <= phase + 8'd1`). Trong `always_ff` điều này đúng và an toàn — không gán nghĩa là
> **giữ nguyên thanh ghi**. Nếu cùng cách viết đó nằm trong `always_comb`, nó sẽ **suy ra
> latch**. Đây là khác biệt cốt lõi giữa hai loại always block, và là chỗ sinh viên hay lẫn.

## 6. Nghĩa vụ của tầng ngoài (hợp đồng điều khiển)

| # | Nghĩa vụ | Hậu quả nếu vi phạm |
|---|---|---|
| E-1 | Hiểu `load_n` tích cực **CAO** bất chấp tên gọi | Nối đảo ⟹ mạch nạp N liên tục mỗi chu kỳ ⟹ `out` kẹt ở 0 |
| E-2 | `n_in` ổn định tại cạnh clock có `load_n=1` | Không có chốt đầu vào; nạp giá trị đang chuyển ⟹ N sai |
| E-3 | `rst_n` giữ thấp qua ít nhất một cạnh lên `clk` | Reset **đồng bộ** ⟹ xung hẹp bị bỏ qua, **không báo lỗi** |
| E-4 | Dùng **cạnh lên** `out`, không dùng mức | Với N lẻ, mức cao dài hơn mức thấp (duty ≠ 50 %) |
| E-5 | Với N = 1, **không** chờ cạnh lên `out` | `out ≡ 1` — tầng ngoài sẽ treo vĩnh viễn |
| E-6 | Chấp nhận **một xung cụt** khi đổi N giữa chừng | `load_n` cắt ngang nửa chu kỳ đang chạy. Nếu không chấp nhận được, phải đổi N **sau** một cạnh xuống của `out` |
| E-7 | Không dùng `count[6:0]` để đếm số nhịp đã phát | Nó là **pha trong nửa chu kỳ**, bị đặt lại mỗi lần `out` lật |

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*
