# D03 — Bộ chia tần lập trình được (chia N, N = 1–255) · Ghi chú thực hiện

## 1. Bài toán này thực chất là gì

Bề ngoài, D03 chỉ là "đếm N chu kỳ rồi lật một bit". Thực chất đề này được dựng lên quanh **một
sự thật số học không thể tránh**: **với N lẻ, không tồn tại sóng vuông chu kỳ N có chu kỳ nhiệm
vụ đúng 50 %.** Vì `N/2` không phải số nguyên, mà số chu kỳ clock thì buộc phải nguyên.

Đề này vì thế không hỏi "em có làm được không", mà hỏi **"em xử lý điều không thể như thế
nào"**. Có ba lối thoát: (a) chấp nhận duty lệch và giữ chu kỳ đúng N; (b) ép duty 50 % bằng
cách chia tiếp cho 2, chấp nhận chu kỳ thành 2N; (c) phát xung rộng 1 chu kỳ thay vì sóng
vuông. RTL chọn (a). Charter mục 10 nói thẳng: *"Giấu vấn đề N lẻ thay vì nêu ra… nêu ra được
điểm cao hơn giấu."*

Bối cảnh Charter — tạo nhịp lấy mẫu cho bộ ghi dữ liệu môi trường — làm lựa chọn (a) hợp lý:
tầng ngoài dùng **cạnh lên** của `out` làm mốc khởi động ADC, nên khoảng cách giữa hai cạnh
lên (chu kỳ) mới quan trọng, còn mức cao dài bao nhiêu thì không.

## 2. Bản chất kỹ thuật — cơ chế hoạt động

Cơ chế cốt lõi gói trong một câu: **độ dài nửa chu kỳ tiếp theo phụ thuộc vào mức ra hiện
tại.**

```
   half_len  =  out ? ⌈N/2⌉ : ⌊N/2⌋           và   ⌈N/2⌉ + ⌊N/2⌋ = N  ∀N ∈ ℤ
```

Đẳng thức bên phải là toàn bộ chứng minh cho tính đúng đắn: dù N chẵn hay lẻ, hai nửa cộng lại
luôn **đúng bằng N**. Phần lẻ được dồn vào nửa chu kỳ cao.

Điều làm cơ chế này thú vị về mặt phần cứng là `out` **lưỡng dụng**: nó vừa là sản phẩm xuất ra
cổng, vừa là **chân chọn** của mux `half_len`. Hệ quả tốt: không tốn thêm flip-flop nào cho
phần điều khiển — 17 FF trong netlist bằng **đúng** 17 bit trạng thái RTL. Hệ quả xấu: `out`
có fanout 6 và nằm ở **đầu đường tới hạn**.

Cơ chế thứ hai, dễ bỏ sót: **`⌊N/2⌋` miễn phí còn `⌈N/2⌉` thì không.** Chia 2 là dịch bit —
không tốn cổng nào, chỉ là đánh lại chỉ số dây. Nhưng `N − ⌊N/2⌋` cần **một bộ trừ 8 bit
thật**. Nói cách khác: **toàn bộ chi phí phần cứng của việc hỗ trợ N lẻ nằm ở một bộ trừ và
một mux.** Đó là con số rất nhỏ so với nỗi sợ mà vấn đề "N lẻ" gây ra.

Cơ chế thứ ba: `phase` so với `half_len − 1` chứ không phải `half_len`, vì `phase` đếm từ 0.
Đây là chỗ lệch-một-đơn-vị (off-by-one) kinh điển, và RTL phải có nhánh `n_reg ≤ 1 ⟹
half_len = 1` để `half_len − 1` không bao giờ tràn ngược thành `8'hFF`.

## 3. Đọc mã nguồn: RTL làm gì, từng dòng quan trọng

**Trái tim của đề** (dòng 13–20):

```systemverilog
always_comb begin
    if (n_reg <= 8'd1)      half_len = 8'd1;
    else if (out)           half_len = n_reg - (n_reg / 2);   // ⌈N/2⌉
    else                    half_len = n_reg / 2;             // ⌊N/2⌋
end
```

