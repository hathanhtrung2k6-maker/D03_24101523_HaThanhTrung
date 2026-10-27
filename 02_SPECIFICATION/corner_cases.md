# D03 · Ca biên và ca kiểm thử (Corner Cases)

---

## 0. Trạng thái bằng chứng

Mô phỏng RTL **PASS** (`05_VERIFICATION/simulation.log`: `D03 core verification PASS`,
`$finish` tại t = 1006). Mô hình chuẩn Python **PASS**. Mọi ô "✅ có" dưới đây nghĩa là ca đó
**đã chạy và đã đạt**.

Cảnh báo biên dịch (không phải lỗi):

```
d03_core.sv:42:      sorry: constant selects in always_* processes are not currently
d03_reference.sv:41: supported (all bits will be included).
```

Đây là hạn chế cách Icarus dựng **danh sách nhạy ngầm** cho `always_comb` khi gặp
`phase[6:0]`: nó đưa **toàn bộ** các bit của `phase` vào danh sách nhạy thay vì chỉ 7 bit thấp.
Kết quả là `always_comb` được kích hoạt **thường xuyên hơn cần thiết** — thừa, **không sai**.
Không ảnh hưởng kết quả; mô phỏng vẫn PASS.

## 1. Ca bắt buộc theo Charter mục 8 — và **vì sao** mỗi ca được chọn

| # | Ca | Lý do kỹ thuật | Có trong `d03_core_tb.sv`? |
|---|---|---|---|
| C-1 | **N = 1** | Kích hoạt nhánh **đặc biệt** duy nhất của RTL (dòng 31–33), nhánh này bỏ qua hoàn toàn cơ chế `half_len`. Đồng thời phơi bày quyết định ngữ nghĩa W-1: "chia 1" cho `out ≡ 1`, **không** cho xung. | ✅ dòng 52–53 (`load_and_check(8'd1)` + 4 nhịp) |
| C-2 | **N = 2** | N chẵn nhỏ nhất — `⌈N/2⌉ = ⌊N/2⌋ = 1` ⟹ duty đúng 50 %, `half_len` **không đổi** theo `out`. Ca này chứng minh mạch chạy đúng **khi vế bất đối xứng bị tắt**. Nếu N=2 sai thì lỗi nằm ở khung đếm, không phải ở logic N lẻ. | ✅ dòng 55–56 |
| C-3 | **N = 3 (lẻ)** | Ca **quan trọng nhất của đề**. N lẻ nhỏ nhất ⟹ `half_len` phải nhận **hai giá trị khác nhau** (2 và 1) tuỳ theo `out`. Nếu ai đó viết `half_len = n_reg/2` cố định, N=3 sẽ cho chu kỳ 2 thay vì 3 — sai 33 %. Ca N=2 **không** bắt được lỗi này. | ✅ dòng 58–59 (12 nhịp = 4 chu kỳ đầy đủ) |
| C-4 | **N = 255** | Ca biên trên. Hai lý do: (a) `n_reg` chạm giá trị lớn nhất biểu diễn được trong 8 bit; (b) `phase` chạm **đúng 127** — giá trị lớn nhất mà `count[6:0]` biểu diễn được. Đây là ca chứng minh INV-2 và cho thấy nhánh bão hoà `phase > 127` là nhánh chết. | ✅ dòng 61–62 |
| C-5 | **Thay đổi N khi đang chạy** | Kiểm nhánh ưu tiên 2 và hệ quả của nó: `phase←0`, `out←0`. Đây là đáp án cho Charter mục 2 câu 2. Ca này còn kiểm rằng `n_reg` cũ **không** rò rỉ sang chu kỳ mới. | ✅ dòng 65–68 (N=5 → chạy 7 nhịp → N=2) |

## 2. Ca tự xây dựng bổ sung

