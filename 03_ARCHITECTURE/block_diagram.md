# D03 · Sơ đồ khối (Block Diagram)

---

## 1. Bên trong D03 — vẽ theo **đúng** `d03_core.sv`

```
            ┌───────────────────────── d03_core ──────────────────────────────┐
            │                                                                 │
 n_in[7:0]─▶│──┐                                                              │
            │  │ ┌──────────────┐                                             │
            │  └▶│ n_in==0 ? 1  │──┐                                          │
            │    │   : n_in     │  │   ┌─────┐    ┌───────────────┐           │
            │    └──────────────┘  └──▶│ MUX │───▶│ REG n_reg[7:0]│──┬────────┼──┐
 load_n ───▶│───────────────────────┬─▶│ ưu  │    └───────────────┘  │        │  │
 rst_n  ───▶│───────────────────────┼─▶│ tiên│◀───────── hồi tiếp ───┘        │  │
            │                       │  └─────┘                               │  │
            │                       │                                        │  │
            │   ╔════════════ KHỐI XỬ LÝ N LẺ (tổ hợp thuần) ═══════════╗     │  │
            │   ║                                                       ║◀────┼──┘
            │   ║   n_reg ──▶[ >>1 ]──▶ ⌊N/2⌋ ────────────┐             ║     │
            │   ║              │                          │             ║     │
            │   ║              └──▶[ N − ⌊N/2⌋ ]──▶ ⌈N/2⌉ │             ║     │
            │   ║                   (bộ trừ 8 bit)        │             ║     │
            │   ║                                    ┌────▼────┐        ║     │
            │   ║   out ─────────────────────────S──▶│  MUX    │        ║     │
            │   ║                                    │  2 → 1  │        ║     │
            │   ║   n_reg ≤ 1 ──────────────────────▶│ (+hằng1)│        ║     │
            │   ║                                    └────┬────┘        ║     │
            │   ╚═════════════════════════════════════════│═════════════╝     │
            │                                   half_len  │                   │
            │                                             ▼                   │
            │   ┌──────────────┐   ┌───────────────────────────────┐          │
            │   │REG phase[7:0]│──▶│  SO SÁNH: phase == half_len−1 │──┐       │
            │   └──────▲───────┘   └───────────────────────────────┘  │       │
            │          │           ┌──────────┐                       │       │
            │          └───────────│ +1 / ←0  │◀──────────────────────┤       │
            │                      └──────────┘                       │       │
            │                                                         ▼       │
            │                              ┌──────────┐      ┌────────────┐   │
            │                              │ REG out  │◀─────│ lật / giữ  │   │
            │                              └────┬─────┘      └────────────┘   │
            │                                   │                             │
            │                                   ├────────────────────────────▶│──▶ out
            │                                   └──▶ (hồi tiếp chọn half_len) │
            │                                                                 │
            │   phase[6:0] ──▶[ n_reg==1 ? 0 : (phase>127 ? 7f : phase[6:0]) ]─┼──▶ count[6:0]
            └─────────────────────────────────────────────────────────────────┘
```

Bốn điều cần thấy ngay:

1. **Có một vòng hồi tiếp `out → half_len → so sánh → out`.** Đây là vòng đặc trưng của đề, và
   nó cũng chính là **đường tới hạn thật** theo STA (§4).
2. **`⌊N/2⌋` miễn phí, `⌈N/2⌉` mới tốn.** Chia 2 là phép dịch bit — 0 cổng. `N − ⌊N/2⌋` cần
   **một bộ trừ 8 bit** thật.
3. **`phase` so với `half_len − 1`, không phải với `half_len`.** Vì `phase` bắt đầu từ 0, nên
   đếm `half_len` nhịp nghĩa là chạm tới `half_len − 1`. Đây là chỗ dễ lệch 1 (off-by-one).
4. **`n_reg ≤ 1` không dùng bộ so sánh riêng** mà là một nhánh ưu tiên trong cùng cây mux
   `half_len` — RTL dòng 14.

## 2. Ánh xạ cấu trúc RTL → phần cứng sinh ra

| Cấu trúc RTL | Dòng | Phần cứng | Ghi chú |
|---|---:|---|---|
| `logic [7:0] n_reg;` | 9 | **8 FF** | Netlist: `_170_`…`_177_`, Q = `n_reg[0..7]` |
| `logic [7:0] phase;` | 10 | **8 FF** | Netlist: `_161_`…`_168_`, Q = `phase[0..7]` |
| `output logic out;` | 6 | **1 FF** | Netlist: `_169_`, Q = `out` — **là thanh ghi, không phải tổ hợp** ⟹ Moore |
| `n_reg / 2` | 17, 19 | **0 cổng** — dịch phải 1 bit, chỉ là đánh lại chỉ số dây | Điều này giải thích vì sao bộ chia tần "chia cho 2" luôn rẻ nhất |
| `n_reg - (n_reg / 2)` | 17 | **Bộ trừ 8 bit** | Đây là khối đắt nhất của phần xử lý N lẻ |
| `if/else if/else` chọn `half_len` | 14–19 | **Mux 2→1 rộng 8 bit + một nhánh hằng** | Tín hiệu chọn là `out` |
| `phase == half_len - 8'd1` | 34 | **Bộ trừ hằng 1 + bộ so sánh bằng 8 bit** | So sánh bằng ⟹ cây XNOR rồi AND-reduce. Netlist có `xnor2_1`×6, `xnor3_1`×4, `xor2_1`×5, `xor3_1`×1 — đúng dấu vết của cây so sánh |
| `phase <= phase + 8'd1` | 38 | **Bộ tăng 8 bit** | |
| `out <= ~out` | 36 | **1 cổng đảo** (thực tế bị hợp nhất vào mux) | |
| `if (!rst_n) … else if (load_n) … else if …` | 23–39 | **Cây mux ưu tiên 4 tầng** lái chân `D` của cả 17 FF | `dfxtp_1` **không có** chân enable/reset ⟹ mọi thứ phải hiện thực bằng mux hồi tiếp |
| `count = …` | 42–49 | **Mux 3→1 rộng 7 bit** (tổ hợp thuần) | Một nhánh là **chết** (INV-8) |