Ba điều cần chú ý:
- Đây là `always_comb`, **không** phải `always_ff`. Nếu đăng ký `half_len` vào thanh ghi, chu
  kỳ ra sẽ **dài thêm 1** với mọi N — lỗi tinh vi nhất của đề.
- Nhánh `n_reg <= 8'd1` **không** chỉ để xử lý N=1; nó còn chặn `n_reg = 0` (dù `n_reg = 0`
  không thể xảy ra, hai lớp bảo vệ vẫn tốt hơn một).
- Viết `n_reg - (n_reg / 2)` thay vì `(n_reg + 1) / 2` — hai biểu thức cho cùng kết quả nhưng
  cái đầu **không tràn** khi `n_reg = 255` (`255 + 1 = 0` trong 8 bit!). Đây là một chi tiết
  đúng và đáng khen.

**Vòng lật** (dòng 34–39):

```systemverilog
end else if (phase == half_len - 8'd1) begin
    phase <= 8'd0;
    out   <= ~out;
end else begin
    phase <= phase + 8'd1;
end
```

Ở nhánh `else`, `out` **không được gán**. Trong `always_ff` điều này đúng và an toàn — không
gán nghĩa là giữ thanh ghi. Cùng cách viết đó trong `always_comb` sẽ **suy ra latch**.

**Trường hợp đặc biệt** (dòng 31–33): `else if (n_reg == 8'd1) begin phase <= 0; out <= 1'b1;
end`. Chú ý: đây là `out <= 1'b1` chứ không phải `out <= ~out`. Nghĩa là **"chia 1" cho ra một
mức cao đứng yên, KHÔNG phải một tín hiệu 1:1 của clock.** Hành vi này nhất quán với cả hai mô
hình chuẩn nên testbench PASS — nhưng nó là một quyết định ngữ nghĩa cần ghi rõ trong tài liệu
bàn giao (điểm W-1 ở `functional_spec.md`).

**Cổng quan sát** (dòng 42–49): `count` có một nhánh bão hoà `phase > 8'd127 ⟹ 7'h7f`. Nhánh
này là **logic chết** trong vận hành đúng, vì `phase < half_len ≤ ⌈255/2⌉ = 128 ⟹ phase ≤ 127`
(INV-2). Nó tồn tại như một lớp bảo vệ nếu `phase` bị hỏng do lỗi mềm. Nêu được rằng đây là
nhánh chết — và **vì sao** — là một điểm cộng khi bảo vệ.

## 4. Vì sao chọn kiến trúc này

| Tiêu chí | P0 (đang dùng) | P1: phát xung 1 chu kỳ | P5: chia N rồi chia 2 |
|---|---|---|---|
| Chu kỳ ra | **đúng N** | đúng N | **2N** ❌ |
| Duty khi N lẻ | `⌈N/2⌉/N` | `1/N` | **50 %** ✅ |
| Ô nhớ | 17 | 16 | 18 |
| Phù hợp bối cảnh (dùng **cạnh**) | ✅ | ✅ | ❌ sai tần số |

P0 thắng vì bối cảnh dùng **cạnh lên** làm mốc. Nếu bối cảnh là "tạo clock cho một khối đồng
bộ khác" (cần duty gần 50 % để thoả setup ở cả hai cạnh), P5 mới là lựa chọn đúng. Danh sách
đầy đủ 6 phương án ở `03_ARCHITECTURE/tradeoff.md` §2.

## 5. Cách thực hiện — lộ trình 8 bước từ đặc tả tới GDSII

1. **Viết đẳng thức trước khi viết RTL.** `⌈N/2⌉ + ⌊N/2⌋ = N` là toàn bộ chứng minh tính đúng
   đắn. Nếu không viết nó ra, rất dễ rơi vào bẫy `half_len = N/2` cố định.
2. **Lập bảng chuyển trạng thái 7 dòng** (`fsm.md` §4) phủ kín mọi tổ hợp
   `(rst_n, load_n, n_reg==1, phase==hl−1)`. Phủ kín ⟹ không sinh latch.
3. **Viết mô hình chuẩn Python trước.** `reference_model.py` chỉ 46 dòng nhưng chạy 8 giá trị N
   đại diện và kiểm **bất biến** `0 ≤ phase < max(1,n)` ở mỗi bước — mạnh hơn kiểm giá trị.
