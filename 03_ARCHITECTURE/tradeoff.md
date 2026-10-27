# D03 · Phân tích đánh đổi (Trade-off)

---

## 1. Số liệu thật của phương án đang dùng

| Chỉ số | Giá trị | Nguồn |
|---|---:|---|
| Tổng cell | **101** | `synthesis/synth_stat.txt` |
| Flip-flop | **17** (= đúng 17 bit trạng thái RTL) | như trên |
| Cell tổ hợp | **84** | 101 − 17 |
| Diện tích | **975,936 µm²** | như trên |
| Đường tới hạn | `_169_` (`out`) → `_167_` (`phase[6]`), **10 cell** (8 tổ hợp), arrival **2,5 ns**, slack **+7,42 ns** | `sta/timing_report_max.txt` |
| WNS / TNS | 0,00 / 0,00 | `sta/wns.txt`, `sta/tns.txt` |
| Công suất (ước lượng) | **9,81e-05 W** — tổ hợp 24,1 % · tuần tự 75,9 % | `power/power_report.txt` |
| Nón fan-out của `out` (phần xử lý N lẻ) | 42 cell · **341,5776 µm²** · **35,0 %** | `datapath.md` §5 |

## 2. So sánh với các kiến trúc thay thế

| # | Kiến trúc | Ô nhớ | Chu kỳ ra | Duty với N lẻ | Độ trễ reg→reg | Khi nào nên dùng |
|---|---|---:|---|---|---|---|
| **P0** | **Đang dùng:** bộ đếm pha + `half_len` phụ thuộc `out` | **17** (đo được) | **đúng N** với mọi N ≥ 2 | `⌈N/2⌉/N` (66,7 % khi N=3) | 10 cell · **2,5 ns** (đo được) | ⭐ Khi cần **chu kỳ đúng** và tầng ngoài dùng **cạnh** chứ không dùng mức |
| **P1** | Đếm tới N−1 rồi phát **xung rộng 1 chu kỳ** (không phải sóng vuông) | 8 + 8 = **16** | đúng N | duty = `1/N` cố định | Ngắn hơn: bỏ hẳn bộ trừ `N−⌊N/2⌋` và mux `half_len`. Ước tính bớt ~2 mức cổng | Khi tầng ngoài chỉ cần **một xung mốc**, không cần sóng vuông. **Đơn giản nhất** |
| **P2** | `half_len = ⌊N/2⌋` cố định (bỏ vế bất đối xứng) | 17 | **sai với N lẻ**: cho `2⌊N/2⌋ = N−1` | luôn 50 % | Ngắn nhất | ❌ **Không dùng được** — vi phạm yêu cầu "chia N". Liệt kê ở đây vì đây đúng là cách làm sai phổ biến nhất (Charter mục 10) |
| **P3** | Như P0 + thanh ghi "N chờ": đổi N chỉ có hiệu lực sau khi hết chu kỳ hiện tại | 17 + **8** = 25 | đúng N | như P0 | Dài hơn (thêm một tầng mux ở `n_reg`) | Khi **không chấp nhận xung cụt** lúc đổi N giữa chừng (xem `timing_diagram.md` §4) |
| **P4** | Chia N **bằng bộ đếm xuống** (nạp N−1, đếm về 0) | 17 | đúng N | như P0 | Bỏ được bộ so sánh bằng 8 bit, chỉ cần so sánh **với 0** (cây NOR) | Khi muốn rút ngắn đường tới hạn mà **không** đổi chức năng. Đây là phương án tối ưu hoá hợp lệ đáng cân nhắc nhất |
| **P5** | Chia N rồi **chia tiếp cho 2** bằng một flip-flop lật | 17 + 1 = 18 | **2N**, không phải N | **đúng 50 %** với mọi N | Ngắn (chỉ thêm 1 FF) | Khi **bắt buộc** duty 50 % và chấp nhận chu kỳ gấp đôi. Đây là câu trả lời kinh điển cho "làm sao có duty 50 % với N lẻ" |

> ⚠️ **P1, P4, P5 là các phương án thật sự đáng thảo luận khi bảo vệ.** P5 đặc biệt quan trọng:
> nó cho thấy vấn đề "N lẻ không thể có duty 50 %" **có** lời giải — nhưng lời giải đó **đổi
> chu kỳ từ N thành 2N**, tức không còn là bộ chia N nữa. Nêu được điều này chính là cái
> Charter mục 10 thưởng điểm.

### Vì sao P0 được chọn

Bối cảnh ứng dụng (`system_diagram.md` §1) là **tạo nhịp lấy mẫu**: tầng ngoài dùng cạnh lên
của `out` làm mốc khởi động ADC. Với mục đích đó:

- **Chu kỳ đúng N** là bắt buộc — sai chu kỳ nghĩa là lấy mẫu sai tần số.
- **Duty không quan trọng** — mạch không dùng mức, chỉ dùng cạnh.

P0 cho đúng thứ cần và bỏ qua thứ không cần. Nếu bối cảnh là "tạo clock cho một khối đồng bộ
khác" (khối đó cần duty gần 50 % để thoả setup ở cả hai cạnh), kết luận sẽ là P5.

