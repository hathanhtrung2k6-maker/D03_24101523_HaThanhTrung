# D03 · Đặc tả chức năng (Functional Spec)

> ✅ **ĐỐI CHIẾU CHARTER — kết quả**
>
> | # | Yêu cầu Charter | RTL thực tế | Trạng thái |
> |---|---|---|---|
> | K-1 | Mục 4: `ui_in[7:0]` = N | `n_in[7:0]`, 8 bit vào | ✅ THOẢ |
> | K-2 | Mục 4: `uio_in[0]` = nạp N | `load_n`, 1 bit vào | ✅ THOẢ |
> | K-3 | Mục 4: `uo_out[0]` = xung ra | `out`, 1 bit ra | ✅ THOẢ |
> | K-4 | Mục 4: `uo_out[7:1]` = giá trị đếm hiện tại | `count[6:0]`, 7 bit ra | ✅ THOẢ |
> | K-5 | Mục 4: ngân sách 9 bit vào + 8 bit ra = 17/24 chân | 11 bit vào (gồm `clk`, `rst_n`) + 8 bit ra = 19/24 | ✅ THOẢ, còn dư 5 chân |
> | K-6 | Mục 10, dấu hiệu làm đúng: 8 đếm + 8 giữ N + 1 xung ra ≈ **17–18 ô nhớ** | RTL: `phase[7:0]` + `n_reg[7:0]` + `out` = **17 bit**; netlist: **17 flip-flop** | ✅ **THOẢ chính xác** |
> | K-7 | Mục 3: không chia phân số, không bù pha, không PLL | RTL chỉ dùng bộ đếm số nguyên | ✅ THOẢ |
>
> ⚠️ **Ba điểm cần thầy chốt** (không phải vi phạm, là quyết định ngữ nghĩa):
>
> - **W-1 · `N = 1` KHÔNG cho ra xung clock.** Nhánh `n_reg == 8'd1` (RTL dòng 31–33) ép
>   `out <= 1'b1` mỗi chu kỳ ⟹ `out` **đứng yên ở mức CAO**, không phải một tín hiệu 1:1 của
>   `clk`. Điều này nhất quán với cả hai mô hình chuẩn, nhưng người đọc đề rất dễ hiểu "chia 1"
>   là "truyền thẳng clock". Cần ghi rõ trong tài liệu bàn giao.
> - **W-2 · `interface.md` §2 (sinh tự động) ghi "Không có reset — không có trạng thái để đặt
>   lại".** Dòng này **sai**: `rst_n` tồn tại và là reset **đồng bộ** (nằm trong `always_ff
>   @(posedge clk)`). Đây là lỗi mẫu sinh tự động; tài liệu này lấy RTL làm chuẩn.
> - **W-3 · Nạp N giữa chừng cắt ngang chu kỳ đang chạy** (`load_n` ép `phase←0`, `out←0`).
>   Không có cơ chế chuyển đổi không gián đoạn (glitch-free). Xem §7.

---

## 1. Chức năng ở một câu

D03 nhận một số nguyên **N ∈ [1, 255]**, và sinh ra trên `out` một tín hiệu vuông có **chu kỳ
đúng N chu kỳ `clk`** (với N ≥ 2), chia **không đều** giữa mức cao và mức thấp khi N lẻ.
`count[6:0]` phát ra giá trị bộ đếm pha hiện tại để quan sát/gỡ lỗi từ bên ngoài.

## 2. Trạng thái

| Thành phần | Độ rộng | Miền giá trị | Ý nghĩa |
|---|---:|---|---|
| `n_reg` | 8 bit | 1 … 255 | Hệ số chia **đã chốt** (N = 0 bị ánh xạ thành 1) |
| `phase` | 8 bit | 0 … 127 | Bộ đếm pha **trong nửa chu kỳ hiện tại** |
| `out` | 1 bit | 0 / 1 | Mức ra hiện tại — đồng thời là **bit trạng thái điều khiển** chọn độ dài nửa chu kỳ |

Tổng **17 bit trạng thái** ⟹ khớp chính xác netlist (17 `dfxtp_1`).

## 3. Định nghĩa hành vi — bảng chuyển trạng thái

Đọc trực tiếp từ `always_ff` (RTL dòng 22–40), theo thứ tự ưu tiên:

| Ưu tiên | Điều kiện | `n_reg'` | `phase'` | `out'` |
|---:|---|---|---|---|
| 1 | `!rst_n` | `1` | `0` | `0` |
| 2 | `rst_n && load_n` | `(n_in == 0) ? 1 : n_in` | `0` | `0` |
| 3 | `rst_n && !load_n && n_reg == 1` | giữ | `0` | **`1`** |
| 4 | `rst_n && !load_n && n_reg ≥ 2 && phase == half_len − 1` | giữ | `0` | `~out` |
| 5 | còn lại | giữ | `phase + 1` | giữ |

