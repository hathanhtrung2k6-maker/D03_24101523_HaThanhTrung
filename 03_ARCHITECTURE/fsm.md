# D03 · Máy trạng thái (FSM)

---

## 1. D03 **có** FSM điều khiển — 3 trạng thái, 1 flip-flop

Phân biệt hai thứ dễ lẫn:

| | Số bit | Nội dung |
|---|---:|---|
| **Trạng thái đầy đủ** của mạch | 17 | `n_reg[7:0]` + `phase[7:0]` + `out` — nếu coi tất cả là "trạng thái FSM" thì có 2¹⁷ trạng thái, vô nghĩa để vẽ |
| **FSM điều khiển** | **1** | Chỉ bit `out`. `n_reg` là **tham số cấu hình**, `phase` là **bộ đếm** — cả hai đều là datapath, không phải trạng thái điều khiển |

Cách tách này không tuỳ tiện: `out` là tín hiệu **duy nhất** trong `always_ff` mà giá trị kế
tiếp của nó được quyết định bởi **chính nó** (`out <= ~out`, RTL dòng 36) và lại **quay ngược**
lái datapath (chọn `half_len`, dòng 16). Đó đúng là định nghĩa của một bit trạng thái điều
khiển.

## 2. Moore hay Mealy — và **bằng chứng**

**Moore.**

| Bằng chứng | Nội dung |
|---|---|
| B-1 | `out` được khai báo `output logic` và **được gán trong `always_ff`** (dòng 26, 30, 33, 36). Không có `always_comb` nào gán `out` |
| B-2 | Trong netlist: `sky130_fd_sc_hd__dfxtp_1 _169_ ( .CLK(clk), .D(_005_), .Q(out) );` — `out` là **Q của flip-flop**, nối thẳng ra cổng. **Không có** cell tổ hợp nào giữa `out` và cổng ra |
| B-3 | Hệ quả: không có đường tổ hợp nào từ `n_in`/`load_n`/`rst_n` tới `out`. Thay `n_in` giữa chu kỳ **không** làm `out` nhảy |

Đầu ra **thứ hai**, `count[6:0]`, lại là **tổ hợp** của trạng thái (RTL dòng 42–49). Nó vẫn
Moore (chỉ phụ thuộc trạng thái, không phụ thuộc đầu vào), nhưng **có thể glitch** trong lòng
chu kỳ. Với vai trò "cổng quan sát" thì chấp nhận được; nếu tầng ngoài chốt `count` bằng clock
khác thì phải thêm một tầng thanh ghi — nghĩa vụ của tầng ngoài.

## 3. Sơ đồ trạng thái (ASCII)

```
                            rst_n = 0  (ĐỒNG BỘ, từ MỌI trạng thái)
       ┌──────────────────────────────────────────────────────────────┐
       │                          load_n = 1  (từ MỌI trạng thái)     │
       │      ┌───────────────────────────────────────────────────┐   │
       │      │                                                   ▼   ▼
       │      │                                        ╔═══════════════════════╗
       │      │                                        ║      S_LOW            ║
       │      │                                        ║  out = 0              ║
       │      │              phase == ⌊N/2⌋ − 1        ║  half_len = ⌊N/2⌋     ║
       │      │        ┌──────────────────────────────▶║  phase đếm lên        ║
       │      │        │                               ╚═══════╤═══════════════╝
       │      │        │                                       │ phase == ⌊N/2⌋−1
       │      │        │                                       │ ⟹ phase←0, out←1
       │      │        │                                       ▼
       │      │  ╔═════╧═════════════════╗           (tự vòng nếu chưa tới)
       │      │  ║      S_HIGH           ║◀──────────────────────┘
       │      │  ║  out = 1              ║
       │      │  ║  half_len = ⌈N/2⌉     ║  phase == ⌈N/2⌉−1 ⟹ phase←0, out←0
       │      │  ║  phase đếm lên        ║──────────────────────┐
       │      │  ╚═══════════════════════╝                      │
       │      │            ▲                                    │
       │      │            │ (tự vòng nếu chưa tới)             │
       │      │            └────────────────────────────────────┘
       │      │
       │      │   ╔════════════════════════════════════════════════╗
       │      └──▶║            S_DC  (n_reg == 1)                  ║
       │          ║  out = 1 VĨNH VIỄN · phase ≡ 0 · count ≡ 0     ║◀─┐
       └─────────▶║  KHÔNG có xung ra — trạng thái HẤP THỤ         ║──┘
                  ╚════════════════════════════════════════════════╝
                     thoát ra CHỈ bằng load_n (với n_in ≥ 2) hoặc rst_n
```

## 4. Bảng chuyển trạng thái đầy đủ

`S` = trạng thái hiện tại; `hl` = `half_len`.

