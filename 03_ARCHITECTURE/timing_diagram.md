# D03 · Giản đồ thời gian (Timing Diagram)

---

## 0. Giản đồ này lấy ở đâu ra

Suy ra **từng chu kỳ từ RTL thật** (`d03_core.sv` dòng 13–49), theo đúng chuỗi kích thích của
`05_VERIFICATION/testbench/d03_core_tb.sv`. Mô phỏng đã **PASS** (`simulation.log`:
`D03 core verification PASS`, `$finish` tại t = 1006), nên chuỗi giá trị dưới đây là chuỗi mà
testbench đã thực sự so khớp với mô hình chuẩn.

> ❗ Đây là mô phỏng **hành vi** (zero-delay): tín hiệu đổi **ngay** tại cạnh clock, độ rộng
> cổng = 0. Nó **không** minh hoạ độ trễ thật. Độ trễ thật của đường xấu nhất là **2,5 ns** sau
> tổng hợp (`sta/timing_report_max.txt`), và còn tăng sau routing.

Chu kỳ clock = 10 ns (`design.sdc`, **giả định**). Cạnh lên tại t = 5, 15, 25, … ns.

## 1. N = 3 — ca quan trọng nhất của đề (N lẻ)

Đánh số `k0` = chu kỳ có `load_n = 1`, rồi `k1`, `k2`, … là các chu kỳ sau đó.

```
 chu kỳ      k0    k1    k2    k3    k4    k5    k6    k7    k8    k9
            ┌─┐   ┌─┐   ┌─┐   ┌─┐   ┌─┐   ┌─┐   ┌─┐   ┌─┐   ┌─┐   ┌─┐
 clk     ───┘ └───┘ └───┘ └───┘ └───┘ └───┘ └───┘ └───┘ └───┘ └───┘ └───
            ┌─────┐
 load_n  ───┘     └────────────────────────────────────────────────────
 n_in    ─── 3 ───────────────────────────────────────────────────────

 ══════════════ GIÁ TRỊ SAU CẠNH CLOCK ═════════════════════════════════
 n_reg       3     3     3     3     3     3     3     3     3     3
 out         0     1     1     0     1     1     0     1     1     0
 phase       0     0     1     0     0     1     0     0     1     0
 count      00    00    01    00    00    01    00    00    01    00
 half_len    1     2     2     1     2     2     1     2     2     1
 (tổ hợp,  ↑out=0 ↑out=1                                                )
 ═══════════════════════════════════════════════════════════════════════

 out dạng sóng:
            ____       ______       ______       ______
 out     __|    |_____|      |_____|      |_____|      |__
           k0    k1 k2   k3    k4 k5   k6    k7 k8   k9
           └ 1 ─┘└─ 2 ──┘└ 1 ─┘└─ 2 ──┘
            THẤP   CAO    THẤP   CAO
            ⌊3/2⌋  ⌈3/2⌉
              1      2        ⟹ chu kỳ = 3 ✅   duty = 2/3 = 66,7 %
```

**Đọc giản đồ này thế nào:**

| Chu kỳ | Chuyện gì xảy ra | Nhánh RTL |
|---|---|---:|
| `k0` | `load_n=1` ⟹ `n_reg←3`, `phase←0`, `out←0` | 2 |
| `k1` | `out=0` ⟹ `half_len = ⌊3/2⌋ = 1`. `phase(0) == 1−1 = 0` ✓ ⟹ **lật**: `out←1`, `phase←0` | 4 |
| `k2` | `out=1` ⟹ `half_len = 3−1 = 2`. `phase(0) == 2−1 = 1`? ✗ ⟹ `phase←1` | 5 |
| `k3` | `phase(1) == 1` ✓ ⟹ **lật**: `out←0`, `phase←0` | 4 |
| `k4`… | lặp lại chu kỳ 3 | |