với `half_len` là tổ hợp thuần (RTL dòng 13–20):

```
                 ⎧ 1                      nếu n_reg ≤ 1
  half_len   =   ⎨ n_reg − ⌊n_reg/2⌋      nếu out = 1     ← nửa chu kỳ CAO = ⌈N/2⌉
                 ⎩ ⌊n_reg/2⌋              nếu out = 0     ← nửa chu kỳ THẤP = ⌊N/2⌋
```

> 🔎 **Đây là toàn bộ cơ chế xử lý N lẻ**, và nó chỉ gói gọn trong ba dòng `if/else if/else`.
> `out` vừa là đầu ra **vừa là tín hiệu chọn** cho `half_len`. Đọc kỹ `03_ARCHITECTURE/control.md` §3.

### Đầu ra `count` (RTL dòng 42–49)

```
          ⎧ 7'd0          nếu n_reg == 1
  count = ⎨ 7'h7f         nếu phase > 127      ← nhánh CHẾT, xem INV-8
          ⎩ phase[6:0]    còn lại
```

## 4. Đặc tả dạng sóng ra

Với `N ≥ 2`, sau khi nạp hoặc sau reset:

| Đại lượng | Công thức | N=2 | N=3 | N=4 | N=5 | N=254 | N=255 |
|---|---|---:|---:|---:|---:|---:|---:|
| Số chu kỳ `out = 1` | `⌈N/2⌉` | 1 | **2** | 2 | **3** | 127 | **128** |
| Số chu kỳ `out = 0` | `⌊N/2⌋` | 1 | **1** | 2 | **2** | 127 | **127** |
| Chu kỳ tổng | `N` | 2 | 3 | 4 | 5 | 254 | 255 |
| Chu kỳ nhiệm vụ (duty) | `⌈N/2⌉ / N` | 50,0 % | **66,7 %** | 50,0 % | **60,0 %** | 50,0 % | **50,196 %** |

**Với N = 1** (trường hợp đặc biệt, W-1): `out ≡ 1` vĩnh viễn, `count ≡ 0`, không có chu kỳ.

## 5. Ràng buộc cấu trúc bắt buộc

| # | Ràng buộc | Nguồn | Thoả? |
|---|---|---|---|
| S-1 | Hệ số chia phải **lập trình được lúc chạy**, không phải tham số biên dịch | Tên đề | ✅ `n_reg` là thanh ghi, nạp qua `load_n` |
| S-2 | Chu kỳ ra phải **đúng N**, không xấp xỉ | Tên đề | ✅ `⌈N/2⌉ + ⌊N/2⌋ = N` với mọi N nguyên |
| S-3 | Chia **số nguyên**, không phân số, không bù pha | Charter mục 3 | ✅ chỉ có bộ đếm và so sánh |
| S-4 | Phải **nêu ra** cách xử lý N lẻ chứ không giấu | Charter mục 10 | ✅ §3, §4 và `datapath.md` §5 |

## 6. Tính chất bất biến (invariants)

