# D03 · Sơ đồ hệ thống (System Diagram)

---

## 1. Bối cảnh ứng dụng (Charter mục 1)

> *"Khối tạo nhịp lấy mẫu chậm từ xung nhịp hệ thống trong bộ ghi dữ liệu môi trường."*

```
╔════════════════════ BỘ GHI DỮ LIỆU MÔI TRƯỜNG ════════════════════════════╗
║                                                                            ║
║   ┌──────────────┐                                                         ║
║   │ Dao động     │  clk hệ thống (nhanh, ổn định)                          ║
║   │ thạch anh    │────────────────┬────────────────┬──────────────┐        ║
║   └──────────────┘                │                │              │        ║
║        ANALOG, ngoài khối         │                │              │        ║
║                                   ▼                ▼              ▼        ║
║   ┌──────────────┐        ┌───────────────┐  ┌──────────┐  ┌──────────┐    ║
║   │ Cấu hình     │ n_in   │   >>> D03 <<< │  │   CPU /  │  │  Bộ nhớ  │    ║
║   │ (thanh ghi,  │[7:0]   │  Chia tần N   │  │ máy trạng│  │  đệm     │    ║
║   │  UART, DIP)  │───────▶│  ───────────  │  │  thái    │  │          │    ║
║   │              │ load_n │  n_reg[7:0]   │  └────┬─────┘  └────▲─────┘    ║
║   └──────────────┘───────▶│  phase[7:0]   │       │             │          ║
║                           │  out          │       │             │          ║
║                           └───┬───────┬───┘       │             │          ║
║                    out (nhịp) │       │ count[6:0]│             │          ║
║                               ▼       ▼ (quan sát)│             │          ║
║                    ┌────────────────────┐         │             │          ║
║                    │ Máy trạng thái      │────────┘             │          ║
║                    │ lấy mẫu:            │                      │          ║
║                    │  cạnh lên out ⟹     │──────────────────────┘          ║
║                    │  khởi động ADC      │                                 ║
║                    └─────────┬───────────┘                                 ║
║                              │ start                                       ║
║                              ▼                                             ║
║   ┌──────────────┐    ┌─────────────┐                                      ║
║   │ Cảm biến     │───▶│    ADC      │   ← ANALOG / MIXED, ngoài khối       ║
║   │ nhiệt-ẩm     │    │             │                                      ║
║   └──────────────┘    └─────────────┘                                      ║
╚════════════════════════════════════════════════════════════════════════════╝
```

Bối cảnh này giải thích **hai quyết định thiết kế** mà nếu không có bối cảnh sẽ thấy vô lý:

1. **Vì sao duty cycle không quan trọng bằng chu kỳ.** Tầng ngoài dùng **cạnh lên** của `out`
   làm mốc lấy mẫu, không dùng mức. Do đó duty 66,7 % ở N=3 hoàn toàn chấp nhận được, miễn
   khoảng cách giữa hai cạnh lên **đúng bằng N** (INV-4).
2. **Vì sao có `count[6:0]` ra ngoài.** Nó không phục vụ chức năng chia tần; nó là **cổng quan
   sát** để tầng ngoài (hoặc người gỡ lỗi) biết mạch đang ở đâu trong nửa chu kỳ mà không cần
   chọc vào trong chip.

## 2. Ranh giới khối

| Chức năng | Thuộc D03? | Ghi chú |
|---|:-:|---|
| Giữ hệ số chia N | ✅ | `n_reg[7:0]` |
| Đếm pha trong nửa chu kỳ | ✅ | `phase[7:0]` |
| Quyết định độ dài nửa chu kỳ cao/thấp (xử lý N lẻ) | ✅ | `half_len`, tổ hợp |
| Sinh tín hiệu nhịp ra | ✅ | `out` |
| Phát giá trị đếm để quan sát | ✅ | `count[6:0]` |
| **Tạo xung nhịp gốc** (dao động) | ❌ | Analog, ngoài khối |
| Chống dội / đồng bộ hoá `load_n`, `n_in` | ❌ | Tầng ngoài (`interface.md` §4) |
| Quyết định **giá trị** N | ❌ | Tầng cấu hình (UART/DIP/thanh ghi) |
| Bù pha, chia phân số, PLL | ❌ | Charter mục 3: ngoài phạm vi |
| Đếm số nhịp đã phát (tổng lượt lấy mẫu) | ❌ | Không có cổng nào; tầng ngoài tự đếm cạnh lên `out` |
| Lớp vỏ 24 chân Tiny Tapeout | ❌ | Ngân sách **đủ** (19/24) nhưng chưa chốt ánh xạ |