4. **Viết RTL**, tách `always_comb` (`half_len`, `count`) khỏi `always_ff` (3 thanh ghi).
5. **Mô phỏng RTL** so DUT với mô hình chuẩn ở mọi cạnh. ✅ **PASS.** Nhưng phải kiểm độ phủ:
   ca N=255 hiện chỉ chạy 20/510 nhịp cần thiết.
6. **Tổng hợp** rồi đối chiếu **số FF với số bit trạng thái RTL**. Ở D03 là 17/17 — dấu hiệu
   tốt. (So sánh: D02 cho 22 FF trên 8 bit trạng thái vì công cụ dời thanh ghi.)
7. **STA** với SDC ghi rõ 10 ns là **giả định**, rồi đối chiếu đường tới hạn thật với dự đoán
   từ RTL. Ở D03 dự đoán sai điểm xuất phát — bài học ở `datapath.md` §3.
8. **P&R → DRC/LVS → GDSII** bằng LibreLane + sky130A. **Chưa chạy.**

## 6. Số liệu thật đã đo được và cách đọc chúng

| Chỉ số | Giá trị | Nguồn |
|---|---:|---|
| Mô phỏng RTL | **PASS** (`$finish` tại t = 1006) | `simulation.log` |
| Mô hình chuẩn Python | **PASS** | `python_reference_run.log` |
| Cell | 101 | `synth_stat.txt` |
| Flip-flop | **17** | như trên |
| Diện tích | 975,936 µm² | như trên |
| Đường tới hạn | `_169_` (`out`) → `_167_` (`phase[6]`), 10 cell | `timing_report_max.txt` |
| Arrival / Slack | 2,5 ns / **+7,42 ns** | như trên |
| WNS / TNS | 0,00 / 0,00 | `wns.txt`, `tns.txt` |
| Công suất | 9,81e-05 W — tổ hợp 24,1 %, **tuần tự 75,9 %** | `power_report.txt` |
| Nón fan-out của `out` | 42 cell · 341,5776 µm² · **35,0 %** | phân tích netlist, `datapath.md` §5 |

**Những con số này chứng minh:** hàm của khối khớp cả hai mô hình chuẩn trên toàn bộ vector mà
testbench chạy (bao gồm N = 1, 2, 3, 4, 5, 254, 255 và một lần đổi N giữa chừng); RTL tổng hợp
được ra 101 standard cell sky130; **không có ô nhớ thừa** — 17 FF khớp đúng 17 bit trạng thái
RTL và khớp luôn "dấu hiệu làm đúng" của Charter mục 10; với chu kỳ giả định 10 ns ở góc
`tt_025C_1v80` sau tổng hợp, không có vi phạm setup nào.

**Những con số này KHÔNG chứng minh:** rằng chu kỳ ra đúng 255 — ca N=255 chỉ chạy 20 nhịp,
chưa lật `out` lần nào (cần ≥ 510 nhịp); rằng netlist tương đương RTL — chưa gate-level sim;
rằng độ trễ thật là 2,5 ns — chưa có ký sinh dây; rằng mạch chạy ở tần số nào đó — một góc PVT,
skew = 0; rằng **35,0 %** là **chi phí gia tăng** của việc hỗ trợ N lẻ — đó là **chặn trên**,
vì cây so sánh 8 bit vẫn cần dù bỏ N lẻ.

## 7. Trả lời các câu hỏi kỹ thuật của Charter (mục 2)

**(1) Với N lẻ, chu kỳ nhiệm vụ không thể đúng 50 % — chọn xử lý thế nào và vì sao?**
Chọn **giữ chu kỳ đúng N, chấp nhận duty lệch**, dồn phần lẻ vào nửa chu kỳ **cao**:
`half_len = out ? ⌈N/2⌉ : ⌊N/2⌋`. Với N=3 được 2 cao / 1 thấp ⟹ duty 66,7 %; với N=255 được
128/127 ⟹ 50,196 %. Lý do: bối cảnh ứng dụng dùng **cạnh lên** làm mốc lấy mẫu, nên chu kỳ mới
là đại lượng phải đúng. Phương án ép duty 50 % (P5: chia N rồi chia tiếp 2) **tồn tại và chạy
được**, nhưng nó biến chu kỳ thành 2N — tức không còn là bộ chia N. Đây là đánh đổi có ý thức,
không phải né tránh.

