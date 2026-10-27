# D03 · Đường dữ liệu (Datapath)

---

## 1. Bảng các đường dữ liệu

| Đường | Độ rộng | Từ | Đến | Bản chất |
|---|---:|---|---|---|
| `n_in[7:0]` | 8 | cổng vào | mux nạp | Hệ số chia đề nghị |
| `n_reg[7:0]` | 8 | REG | bộ dịch, bộ trừ, so sánh `≤1`, hồi tiếp, logic `count` | **Hằng số chốt lúc chạy** |
| `n_reg >> 1` | 8 | dây (dịch bit) | mux `half_len` | `⌊N/2⌋` — **0 cổng** |
| `n_reg − (n_reg>>1)` | 8 | bộ trừ 8 bit | mux `half_len` | `⌈N/2⌉` — khối đắt nhất của phần N lẻ |
| `half_len[7:0]` | 8 | mux 2→1 (+hằng 1) | bộ so sánh | **Độ dài nửa chu kỳ hiện tại** |
| `half_len − 1` | 8 | bộ trừ hằng | bộ so sánh | Vì `phase` đếm từ 0 |
| `phase[7:0]` | 8 | REG | bộ so sánh, bộ tăng, `count` | **Bộ đếm pha** |
| `phase == half_len−1` | **1** | bộ so sánh bằng | điều khiển `out` và `phase` | **Tín hiệu điều khiển duy nhất sinh từ datapath** |
| `out` | 1 | REG | cổng ra **và** chân chọn của mux `half_len` | **Vừa là dữ liệu ra, vừa là điều khiển** |
| `count[6:0]` | 7 | mux 3→1 | cổng ra | Cổng quan sát |

> **Điểm bản chất:** `out` là tín hiệu **lưỡng dụng**. Nó là kết quả cần xuất ra, đồng thời là
> bit trạng thái quyết định nửa chu kỳ tiếp theo dài bao nhiêu. Chính tính lưỡng dụng này tạo
> ra vòng hồi tiếp `out → half_len → so sánh → out` — vòng dài nhất trong mạch.

## 2. Đồ thị phụ thuộc

```
 mức 0    n_reg[7:0] (Q)            phase[7:0] (Q)            out (Q)
              │                          │                      │
              ├──▶[ >>1 ]──┐             │                      │
 mức 1        │   (0 cổng) │             │                      │
              │            ▼             │                      │
              └──▶[ N − ⌊N/2⌋ ]          │                      │
 mức 2             (bộ trừ)              │                      │
                       │                 │                      │
                       ▼                 │                      │
 mức 3          ┌──────────────┐◀────────┼──────── chọn ────────┘
                │ MUX half_len │         │
                └──────┬───────┘         │
 mức 4                 │                 │
                 [ half_len − 1 ]         │
 mức 5                 │                 │
                       ▼                 ▼
                ┌────────────────────────────┐
                │ SO SÁNH BẰNG 8 bit         │   ← cây XNOR + AND-reduce
                │ (xnor2/xnor3 → nand4/or4)  │
 mức 6..8       └──────────────┬─────────────┘
                               │ (1 bit)
              ┌────────────────┼───────────────────┐
              ▼                                    ▼
 mức 9  D(phase[7:0])                          D(out)
        (0 hoặc phase+1)                       (giữ hoặc ~out)
```

**Độ sâu logic dự đoán từ RTL:**

| Đầu ra | Độ sâu (từ Q của thanh ghi) |
|---|---|
| `count[6:0]` | 1–2 mức (mux 3→1) — **nông nhất** |
| `out` (cổng ra) | **0** — là Q của flip-flop, chỉ là dây |
| `D(phase[i])` xuất phát từ `n_reg` | dịch (0) + trừ (~4) + mux (1) + trừ 1 (~2) + so sánh (~3) + mux (1) ≈ **11 mức** |
| `D(phase[i])` xuất phát từ `out` | mux (1) + trừ 1 (~2) + so sánh (~3) + mux (1) ≈ **7 mức**, **nhưng** `out` có fanout 6 và phải lái cả bộ trừ |
| `D(out)` | như `D(phase)` rồi thêm 1 mức |

## 3. Dự đoán đường tới hạn — và đối chiếu STA thật

### Dự đoán từ RTL

> Đường dài nhất nên bắt đầu ở `n_reg`, vì chỉ `n_reg` mới phải đi qua **cả bộ trừ 8 bit lẫn
> bộ so sánh 8 bit**. `out` chỉ đi qua mux rồi so sánh, ngắn hơn khoảng 4 mức.

### Kết quả STA thật