## 3. Kết quả tổng hợp thật

| Chỉ số | Giá trị | Nguồn |
|---|---:|---|
| Tổng cell | **101** | `synthesis/synth_stat.txt` |
| Flip-flop (`dfxtp_1`) | **17** | như trên — **khớp chính xác** 17 bit trạng thái của RTL |
| Cell tổ hợp | **84** | 101 − 17 |
| Diện tích | **975,936 µm²** | như trên |
| Công suất | 9,81e-05 W — tổ hợp **24,1 %**, tuần tự **75,9 %** | `power/power_report.txt` |

> ⚠️ Bảng "Phân bố cell" trong `BRIEF D03` chỉ liệt kê **18 loại cell nhiều nhất** (cộng lại
> được 94/101). Danh sách **đầy đủ 25 loại** nằm trong `synth_stat.txt` và trong
> `physical_report.md` §2. Khi trích dẫn, dùng `synth_stat.txt` làm chuẩn.

**Điểm đáng ghi nhận:** 17 FF trong netlist **bằng đúng** 17 bit trạng thái trong RTL, và bằng
đúng con số Charter mục 10 nêu là dấu hiệu làm đúng ("8 + 8 + 1 ≈ 17–18"). Không có ô nhớ thừa
nào do công cụ sinh ra — khác hẳn đề D02 (22 FF cho 8 bit trạng thái).

## 4. Khối con nào nằm trên đường tới hạn

Đối chiếu `06_GDSII/sta/timing_report_max.txt` — đường xấu nhất:

```
  _169_/Q (out)  ─▶ _081_ and3_1   ─▶ _083_ xor2_1  ─▶ _093_ or4_1
                 ─▶ _106_ nor4_1   ─▶ _109_ xnor3_1 ─▶ _110_ nand4_1
                 ─▶ _111_ nand3b_1 ─▶ _128_ nor3b_1 ─▶ _167_/D (phase[6])

  arrival 2,50 ns · required 9,92 ns · slack 7,42 ns (MET) · 10 cell (8 tổ hợp)
```

| Đoạn | Thuộc khối con nào | Bằng chứng |
|---|---|---|
| `_169_/Q` = `out`, fanout **6** | **Bit trạng thái điều khiển** | `netlist.v`: `dfxtp_1 _169_ ( .Q(out) )` |
| `_081_ and3_1` → `_083_ xor2_1` | **Khối xử lý N lẻ**: `out` chọn giữa `⌊N/2⌋` và `⌈N/2⌉`, rồi bộ trừ | `xor2` là dấu vết của phép trừ/cộng |
| `_093_ or4_1` → `_106_ nor4_1` → `_109_ xnor3_1` → `_110_ nand4_1` → `_111_ nand3b_1` | **Bộ so sánh `phase == half_len − 1`** — cây XNOR + AND-reduce 8 bit | `xnor3`, `nand4`, `or4` là cấu trúc cây so sánh điển hình |
| `_128_ nor3b_1` → `_167_/D` | **Mux ưu tiên lái `phase[6]`** | `_167_/Q = phase[6]` |

### ⭐ Kết luận quan trọng nhất về kiến trúc D03

> **Đường tới hạn của D03 chạy XUYÊN QUA đúng khối logic xử lý N lẻ.** Nó bắt đầu ở bit `out`
> — tín hiệu **duy nhất** chọn giữa nửa chu kỳ cao và nửa chu kỳ thấp — rồi đi qua bộ trừ, bộ
> so sánh, và kết thúc ở thanh ghi pha.

Đây không phải trùng hợp. Nếu duty luôn 50 % (chỉ hỗ trợ N chẵn), `half_len` sẽ là hằng số
`n_reg >> 1`, tín hiệu `out` **biến mất khỏi** đường này, và đường tới hạn sẽ bắt đầu ở
`n_reg` — ngắn hơn ít nhất hai cổng (`and3` + `xor2`). Nói cách khác: **cái giá về thời gian
của việc hỗ trợ N lẻ nằm ở hai tầng cổng đầu của đường tới hạn.**

Xem `datapath.md` §5 để có con số diện tích của chính khối này.

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*