**(2) Thay đổi N khi đang chạy gây ra hiện tượng gì, và mạch xử lý ra sao?**
`load_n` ép `phase←0` và `out←0` (dòng 29–30), **cắt ngang** nửa chu kỳ đang chạy ⟹ sinh **một
xung cụt**. Ví dụ đo được từ chính testbench: đổi 5 → 2 ngay sau khi `out` vừa lên ⟹ mức cao
chỉ kéo dài **1 chu kỳ** thay vì `⌈5/2⌉ = 3` (giản đồ ở `timing_diagram.md` §4). Mạch **không
treo**; chu kỳ đầu tiên với N mới đã đúng và đầy đủ. Đánh đổi: hy sinh tính liên tục của pha
một lần để đổi lấy chu kỳ mới đúng ngay. Muốn không có xung cụt, cần thêm thanh ghi "N chờ"
(+8 FF, phương án P3).

**(3) Bộ chia tần này chạy được tối đa bao nhiêu MHz?**
**Chưa trả lời được bằng số liệu hiện có** — và đây là câu trả lời đúng, không phải né tránh.
Được phép nói: *với chu kỳ giả định 10 ns, góc `tt_025C_1v80`, sau tổng hợp và chưa có ký sinh
dây, đường xấu nhất có arrival 2,5 ns và slack +7,42 ns; `wns = tns = 0,00`.* **Không** được
suy ra tần số, vì còn thiếu: ký sinh dây sau routing, các góc PVT `ss`/`ff`, và cây clock thật
(skew hiện giả định 0). Muốn có con số, phải chạy LibreLane tới routing, trích RC, rồi quét chu
kỳ giảm dần tới khi slack chạm 0 ở góc xấu nhất. Việc này **chưa chạy**.

## 8. Trả lời câu phân tích riêng (Charter mục 9)

> *"Nêu rõ cách thiết kế xử lý N lẻ, và **chỉ ra phần logic phụ trách việc đó**."*

**Cách xử lý:** đã nêu ở §2 và §7(1) — `half_len` phụ thuộc `out`, dựa trên đẳng thức
`⌈N/2⌉ + ⌊N/2⌋ = N`.

**Phần logic phụ trách, định vị ba cách:**

| Cách định vị | Kết quả |
|---|---|
| Trong **RTL** | 7 dòng: `d03_core.sv` dòng 13–20 |
| Trong **netlist** (nón fan-out của `out`) | **42 cell tổ hợp · 341,5776 µm² · 35,0 %** tổng diện tích |
| Trong **STA** | **2 cell đầu tiên** của đường tới hạn: `_081_ and3_1`, `_083_ xor2_1` — nằm ngay sau `_169_/Q = out` |

Phương pháp đo và phép tự kiểm (tổng tính lại = 975,936 µm², trùng khít số Yosys báo) ở
`datapath.md` §5.

**Phát hiện đáng chú ý nhất:** phần logic trả lời Charter mục 9 **chính là** đường tới hạn của
thiết kế. Không phải trùng hợp — nếu duty luôn 50 %, `half_len` thành hằng `n_reg >> 1`, tín
hiệu `out` **biến mất khỏi** đường này, và đường tới hạn sẽ bắt đầu từ `n_reg`. Nói cách khác:
**cái giá về thời gian của việc hỗ trợ N lẻ nằm ở hai tầng cổng đầu của đường tới hạn** — đo
được, không phải suy đoán.

Đồng thời phải nói rõ **35,0 % là chặn trên, không phải chi phí gia tăng**: cây so sánh bằng
8 bit vẫn cần ngay cả khi bỏ hẳn N lẻ, nó chỉ không cần chân chọn `out` nữa. Chi phí gia tăng
thật đòi hỏi tổng hợp lại một bản rút gọn — **chưa chạy**, và không được ước lượng bừa.

## 9. Những chỗ sinh viên hay sai và cách phát hiện