```
Startpoint: _169_  (= flip-flop  out)
Endpoint:   _167_  (= flip-flop  phase[6])
arrival 2,50 ns · required 9,92 ns · slack 7,42 ns (MET)

_169_/Q ▶ _081_ and3_1 ▶ _083_ xor2_1 ▶ _093_ or4_1 ▶ _106_ nor4_1
        ▶ _109_ xnor3_1 ▶ _110_ nand4_1 ▶ _111_ nand3b_1 ▶ _128_ nor3b_1 ▶ _167_/D
```

### Dự đoán **sai ở đâu**, và vì sao

| Điểm | Dự đoán | STA thật | Giải thích |
|---|---|---|---|
| Startpoint | `n_reg` | **`out`** | Hai lý do cộng lại. (a) `out` có **fanout 6** và độ trễ clk→Q **0,30 ns** (đọc từ dòng `_169_/Q` trong `timing_report_max.txt`) — nó phải lái cả cây `half_len`. (b) Quan trọng hơn: `abc` đã **hợp nhất** bộ trừ và mux `half_len` thành một khối logic chung, nên `out` **không** đi vòng ngoài mà chui **thẳng vào trong** phần trừ — cell thứ hai trên đường đi đã là `_083_ xor2_1`. Ranh giới "mux rồi mới trừ" trong RTL **không tồn tại** trong netlist |
| Endpoint | `out` hoặc `phase[0]` | **`phase[6]`** | Bit 6 là bit cao thứ hai; cây so sánh bằng phải AND-reduce đủ 8 bit trước khi bit nào của `phase` được cập nhật, nên mọi bit `phase` có độ sâu tương đương. `phase[6]` thắng do khác biệt nhỏ về tải/cell |
| Thành phần | trừ + so sánh | **đúng**: `xor2` (trừ) rồi `or4`/`nor4`/`xnor3`/`nand4`/`nand3b` (cây so sánh) | Dự đoán về **nội dung** đường đi là đúng; chỉ sai về **điểm xuất phát** |

**Bài học:** khi công cụ hợp nhất hai khối RTL liền nhau (mux + bộ trừ), tín hiệu chọn của mux
có thể **chui sâu** vào trong khối kia thay vì đứng trước nó. Ranh giới khối trong RTL là ranh
giới **để người đọc hiểu**, không phải ranh giới vật lý. Khi lệch, **tin STA**.

## 4. Vì sao độ trễ 2,5 ns ở đây **không** trả lời được Charter mục 2 câu 3

Charter mục 2 câu 3 hỏi: *"Bộ chia tần này chạy được tối đa bao nhiêu MHz?"*

**Câu trả lời trung thực: chưa trả lời được bằng số liệu hiện có.** Lý do:

| Yếu tố | Trạng thái hiện tại | Ảnh hưởng tới fmax |
|---|---|---|
| Ký sinh dây (RC) | **Chưa có** — mới sau tổng hợp | Độ trễ thật **sẽ lớn hơn** 2,5 ns |
| Góc PVT | Chỉ `tt_025C_1v80` | Góc `ss` (chậm) chậm hơn đáng kể |
| Cây clock | **Chưa CTS** — skew giả định = 0 | Skew thật ăn vào biên setup và tạo rủi ro hold |
| Chu kỳ 10 ns | **Giả định khởi điểm** trong `design.sdc`, không phải yêu cầu hệ thống | Con số slack 7,42 ns chỉ có nghĩa **với giả định đó** |

**Những gì được phép nói:** *"Với chu kỳ giả định 10 ns, góc `tt_025C_1v80`, sau tổng hợp và
chưa có ký sinh dây, đường xấu nhất có arrival 2,5 ns và slack +7,42 ns; `wns = tns = 0,00`
nên không có vi phạm setup nào ở điều kiện đó."*

**Những gì KHÔNG được nói:** *"D03 chạy được ở 400 MHz"* — phát biểu vượt mức, vi phạm Charter
mục 6.

Muốn trả lời câu hỏi của Charter, cần: chạy LibreLane tới bước routing → trích RC → chạy lại
STA ở ≥ 3 góc PVT → quét chu kỳ giảm dần tới khi slack chạm 0. Việc này **chưa chạy**.

## 5. 🔎 Charter mục 9 — Phần logic nào phụ trách N lẻ, và nó tốn bao nhiêu

> *"Nêu rõ cách thiết kế xử lý N lẻ, và **chỉ ra phần logic phụ trách việc đó**."*

### Cách thiết kế xử lý N lẻ

`half_len` **thay đổi theo mức của `out`** (RTL dòng 13–20):

```systemverilog
if (n_reg <= 8'd1)      half_len = 8'd1;
else if (out)           half_len = n_reg - (n_reg / 2);   // ⌈N/2⌉ — nửa chu kỳ CAO
else                    half_len = n_reg / 2;             // ⌊N/2⌋ — nửa chu kỳ THẤP
```