## 3. Đánh đổi bằng số liệu thật

| Câu hỏi đánh đổi | Số liệu | Kết luận |
|---|---|---|
| Hỗ trợ N lẻ tốn bao nhiêu **diện tích**? | Nón fan-out của `out` = 42 cell · 341,5776 µm² · **35,0 %** | Đây là **chặn trên**. Cây so sánh 8 bit vẫn cần dù bỏ N lẻ; chi phí **gia tăng** thật sự cần tổng hợp lại bản rút gọn — **chưa chạy** |
| Hỗ trợ N lẻ tốn bao nhiêu **thời gian**? | 2 cell đầu đường tới hạn (`_081_ and3_1`, `_083_ xor2_1`) nằm ngay sau `out` | Đo được, nhưng cũng là chặn trên vì `abc` đã hợp nhất mux + bộ trừ |
| Có tốn thêm **ô nhớ** không? | **Không.** 17 FF = 17 bit trạng thái RTL; `out` đóng cả vai đầu ra lẫn bit điều khiển | Đây là điểm thiết kế tốt nhất của D03 |
| Công suất phân bổ ra sao? | tuần tự **75,9 %** · tổ hợp **24,1 %** | Với 17 FF trên 101 cell (16,8 % số cell), phần tuần tự chiếm 75,9 % công suất — **flip-flop luôn đắt hơn cổng** về công suất, dù ít hơn về số lượng |
| Slack có đủ để nâng tần số không? | slack **+7,42 ns** trên chu kỳ giả định 10 ns | ⚠️ **Không kết luận được.** Chưa có RC, một góc PVT, skew = 0 |

## 4. Ràng buộc phạm vi — kiến trúc nào **chỉ được so trên giấy**

Charter mục 3 xếp ra ngoài phạm vi:

| Kiến trúc | Vì sao **không được** thay vào D03 |
|---|---|
| **Chia phân số** (fractional-N) | Ngoài phạm vi tường minh. Nó cần bộ tích luỹ pha và sinh jitter chu kỳ — bản chất khác hẳn |
| **Chia tần có bù pha** | Ngoài phạm vi |
| **PLL** | Ngoài phạm vi, và là mạch **mixed-signal** (VCO là analog) |
| Thiết kế analog mức transistor, tự làm physical design, ASIC sign-off, tape-out | Ngoài phạm vi với **mọi** đề |
| **Tự sửa netlist bằng tay** để rút ngắn đường tới hạn | Nằm trong nhóm "tự tối ưu netlist" — ngoài phạm vi. Cách hợp lệ duy nhất là đổi RTL (ví dụ sang P4) và **phải được thầy duyệt** |

> Lưu ý phân biệt: **P4 (bộ đếm xuống) và P5 (chia tiếp cho 2) KHÔNG nằm ngoài phạm vi** — đó
> vẫn là chia số nguyên thuần số. Chúng chỉ là thay đổi kiến trúc, cần thầy duyệt chứ không bị
> cấm.

## 5. Những đánh đổi **KHÔNG được phép** trong đề này

| # | Không được | Vì sao |
|---|---|---|
| K-1 | Đổi `half_len` thành `⌊N/2⌋` cố định để "cho gọn" | Chu kỳ ra thành `N−1` với mọi N lẻ. Đây đúng là cách làm sai Charter mục 10 chỉ mặt |
| K-2 | **Giấu** vấn đề duty ≠ 50 % khi N lẻ | Charter mục 10 ghi thẳng: *"nêu ra được điểm cao hơn giấu"* |
| K-3 | Đăng ký `half_len` vào thanh ghi cho "sạch timing" | Thêm 1 chu kỳ trễ ⟹ chu kỳ ra dài thêm 1 với **mọi** N. Lỗi off-by-one tinh vi nhất của đề (xem `timing_diagram.md` §1) |
| K-4 | Bỏ nhánh `n_reg ≤ 1 ⟹ half_len = 1` | `half_len − 1` sẽ tràn ngược thành `8'hFF` khi `n_reg = 0` hoặc `1` ⟹ mạch đếm 256 chu kỳ. Vi phạm INV-3 |
| K-5 | Bỏ ánh xạ `n_in == 0 → 1` | "Chia 0" thành hành vi không xác định |
| K-6 | Kết luận "D03 chạy được ở XXX MHz" từ slack 7,42 ns | Chưa có RC, một góc PVT, skew = 0. Xem `datapath.md` §4 |
| K-7 | Ghi "đã kiểm chứng với N = 255" mà không nói rõ chỉ chạy 20/510 nhịp | Xem `corner_cases.md` §2 — ca này **chưa** lật `out` lần nào |
| K-8 | Đổi `out` sang tổ hợp để "ra sớm hơn nửa chu kỳ" | Phá tính Moore (INV-9), tạo đường tổ hợp vào→ra, sinh glitch trên tín hiệu **nhịp** — tầng ngoài sẽ đếm nhầm nhịp lấy mẫu |

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*
