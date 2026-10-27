# D03 · Bối cảnh ứng dụng



| | |
|---|---|
| Mã đề | **D03** |
| Tên đề | Bộ chia tần lập trình được (chia N, N = 1–255) |
| Nhóm đề | D · Bộ đếm và chia tần |
| Độ khó | Trung bình |
| Loại mạch | **Tuần tự** |
| Quy mô ước lượng (Charter) | ~150–220 cell · 1×1 tile |
| Nguồn gốc | Project Charter — D03, mục 1 |

---

## 1. Mục tiêu và bối cảnh ứng dụng

Trích nguyên văn Charter mục 1:

> Phân tích khối số “Bộ chia tần lập trình được (chia N, N = 1–255)” ở mức khối. Bối cảnh ứng dụng: Khối tạo nhịp lấy mẫu chậm từ xung nhịp hệ thống trong bộ ghi dữ liệu môi trường.

## 2. Vị trí khối D03 trong hệ thống

```
   ┌──────────────┐      ┌──────────────────────────────┐      ┌──────────────┐
   │  Nguồn tín   │─────▶│      ►►► KHỐI D03 ◄◄◄        │─────▶│  Tầng tiêu   │
   │  hiệu / dữ   │      │  Bộ chia tần lập trình được ( │      │  thụ kết quả │
   │  liệu vào    │      │  Loại mạch: Tuần tự          │      │              │
   └──────────────┘      └──────────────────────────────┘      └──────────────┘
```

> Sơ đồ chi tiết có chú thích: `03_ARCHITECTURE/system_diagram.md`.

## 3. Phân loại analog / digital / mixed

| Khối | Phân loại | Ghi chú |
|---|---|---|
| Cảm biến / nguồn tín hiệu vật lý (nếu có) | Analog | Đại lượng liên tục |
| Chuyển đổi ADC/DAC (nếu có) | Mixed-signal | Ranh giới analog–số |
| **D03 — Bộ chia tần lập trình được (chia N, N = 1–255)** | **Digital, tuần tự** | Có ô nhớ, hoạt động theo cạnh clock |
| Tầng xử lý phía sau | Digital | Tiêu thụ kết quả của D03 |

Bằng chứng cho dòng phân loại của D03: tổng hợp thật cho **17 flip-flop**
(`06_GDSII/synthesis/synth_stat.txt`).

---

**Truy vết:** yêu cầu sinh từ tài liệu này được đánh số `REQ-D03-0xx` trong
`01_REQUIREMENT/requirements.md`, và truy vết đến bằng chứng trong `07_TRACEABILITY/RTM.csv`.

*Phiên bản: v1.0 · Ngày: 2026-09-24*