| # | Ca | Vì sao cần | Có? |
|---|---|---|---|
| **A-1** | **N = 4** | N chẵn **không phải luỹ thừa 2 nhỏ nhất**: `⌈4/2⌉ = ⌊4/2⌋ = 2` ⟹ `phase` phải đếm tới 1 rồi mới lật. Phân biệt "lật mỗi chu kỳ" (N=2) với "đếm rồi lật" (N=4). | ✅ dòng 71–72 |
| **A-2** | **Ca biên: N = 254** | N chẵn lớn nhất. Cặp với C-4 (N=255) tạo thành **cặp chẵn/lẻ ở biên trên** — cách duy nhất chứng minh logic `half_len` vẫn đúng khi `n_reg` gần tràn và `phase` gần 127. | ✅ dòng 74–75 |
| **A-3** | **N = 0** | `n_in = 0` được ánh xạ thành `n_reg = 1` (RTL dòng 28). Không kiểm thì không ai biết mạch xử lý "chia 0" thế nào. | ❌ **chưa có ở testbench SV**; mô hình Python cũng không kiểm riêng ca này (`max(1, n_in)` chỉ được dùng ngầm) |
| **A-4** | **Đổi N ngay giữa nửa chu kỳ CAO** | C-5 hiện đổi N tại thời điểm tuỳ ý. Một ca có kiểm soát — đổi đúng lúc `out=1` và `phase` đang ở giữa — mới chứng minh được "xung cụt" xảy ra đúng như đặc tả §7 chứ không phải mạch treo. | ❌ chưa có |
| **A-5** | **Reset giữa nửa chu kỳ** | Kiểm reset **đồng bộ** thắng mọi nhánh và đặt `n_reg` về **1** (không phải 0) — chi tiết dễ quên. | ⚠️ chỉ có ở đầu (`repeat(2) check()` khi `rst_n=0`), chưa có reset giữa chừng |
| **A-6** | **Đếm đủ ≥ 2 chu kỳ đầy đủ cho mỗi N** | Một chu kỳ đầy đủ chưa chứng minh được tính **tuần hoàn**; hai chu kỳ mới chứng minh mạch quay lại đúng trạng thái. | ✅ ngầm có: N=3 chạy 12 nhịp = 4 chu kỳ; N=2 chạy 8 nhịp = 4 chu kỳ. ⚠️ N=255 chỉ chạy **20 nhịp**, tức **chưa tới 8 %** của một chu kỳ |

> 🔎 **Lỗ hổng phủ nghiêm trọng nhất:** với N = 254 và N = 255, testbench chỉ chạy **20 nhịp**.
> Vì `⌊255/2⌋ = 127`, mạch thậm chí **chưa kịp lật `out` lần nào**. Nghĩa là hai ca biên này
> hiện chỉ chứng minh "`phase` đếm lên đúng 20 nhịp đầu", **không** chứng minh chu kỳ ra đúng
> 255 và **không** chạm được `phase = 127`. Muốn chứng minh phải chạy ≥ 510 nhịp cho mỗi ca.
> Ràng buộc này nên ghi vào `limitations.md`.

## 3. Phân loại ca theo tiêu chí kỹ thuật riêng của D03

Tiêu chí phù hợp nhất với đề này là **`half_len` có phụ thuộc `out` hay không** — tức vế bất
đối xứng có được kích hoạt hay không:

| Lớp | Đặc trưng | Số giá trị N thuộc lớp | Ca đại diện | Đã phủ? |
|---|---|---:|---|:-:|
| **L-1** | `N = 1` — nhánh đặc biệt, bỏ qua `half_len` | 1 | C-1 | ✅ |
| **L-2** | `N` chẵn — `⌈N/2⌉ = ⌊N/2⌋`, `half_len` **hằng số** theo `out` | 127 | C-2, A-1, A-2 | ✅ |
| **L-3** | `N` lẻ ≥ 3 — `half_len` **đổi** theo `out`, duty ≠ 50 % | 127 | C-3, C-4, (N=5 trong C-5) | ✅ |
| **L-4** | Chuyển tiếp L-x → L-y giữa chừng (`load_n`) | — | C-5 (lẻ 5 → chẵn 2) | ✅ |
| **L-5** | Biên đếm: `phase` chạm 127 | N ∈ {254, 255} | C-4, A-2 | ⚠️ **chưa thật sự chạm** (xem §2) |

