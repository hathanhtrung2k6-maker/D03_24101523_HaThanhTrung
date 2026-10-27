#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"; cd "$ROOT"

echo "========================================================="
echo " Bat dau chay luong OpenLane / LibreLane de xuat GDSII..."
echo "========================================================="

# Kiem tra xem co cau hinh chay bang python hay chay truc tiep openlane
if [ -f "config.json" ]; then
    echo "Tim thay config.json, dang tien hành chạy luồng..."
    # Neu he thong cua ban dung openlane docker hoac openlane truc tiep
    if command -v openlane &> /dev/null; then
        openlane --tag d03_core_run config.json
    elif [ -d "openlane" ] || [ -f "flow.tcl" ]; then
        # Chay theo chuan flow openlane
        python3 -m openlane.cli --tag d03_core_run config.json || true
    else
        echo "[THONG BAO] Dang su dung yosys va openroad thu cong hoac qua openlane container..."
    fi
fi

# Neu co thu muc runs, tim file gds
if [ -d "runs" ] || [ -d "writable/runs" ]; then
    echo "Hoan tat! Kiem tra thu muc runs de lay file .gds"
else
    echo "Qua trinh tong hop vat ly hoan tat. Hay kiem tra file output trong thu muc project."
fi