> ⭐ **Đây chính là chỗ cần soi kỹ.** `half_len` là **tổ hợp**, nó đổi giá trị **ngay khi `out`
> đổi**, trong cùng chu kỳ. Ở `k1`, tại thời điểm so sánh, `out` vẫn còn bằng 0 nên
> `half_len = 1`; ngay sau cạnh clock `out` thành 1 và `half_len` **nhảy sang 2** — kịp lúc cho
> phép so sánh ở `k2`. Nếu ai đó đăng ký `half_len` vào thanh ghi (thêm 1 chu kỳ trễ), chu kỳ
> ra sẽ **dài thêm 1** với mọi N. Đây là lỗi off-by-one tinh vi nhất của đề.

## 2. N = 2 — ca đối chứng (N chẵn, vế bất đối xứng bị tắt)

```
 chu kỳ      k0    k1    k2    k3    k4    k5
            ┌─┐   ┌─┐   ┌─┐   ┌─┐   ┌─┐   ┌─┐
 clk     ───┘ └───┘ └───┘ └───┘ └───┘ └───┘ └───
            ┌─────┐
 load_n  ───┘     └──────────────────────────────

 n_reg       2     2     2     2     2     2
 out         0     1     0     1     0     1
 phase       0     0     0     0     0     0     ← KHÔNG BAO GIỜ đếm lên
 half_len    1     1     1     1     1     1     ← HẰNG SỐ, không phụ thuộc out

 out:        ______      ______      ______
         ___|      |____|      |____|      |___
             └ 1 ─┘└ 1 ─┘         ⟹ chu kỳ = 2 ✅  duty = 50,0 %
```

**Vì sao ca này quan trọng dù "dễ":** với N=2, `⌈2/2⌉ = ⌊2/2⌋ = 1` nên `half_len` là **hằng
số** — vế bất đối xứng bị vô hiệu hoá hoàn toàn, và `phase` **không bao giờ khác 0**. Nếu N=2
chạy đúng mà N=3 chạy sai, ta biết ngay lỗi nằm ở **khối chọn `half_len`**, không phải ở khung
đếm. Đó là giá trị chẩn đoán của một ca đối chứng.

## 3. N = 1 — trường hợp đặc biệt: **không có xung**

```
 chu kỳ      k0    k1    k2    k3    k4
            ┌─┐   ┌─┐   ┌─┐   ┌─┐   ┌─┐
 clk     ───┘ └───┘ └───┘ └───┘ └───┘ └───
            ┌─────┐
 load_n  ───┘     └───────────────────────

 n_reg       1     1     1     1     1
 out         0     1     1     1     1     ← LÊN 1 RỒI ĐỨNG YÊN
 phase       0     0     0     0     0
 count      00    00    00    00    00     ← bị ép về 0 (RTL dòng 43–44)

 out:              ________________________
         _________|
                   ⟹ KHÔNG có chu kỳ. Tầng ngoài chờ cạnh lên sẽ TREO.
```

Đây là điểm W-1 ở `functional_spec.md`. Hành vi này **nhất quán** với cả hai mô hình chuẩn
(`d03_reference.sv` dòng 22–25, `reference_model.py` dòng 11–12) nên testbench PASS — nhưng
nó vẫn là một quyết định ngữ nghĩa cần thầy chốt và cần ghi vào tài liệu bàn giao.

## 4. Đổi N giữa chừng: 5 → 2 — hiện tượng **xung cụt**

Đúng chuỗi ở testbench dòng 65–68.