| # | Sai lầm | Hậu quả | Phát hiện bằng bằng chứng nào |
|---|---|---|---|
| 1 | `half_len = n_reg / 2` cố định | Chu kỳ ra = `N−1` với mọi N lẻ (N=3 cho 2) | Ca C-3 (N=3) trong testbench; đếm khoảng cách giữa hai `$rose(out)` |
| 2 | `half_len = (n_reg + 1) / 2` cố định | Chu kỳ ra = `N+1` với mọi N lẻ; và **tràn** khi `n_reg = 255` | Ca N=3 và ca biên N=255 |
| 3 | Đăng ký `half_len` vào thanh ghi | Chu kỳ dài thêm 1 với **mọi** N | So sánh chu kỳ đo được với N ở ≥ 2 giá trị; sai lệch **hằng số +1** là dấu vân tay của lỗi này |
| 4 | So `phase == half_len` thay vì `half_len − 1` | Chu kỳ dài thêm 2 (mỗi nửa +1) | như trên, sai lệch +2 |
| 5 | Bỏ nhánh `n_reg <= 1` | `half_len − 1` tràn thành `8'hFF` ⟹ đếm 256 chu kỳ | Ca N=1; và assertion INV-3 (`half_len ≥ 1`) |
| 6 | Quên ánh xạ `n_in == 0 → 1` | "Chia 0" không xác định | Ca A-3 (chưa có trong testbench) |
| 7 | Tưởng `load_n` tích cực **thấp** vì tên có `_n` | Nối đảo ⟹ nạp liên tục ⟹ `out` kẹt ở 0 | Đọc RTL dòng 27: `else if (load_n)` ⟹ tích cực **cao** |
| 8 | Tưởng reset là **bất đồng bộ** | Xung `rst_n` hẹp hơn 1 chu kỳ bị **bỏ qua im lặng** | `always_ff` chỉ nhạy `posedge clk`; netlist dùng `dfxtp_1` **không có chân reset** |
| 9 | Chạy N=255 chỉ 20 nhịp rồi ghi "PASS" | Ca biên **chưa lật `out` lần nào** ⟹ không chứng minh được gì | Tính: `⌊255/2⌋ = 127` ⟹ cần ≥ 510 nhịp cho 2 chu kỳ đầy đủ |
| 10 | Nói "slack 7,42 ns ⟹ chạy được XXX MHz" | Phát biểu vượt mức | `physical_report.md` §5: chưa có RC, một góc PVT, skew = 0 |
| 11 | Dùng `count[6:0]` để đếm số nhịp đã phát | Sai hoàn toàn — nó là **pha trong nửa chu kỳ**, bị đặt lại mỗi lần lật | Giản đồ `timing_diagram.md` §1: `count` chạy 00→01→00 với N=3 |

## 10. Câu hỏi mentor nên đặt khi bảo vệ

1. **"Với N = 3, `out` cao mấy chu kỳ và thấp mấy chu kỳ? Vì sao không bằng nhau?"** → Cao 2,
   thấp 1. Vì `⌈3/2⌉ = 2` và `⌊3/2⌋ = 1`; 3 là số lẻ nên không chia đôi được. Tổng = 3 ⟹ chu kỳ
   vẫn đúng.
2. **"Chỉ cho tôi đúng dòng RTL xử lý N lẻ."** → Dòng 16–19: `else if (out) half_len = n_reg -
   (n_reg / 2); else half_len = n_reg / 2;`
3. **"Vì sao viết `n_reg - (n_reg/2)` mà không viết `(n_reg+1)/2`?"** → Hai biểu thức bằng nhau
   về toán học, nhưng `n_reg + 1` **tràn về 0** khi `n_reg = 255` trong 8 bit.
4. **"Phần logic đó tốn bao nhiêu diện tích? Trả lời bằng số."** → Nón fan-out của `out`:
   42 cell, 341,5776 µm², 35,0 %. Và phải nói rõ đây là **chặn trên**, không phải chi phí
   gia tăng.
5. **"Đường tới hạn của em bắt đầu ở đâu? Có bất ngờ không?"** → Bắt đầu ở `out`, không phải ở
   `n_reg` như dự đoán từ RTL. Vì `abc` hợp nhất mux `half_len` với bộ trừ nên `out` chui thẳng
   vào trong bộ trừ.