| # | Phát biểu | Dạng assertion đề nghị |
|---|---|---|
| **INV-1** | `1 ≤ n_reg ≤ 255` luôn đúng sau reset (giá trị 0 bị ánh xạ thành 1) | `assert property (@(posedge clk) disable iff(!rst_n) n_reg >= 1);` |
| **INV-2** | `0 ≤ phase ≤ 127` — chặn trên vì `phase < half_len ≤ ⌈255/2⌉ = 128` | `assert property (phase <= 8'd127);` |
| **INV-3** | `half_len ≥ 1` luôn ⟹ `half_len − 1` **không bao giờ tràn ngược** | `assert property (half_len >= 1);` |
| **INV-4** | Với `n_reg ≥ 2`: khoảng cách giữa hai cạnh lên liên tiếp của `out` = **đúng `n_reg`** chu kỳ | assertion đếm chu kỳ giữa hai `$rose(out)` |
| **INV-5** | Với `n_reg ≥ 2`: số chu kỳ `out=1` = `⌈n_reg/2⌉`, số chu kỳ `out=0` = `⌊n_reg/2⌋` | như trên |
| **INV-6** | `n_reg == 1` ⟹ `out ≡ 1` và `phase ≡ 0` và `count ≡ 0` | `assert property (n_reg==1 |-> out && phase==0);` |
| **INV-7** | `load_n` ⟹ chu kỳ kế tiếp có `phase == 0` và `out == 0` (đồng bộ lại pha) | `assert property (load_n |=> (phase==0 && !out));` |
| **INV-8** | Nhánh `phase > 8'd127` là **không thể đạt tới** (suy ra từ INV-2) ⟹ `count` luôn bằng `phase[6:0]` khi `n_reg ≥ 2` | `assert property (phase <= 127);` — nếu INV-2 đúng thì nhánh này chết |
| **INV-9** | `out` chỉ đổi tại cạnh lên `clk` và **không có** đường tổ hợp từ `n_in`/`load_n` tới `out` ⟹ **Moore** | kiểm netlist: `out` là Q của `_169_` |
| **INV-10** | `load_n` **thắng** mọi thứ trừ `rst_n` | `assert property (load_n && rst_n |=> n_reg == (n_in==0 ? 1 : n_in));` |

## 7. Điều kiện biên và hành vi không xác định

| Tình huống | Hành vi thật | Ghi chú |
|---|---|---|
| `n_in = 0` khi `load_n = 1` | Ánh xạ thành `n_reg = 1` (RTL dòng 28) | "Chia 0" được định nghĩa an toàn thay vì để treo |
| `N = 1` | `out ≡ 1`, **không có xung** | ⚠️ W-1 — xem §4 |
| `N = 2` | Duty đúng 50 %, chu kỳ 2 | Ca dễ nhất |
| `N = 255` | Cao 128, thấp 127, duty 50,196 % | `phase` chạm đúng giá trị lớn nhất **127** ⟹ ca biên của INV-2 |
| **Đổi N giữa chừng** | `load_n` ép `phase←0`, `out←0` ngay ⟹ **cắt ngang** nửa chu kỳ đang chạy | Có thể sinh **một xung cụt** (ngắn hơn `⌈N_cũ/2⌉`). Đây là đáp án cho Charter mục 2 câu 2 |
| Đổi N thành **cùng giá trị cũ** | Vẫn reset pha | Không có tối ưu "nạp giá trị giống nhau thì bỏ qua" |
| Trước cạnh clock đầu tiên | `n_reg`, `phase`, `out` = `X`; `count` = `X` | Reset **đồng bộ** không cứu được trước cạnh đầu |
| `rst_n` xung hẹp hơn 1 chu kỳ | **Bị bỏ qua hoàn toàn** | Reset đồng bộ — hợp đồng với tầng ngoài |
| `n_in` đổi khi `load_n = 0` | Không ảnh hưởng gì | `n_reg` chỉ cập nhật khi `load_n = 1` |

## 8. Độ trễ từ đầu vào tới đầu ra

| Đường | Độ trễ |
|---|---|
| `load_n` / `n_in` → `n_reg` | **1 chu kỳ** |
| `load_n` → `out` về 0 | **1 chu kỳ** |
| `rst_n` → trạng thái đặt lại | **1 chu kỳ** (reset đồng bộ) |
| trạng thái → `count` | **0 chu kỳ** (tổ hợp) |
| trạng thái → `out` | **0 chu kỳ** — `out` **là** bit trạng thái, không qua logic |
| `load_n` → cạnh lên đầu tiên của `out` | `1 + ⌊N/2⌋` chu kỳ |

```
   load_n=1 tại cạnh k
        │
        ▼
   cạnh k:  n_reg←N, phase←0, out←0
   cạnh k+1 … k+⌊N/2⌋ : đếm pha thấp
   cạnh k+⌊N/2⌋ : phase==half_len−1 ⟹ out←1   ← cạnh lên đầu tiên
```

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*