Cách phân loại theo "chẵn/lẻ" tốt hơn theo "N lớn/nhỏ", vì trong RTL không có nhánh nào rẽ
theo độ lớn của N — chỉ có nhánh rẽ theo `n_reg ≤ 1` và theo `out`.

## 4. Ca **KHÔNG** áp dụng cho đề này — và vì sao

| Ca | Vì sao không áp dụng |
|---|---|
| Chia **phân số** (N = 2,5) | Charter mục 3: ngoài phạm vi. RTL chỉ có bộ đếm nguyên; không có bộ tích luỹ pha |
| Chia tần **có bù pha** (phase-corrected), dithering | Ngoài phạm vi |
| PLL, khoá pha, jitter | Ngoài phạm vi. D03 là bộ chia **thuần số**, jitter của `out` bằng jitter của `clk` |
| Đo duty cycle chính xác tới ps | Mô phỏng zero-delay không có khái niệm này. Duty ở đây là tỉ lệ **số chu kỳ**, không phải tỉ lệ thời gian vật lý |
| Ca miền clock chéo (CDC) | Một miền clock duy nhất. Đồng bộ hoá `load_n`/`n_in` là nghĩa vụ tầng ngoài |
| Ca "N thay đổi liên tục mỗi chu kỳ" | Không có trong đặc tả ứng dụng (bộ ghi dữ liệu môi trường đặt nhịp lấy mẫu một lần rồi chạy). Nếu thầy muốn, đây là ca mở rộng hợp lý |
| Ca duty 50 % với N lẻ | **Không thể tồn tại** — `N` lẻ không chia hết cho 2, đây là giới hạn toán học chứ không phải lỗi. Charter mục 10 yêu cầu **nêu ra**, không phải "sửa" |

## 5. Ca phải **bổ sung** khi chuyển sang gate-level / post-layout

| # | Ca | Vì sao chỉ xuất hiện ở tầng này |
|---|---|---|
| G-1 | **X-propagation sau power-up** trên 17 flip-flop | Cả 17 FF đều là `sky130_fd_sc_hd__dfxtp_1`, **không có chân reset**. Reset đồng bộ được nhúng vào logic `D`. Ở gate-level, trước cạnh clock đầu tiên toàn bộ trạng thái là `X`, kể cả `out` — tức `out` **không** bảo đảm bằng 0 lúc khởi động. Tầng ngoài phải biết điều này |
| G-2 | **Chạy đủ ≥ 510 nhịp cho N = 255** | Xem §2. Ở gate-level việc này còn tốn thời gian hơn, nên phải lên kế hoạch chứ không làm tuỳ hứng |
| G-3 | Kiểm **glitch trên `out`** với SDF | Ở RTL `out` là thanh ghi ⟹ không glitch. Netlist cũng vậy (`_169_/Q = out`). Ca này chủ yếu để **xác nhận** chứ không phải để tìm lỗi — nhưng cần vì `out` là tín hiệu **nhịp** cho tầng ngoài, một glitch sẽ bị đếm nhầm thành một nhịp lấy mẫu |
| G-4 | Kiểm đường tới hạn thật `_169_ → _167_` sau routing | STA hiện tại (2,5 ns, slack 7,42 ns) **chưa có ký sinh dây**. Đường này đi qua 8 cell tổ hợp nên nhạy với dây |
| G-5 | Kiểm **hold** sau CTS | `timing_report_min.txt` hiện tính với skew = 0. Hold chỉ kết luận được sau khi có cây clock thật |

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*
