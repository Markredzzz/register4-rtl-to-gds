# Validated reference results

This directory contains a compact evidence snapshot from the successful
`RUN_2026-11-17_17-34-34` OpenLane Classic flow. The complete generated
`runs/` tree is intentionally excluded because it is reproducible and much
larger than the source project.

| File | Purpose |
|---|---|
| `metrics.json` | Machine-readable implementation and signoff metrics |
| `sta_summary.rpt` | Multi-corner setup/hold summary |
| `lvs.rpt` | Netgen LVS report; final result is `Circuits match uniquely` |
| `register4.gds` | Final SKY130 GDS from the validated run |

Key results:

- RTL testbench: 9/9 checks passed.
- OpenLane Classic: 78/78 stages completed.
- Worst setup slack: +6.2499 ns; setup violations: 0.
- Worst hold slack: +0.4628 ns; hold violations: 0.
- OpenROAD routing DRC, Magic DRC, and KLayout DRC: 0.
- Antenna violations and disconnected pins: 0.

These files demonstrate an educational open-source RTL-to-GDS run. They are
not a foundry tape-out signoff package. In particular, the flow used generic
fallback SDC files, and its IR-drop result is not production-valid because no
`VSRC_LOC_FILES` model was supplied.