Vì `⌈N/2⌉ + ⌊N/2⌋ = N` với **mọi** số nguyên N, chu kỳ ra **luôn đúng N** kể cả khi N lẻ. Phần
lẻ được dồn vào **nửa chu kỳ cao**. Đây là lựa chọn có chủ ý, không phải tai nạn: nó nhất quán
với cả hai mô hình chuẩn (`d03_reference.sv` dòng 27–30 và `reference_model.py` dòng 14–16).

### Phần logic phụ trách — định vị chính xác

| Cách định vị | Kết quả |
|---|---|
| **Trong RTL** | 7 dòng: `d03_core.sv` dòng 13–20 (khối `always_comb` đầu tiên) |
| **Trong netlist** — các cell nằm trong **nón fan-out** của tín hiệu `out` | **42 cell tổ hợp**, diện tích **341,5776 µm²** = **35,0 %** tổng diện tích |
| **Trong STA** | **2 cell đầu tiên** của đường tới hạn (`_081_ and3_1`, `_083_ xor2_1`) nằm ngay sau `out` |

Phương pháp đo nón fan-out: đọc `06_GDSII/synthesis/netlist.v`, dựng đồ thị driver → tải, lan
truyền từ net `out`, dừng ở chân `D` của flip-flop. Diện tích lấy từ liberty mà
`synthesis/synth.ys` tham chiếu; tổng toàn thiết kế tính lại được **975,936 µm²**, **trùng
khít** con số Yosys báo trong `synth_stat.txt` — đó là phép tự kiểm.

Thành phần 42 cell đó:

| Loại cell | SL | Vai trò suy đoán |
|---|---:|---|
| `xnor2_1`×3, `xnor3_1`×4, `xor2_1`×3, `xor3_1`×1 | 11 | Bộ trừ `N − ⌊N/2⌋` và cây so sánh bằng |
| `nor2_1`×9, `nor3_1`×3, `nor4_1`×2, `nand2_1`×1, `nand3_1`×1, `nand4_1`×2, `nand3b_1`×1, `nor3b_1`×1, `and3_1`×1, `and4_1`×1, `or4_1`×1 | 23 | AND/OR-reduce của cây so sánh |
| `mux2_1`×1, `a21oi_1`×2, `a31oi_1`×1, `o21a_1`×1, `o21bai_1`×1 | 6 | Chọn `half_len` và lái `D` |
| `lpflow_isobufsrc_1`×2 | 2 | Đệm |

### Đọc con số này cho đúng

| Con số | Chứng minh điều gì | **KHÔNG** chứng minh điều gì |
|---|---|---|
| **35,0 %** diện tích nằm trong nón fan-out của `out` | Phần logic phụ thuộc mức ra hiện tại là **đáng kể**, không phải "vài cổng" | ⚠️ Đây là **chặn trên**, không phải chi phí gia tăng. Cây so sánh 8 bit **vẫn cần** ngay cả khi duty luôn 50 % — nó chỉ không cần chân `out` nữa |
| 2 cell đầu đường tới hạn thuộc phần này | Hỗ trợ N lẻ có **giá về thời gian**, đo được | Không chứng minh bỏ nó đi sẽ nhanh hơn đúng 2 cổng |
| 17 FF = 17 bit trạng thái RTL | Không có ô nhớ thừa; bit `out` đóng **cả hai vai** (ra + điều khiển) nên không cần thêm FF cho phần N lẻ | — |

**Chi phí gia tăng thật sự** của việc hỗ trợ N lẻ = (diện tích bản hiện tại) − (diện tích bản
chỉ hỗ trợ duty 50 %). Muốn có con số đó phải **tổng hợp lại** một phiên bản rút gọn —
**chưa chạy** trong hồ sơ này. Không được ước lượng bừa.

### Vì sao đây là "chỗ hay bị làm sai" (Charter mục 10)

Ba cách làm sai thường gặp, và hậu quả đo được:

| Cách làm sai | Hậu quả |
|---|---|
| `half_len = n_reg / 2` cố định | N=3 cho chu kỳ **2** thay vì 3 — sai 33 %. Bộ ghi dữ liệu lấy mẫu nhanh hơn cấu hình |
| `half_len = (n_reg + 1) / 2` cố định | N=3 cho chu kỳ **4** — sai theo chiều ngược lại |
| Chia N cho 2 rồi **ép duty 50 %** bằng cách bỏ qua bit lẻ | Chu kỳ sai với **mọi** N lẻ; và người làm thường **không nêu ra**, đó chính là điều Charter mục 10 phạt |
| Giấu vấn đề bằng cách chỉ kiểm N chẵn | Testbench "PASS" nhưng vô giá trị. Ca C-3 (N=3) tồn tại chính để chặn điều này |

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*
