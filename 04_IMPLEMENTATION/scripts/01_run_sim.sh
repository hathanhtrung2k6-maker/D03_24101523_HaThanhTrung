#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"; cd "$ROOT"
OUT=05_VERIFICATION
mkdir -p "$OUT/waveforms"

command -v iverilog >/dev/null || { echo "[LOI] thieu 'iverilog'"; exit 2; }

iverilog -g2012 -o "$OUT/sim.vvp" \
    04_IMPLEMENTATION/rtl/d03_core.sv \
    05_VERIFICATION/golden_model/d03_reference.sv \
    05_VERIFICATION/testbench/d03_core_tb.sv

cd "$OUT"
mkdir -p waveforms
vvp sim.vvp | tee simulation.log
cd "$ROOT"

echo "Chạy mô phỏng hoàn tất! Đang bật GTKWave..."
gtkwave 05_VERIFICATION/waveforms/d03_wave.vcd &