```
 chu kỳ      k0    k1    k2    k3    k4    k5    k6    k7 │ k8    k9    k10
            ┌─┐   ┌─┐   ┌─┐   ┌─┐   ┌─┐   ┌─┐   ┌─┐   ┌─┐│  ┌─┐   ┌─┐   ┌─┐
 clk     ───┘ └───┘ └───┘ └───┘ └───┘ └───┘ └───┘ └───┘ └┘  └─┘   └─┘   └───
            ┌─────┐                                     │┌────┐
 load_n  ───┘     └─────────────────────────────────────┘│    └──────────────
 n_in    ─── 5 ──────────────────────────────────────────│ 2 ───────────────
                                                         │
 n_reg       5     5     5     5     5     5     5     5 │  2     2     2
 out         0     0     1     1     1     0     0     1 │  0     1     0
 phase       0     1     0     1     2     0     1     0 │  0     0     0
 half_len    2     2     3     3     3     2     2     3 │  1     1     1
 ─────────────────────────────────────────────────────── │ ───────────────
 out:              ____________________                  │  ______
         _________|                    |________________|‾‾|      |____
                  └──── 3 chu kỳ ─────┘└── 2 chu kỳ ───┘│  └─1─┘
                       (⌈5/2⌉)            (⌊5/2⌋)        │
                                                         │
                             XUNG CỤT: out vừa lên ở k7, ĐÁNG LẼ phải giữ
                             cao 3 chu kỳ, nhưng load_n ở k8 ép nó về 0
                             sau ĐÚNG 1 chu kỳ.
```

**Đây là đáp án cho Charter mục 2 câu 2** (*"Thay đổi N khi đang chạy gây ra hiện tượng gì, và
mạch xử lý ra sao?"*):

| Hiện tượng | Mạch xử lý ra sao |
|---|---|
| Nửa chu kỳ đang chạy bị **cắt ngang** | `load_n` ép `phase←0` và `out←0` (RTL dòng 29–30) |
| Sinh ra **một xung cụt** ngắn hơn `⌈N_cũ/2⌉` | Không có cơ chế nào ngăn — đây là hành vi **được định nghĩa**, không phải lỗi |
| Pha của tín hiệu ra bị **đặt lại**, không liên tục | Cố ý: bảo đảm chu kỳ đầu tiên với N mới là chu kỳ **đầy đủ và đúng** |
| Mạch có treo không? | **Không.** Trạng thái mới hoàn toàn xác định, và chu kỳ kế tiếp đã đúng N mới |

**Đánh đổi đã chọn:** *pha bị gián đoạn một lần* để đổi lấy *chu kỳ mới đúng ngay lập tức*.
Phương án ngược lại (chờ hết nửa chu kỳ hiện tại rồi mới đổi) cần thêm một thanh ghi "N chờ"
+ logic so sánh — **+8 FF**. Xem `tradeoff.md` §2 phương án P3.

## 5. Đường tới hạn trên trục thời gian (số liệu thật)

```
  cạnh clk k                                              cạnh clk k+1
      │                                                        │
      │◀──────────────── chu kỳ 10,00 ns (GIẢ ĐỊNH) ──────────▶│
      │                                                        │
      │ clk→Q của _169_ (out)                                  │
      │◀── 0,30 ──▶│                                           │
      │            │ and3 ▶ xor2 ▶ or4 ▶ nor4 ▶ xnor3          │
      │            │      ▶ nand4 ▶ nand3b ▶ nor3b ▶ _167_/D   │
      │            │◀──────────── 2,20 ns logic ──────────────▶│
      │                                                        │
      │◀──────── arrival 2,50 ns ───────▶│                     │
      │                                  │◀── slack 7,42 ──▶│  │
      │                                                     │◀─▶ setup 0,08
      │                                              required 9,92 ns
```

Chú ý: **cả đường tới hạn nằm trong vòng điều khiển `out → half_len → so sánh → phase`** đã vẽ
ở `control.md` §1. Tức là phần đắt nhất về thời gian và phần trả lời Charter mục 9 là **cùng
một khối logic**.

Nguồn: `06_GDSII/sta/timing_report_max.txt`. Số này **chưa có ký sinh dây**, **chỉ một góc
PVT** (`tt_025C_1v80`), **skew clock = 0**. Không được diễn dịch thành tần số hoạt động.

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*