### Hợp đồng với tầng ngoài

| # | Nghĩa vụ | Vì sao |
|---|---|---|
| H-1 | Dùng **cạnh lên** `out` làm mốc, không dùng mức | Với N lẻ, mức cao và mức thấp **không** bằng nhau (W-1 của `functional_spec.md`) |
| H-2 | Hiểu rằng **N = 1 không sinh xung** — `out` đứng ở mức cao | Nếu tầng ngoài chờ cạnh lên khi N=1, nó sẽ **treo vĩnh viễn** |
| H-3 | `rst_n` giữ thấp qua ít nhất một cạnh lên `clk` | Reset đồng bộ |
| H-4 | Chấp nhận **một xung cụt** khi đổi N giữa chừng | `load_n` ép `phase←0`, `out←0` — không có chuyển đổi không gián đoạn |
| H-5 | Không coi `count[6:0]` là số nhịp đã phát | Nó là **pha trong nửa chu kỳ**, bị reset mỗi lần `out` lật |

## 3. Phân loại: analog / digital / mixed

**Digital thuần, đồng bộ, một miền clock.** Bằng chứng: `synth_stat.txt` liệt kê 101 cell đều
là standard cell số `sky130_fd_sc_hd`; `power_report.txt` có `Macro 0,0 %` và `Pad 0,0 %`.

Lưu ý phân biệt quan trọng cho đề này: **"chia tần" không làm cho khối trở thành mạch analog.**
Bộ chia tần số dựa trên PLL/VCO mới là mixed-signal. D03 chia tần bằng **đếm chu kỳ clock**,
hoàn toàn số. Đổi lại, D03 **chỉ chia được cho số nguyên** và **không** bù được pha — đó chính
là các mục Charter xếp ngoài phạm vi.

## 4. Vòng đời RTL → GDSII — trạng thái **thật** của D03

Lấy đúng từ `BRIEF D03` và `06_GDSII/physical_report.md`.

```
  ┌──────────────┐
  │ 1. Yêu cầu   │ ✅  Charter D03 → 01_REQUIREMENT/
  ├──────────────┤
  │ 2. Đặc tả    │ ✅  interface · timing · functional_spec · corner_cases
  ├──────────────┤
  │ 3. Kiến trúc │ ✅  tài liệu này
  ├──────────────┤
  │ 4. RTL       │ ✅  d03_core.sv — 50 dòng
  ├──────────────┤
  │ 5a. Mô hình  │ ✅  reference_model.py — PASS
  │     chuẩn Py │
  ├──────────────┤
  │ 5b. Mô phỏng │ ✅  **PASS** — "D03 core verification PASS",
  │     RTL      │      $finish tại t = 1006 (Icarus Verilog 12.0)
  ├──────────────┤
  │ 6. Tổng hợp  │ ✅  Yosys 0.33 — 101 cell · 17 FF · 975,936 µm²
  ├──────────────┤
  │ 7. STA       │ ✅  OpenSTA 3.1.0 — arrival 2,5 ns · slack 7,42 ns
  │              │      (sau tổng hợp, chưa có ký sinh dây)
  ├──────────────┤
  │ 8. Công suất │ ✅  ước lượng 9,81e-05 W (tổ hợp 24,1 % · tuần tự 75,9 %)
  ├──────────────┤
  │ 9. Floorplan │ ⬜  chưa chạy
  │ 10. Placement│ ⬜  chưa chạy
  │ 11. CTS      │ ⬜  chưa chạy
  │ 12. Routing  │ ⬜  chưa chạy
  │ 13. DRC      │ ⬜  chưa chạy
  │ 14. LVS      │ ⬜  chưa chạy
  │ 15. GDSII    │ ⬜  chưa chạy
  ├──────────────┤
  │ 16. Tape-out │ ⬛  KHÔNG áp dụng — Charter mục 3 xếp ngoài phạm vi
  └──────────────┘
```

> D03 là đề **liền mạch nhất** trong nhóm: chuỗi bằng chứng từ yêu cầu tới STA không đứt đoạn.
> Điểm yếu còn lại **không** nằm ở công cụ mà nằm ở **độ phủ**: ca N=255 mới chạy 20/510 nhịp
> cần thiết (xem `corner_cases.md` §2).

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*