| # | `rst_n` | `load_n` | `n_reg==1` | `phase == hl−1` | `S` | `S'` | `phase'` | `out'` |
|---:|:-:|:-:|:-:|:-:|---|---|---|---|
| 1 | 0 | × | × | × | bất kỳ | **S_LOW** (với `n_reg←1` ⟹ thực chất vào **S_DC** ở chu kỳ sau) | 0 | 0 |
| 2 | 1 | 1 | × | × | bất kỳ | **S_LOW** nếu `n_in ≥ 2`; **S_DC** nếu `n_in ∈ {0,1}` | 0 | 0 |
| 3 | 1 | 0 | 1 | × | bất kỳ | **S_DC** | 0 | **1** |
| 4 | 1 | 0 | 0 | 1 | S_LOW | **S_HIGH** | 0 | 1 |
| 5 | 1 | 0 | 0 | 1 | S_HIGH | **S_LOW** | 0 | 0 |
| 6 | 1 | 0 | 0 | 0 | S_LOW | S_LOW | `phase+1` | 0 |
| 7 | 1 | 0 | 0 | 0 | S_HIGH | S_HIGH | `phase+1` | 1 |

> 🔎 **Chi tiết tinh tế ở dòng 1.** Reset đặt `n_reg ← 1` **và** `out ← 0`. Nên ngay sau reset,
> mạch ở `out = 0` nhưng `n_reg == 1`, tức chu kỳ **kế tiếp** nó rơi vào nhánh 3 và `out` bật
> lên 1 rồi đứng yên. Nghĩa là: **sau reset, `out` bật cao sau đúng 1 chu kỳ và ở nguyên đó**
> cho tới khi có `load_n`. Tầng ngoài phải biết điều này (hợp đồng E-5 ở `control.md`).

## 5. Mã hoá trạng thái và trạng thái bất hợp lệ

**Mã hoá:** `out` một bit, **không có** mã hoá riêng — trạng thái điều khiển **chính là** bit
ra. Đây là mã hoá rẻ nhất có thể (0 FF phụ), và là lý do 17 FF của netlist khớp chính xác
17 bit trạng thái RTL.

**Trạng thái S_DC** không có mã riêng; nó được nhận ra bằng điều kiện `n_reg == 1` trên
datapath. Nói chặt chẽ: FSM điều khiển có **2** trạng thái mã hoá (`out ∈ {0,1}`), và S_DC là
một **chế độ** của datapath làm vô hiệu hoá chuyển trạng thái.

### Trạng thái bất hợp lệ — phân tích trung thực

Vì FSM chỉ có 1 bit, **không có tổ hợp `out` bất hợp lệ**. Nhưng **datapath** thì có:

| Tình huống bất hợp lệ | Có đạt tới được trong vận hành đúng? | Mạch xử lý thế nào |
|---|---|---|
| `phase > half_len − 1` (đếm vượt mốc) | ❌ Không — `phase` luôn bị đặt lại đúng lúc | Nếu xảy ra (SEU, chưa reset): `phase == half_len−1` **không bao giờ đúng nữa** ⟹ `phase` đếm tới 255 rồi **tràn về 0** rồi mới bắt lại mốc. **Tự khỏi sau ≤ 256 chu kỳ**, nhưng chu kỳ ra bị sai trong suốt thời gian đó |
| `phase > 127` | ❌ Không (INV-2: `phase < half_len ≤ 128`) | `count` bão hoà ở `7'h7f`. Nhánh này là **logic chết** trong vận hành đúng, nhưng nó **bảo vệ** đầu ra `count` khỏi bị cắt bit sai trong tình huống trên |
| `n_reg == 0` | ❌ Không — `load_n` ánh xạ 0 → 1 (dòng 28), reset đặt 1 (dòng 24) | Nếu xảy ra: `n_reg ≤ 1` đúng ⟹ `half_len = 1` ⟹ mạch không treo. **Được bảo vệ hai lớp** |
| Toàn bộ trạng thái = `X` (trước cạnh clock đầu, gate-level) | ✅ Có, luôn xảy ra | `dfxtp_1` **không có chân reset** ⟹ phải có ít nhất một cạnh clock với `rst_n = 0`. Xem `corner_cases.md` G-1 |

> 📌 **D03 không có mạch tự sửa tường minh**, nhưng có **ba lớp bảo vệ ngầm** đáng ghi nhận:
> (1) `n_in == 0 → 1` chống chia 0; (2) `n_reg ≤ 1 → half_len = 1` chống tràn ngược ở
> `half_len − 1`; (3) bão hoà `count` ở `7'h7f`. Cả ba đều là quyết định phòng thủ có chủ ý,
> và (3) là logic chết trong vận hành đúng — **nêu ra được điều này là điểm cộng**, giấu đi là
> điểm trừ theo Charter mục 10.

## 6. So sánh với FSM của hai đề cùng nhóm

| | D02 (đếm BCD) | **D03 (chia tần)** | D04 (đếm vòng/Johnson) |
|---|---|---|---|
| Bit trạng thái điều khiển | 0 (chỉ có bộ đếm) | **1** (`out`) | 0 (mode là chân vào) |
| Bit datapath | 8 | **16** | 8 |
| Mã hoá | BCD | **trạng thái = bit ra** | one-hot / Johnson |
| Tự sửa trạng thái bất hợp lệ | tác dụng phụ, kẹt khi `enable=0` | ngầm, ≤ 256 chu kỳ | **tường minh**, 1 chu kỳ |
| FF netlist / bit trạng thái RTL | 22 / 8 ❌ | **17 / 17 ✅** | 8 / 8 ✅ |

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*