6. **"Muốn duty đúng 50 % với N lẻ thì làm thế nào?"** → Chia N rồi chia tiếp cho 2 bằng một FF
   lật (P5). Nhưng chu kỳ thành **2N** — không còn là bộ chia N. Đây là đánh đổi, không phải
   lời giải miễn phí.
7. **"Đổi N giữa chừng thì sao? Có glitch không?"** → `phase←0`, `out←0` ⟹ **xung cụt**, không
   glitch (vì `out` là thanh ghi). Ví dụ đo được: 5 → 2 làm mức cao chỉ dài 1 chu kỳ thay vì 3.
8. **"N = 1 cho ra cái gì?"** → `out ≡ 1` đứng yên, **không có xung**. Tầng ngoài chờ cạnh lên
   sẽ treo. Đây là điểm cần thầy chốt.
9. **"Bao nhiêu flip-flop? Có khớp RTL không?"** → 17 FF, khớp đúng 17 bit trạng thái RTL
   (8 + 8 + 1) và khớp Charter mục 10. Không có ô nhớ thừa do công cụ.
10. **"`count` có nhánh bão hoà `7'h7f`. Nhánh đó có bao giờ chạy không?"** → Không, đó là
    **logic chết**: `phase < half_len ≤ 128 ⟹ phase ≤ 127`. Nó là lớp bảo vệ nếu `phase` hỏng.
11. **"Tần số tối đa là bao nhiêu?"** → Chưa trả lời được; cần P&R + trích RC + ≥ 3 góc PVT.
12. **"Ca N = 255 của em chạy bao nhiêu nhịp? Đủ chưa?"** → 20 nhịp; **chưa đủ**, cần ≥ 510 để
    thấy hai chu kỳ đầy đủ. Ca này hiện chưa chứng minh được gì về chu kỳ.

## 11. Giới hạn: đã chứng minh được gì, chưa chứng minh được gì

**Đã chứng minh.** Hàm của khối khớp hai mô hình chuẩn độc lập (SystemVerilog và Python) trên
toàn bộ vector testbench chạy — `simulation.log` ghi `D03 core verification PASS`. RTL tổng hợp
được thành 101 standard cell sky130 (975,936 µm²). Thiết kế đúng là mạch tuần tự, với **17
flip-flop khớp chính xác 17 bit trạng thái RTL** — không có ô nhớ thừa do công cụ. Với chu kỳ
**giả định** 10 ns ở góc `tt_025C_1v80` sau tổng hợp, đường xấu nhất (`out` → `phase[6]`, 10
cell) có arrival 2,5 ns và slack +7,42 ns, `wns = tns = 0,00`. Phần logic xử lý N lẻ đã được
định vị bằng ba cách độc lập (RTL / netlist / STA) và con số diện tích đã được tự kiểm bằng
phép cộng khớp tổng của công cụ.

**Chưa chứng minh.** Chu kỳ ra đúng với N lớn: ca N=254/255 mới chạy 20 nhịp, `out` **chưa lật
lần nào** — đây là lỗ hổng phủ nghiêm trọng nhất và nên được vá trước tiên. Netlist tương đương
RTL (chưa gate-level sim, chưa LEC). Độ trễ sau routing (chưa có ký sinh dây). Biên an toàn
qua góc `ss`/`ff`. Hold sau CTS (báo cáo hiện tính với skew = 0). Công suất thật từ VCD. Hành
vi khởi động ở gate-level: `dfxtp_1` không có chân reset nên `out` **không** bảo đảm bằng 0
trước cạnh clock đầu tiên. DRC/LVS/GDSII. Lớp vỏ 24 chân (ngân sách **đủ**, 19/24, nhưng ánh
xạ chưa chốt).

**Không được khẳng định.** "Đã sign-off", "đã tape-out", "đã chế tạo", "chạy được ở XXX MHz",
"đã tối ưu netlist", "đã kiểm chứng đầy đủ N = 255".

**Việc cần làm tiếp, theo thứ tự ưu tiên:** (1) kéo dài ca N=254/255 lên ≥ 510 nhịp và chạy
lại; (2) thêm ca N=0 và ca đổi N có kiểm soát (A-3, A-4 ở `corner_cases.md`); (3) chốt ngữ
nghĩa N=1 với thầy; (4) gate-level sim để kiểm hành vi khởi động và tương đương netlist.

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*
