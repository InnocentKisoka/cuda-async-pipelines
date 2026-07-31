# CUDA Streams, Events & Async Pipelines

[![CUDA](https://img.shields.io/badge/CUDA-C%2B%2B-76B900?logo=nvidia&logoColor=white)](https://developer.nvidia.com/cuda-zone)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Shows how to **hide PCIe latency** by overlapping host↔device copies with device compute using **CUDA streams**, **events**, **pinned memory**, and **chunked pipelines**.

---

## Skills demonstrated

| Skill | File |
|-------|------|
| `cudaStream_t` / RAII stream wrapper | all |
| `cudaEvent_t` timing & dependencies | `01_*` |
| `cudaMemcpyAsync` | `01_*`, `02_*` |
| Pinned (`cudaHostAlloc`) vs pageable host memory | `01_*` |
| Multi-stream wait-on-event pipelines | `02_chunked_pipeline_newton.cu` |
| Chunked domain decomposition for overlap | `02_*` |
| Nonlinear per-element Newton solve as GPU workload | `02_*`, `03_*` |

**Resume bullets:**
- Designed a **multi-stream pipeline** overlapping H2D, compute, and D2H for chunked workloads.
- Used CUDA **events** for fine-grained timing and cross-stream dependencies without full `cudaDeviceSynchronize`.
- Applied **pinned host memory** for efficient asynchronous transfers.

---

## Mental model

```
Time →
H2D stream:   [chunk0] [chunk1] [chunk2] ...
Kernel stream:    wait→[k0] wait→[k1] wait→[k2]
D2H stream:              wait→[d0] wait→[d1] ...
```

Without streams, each phase is serial: `H2D | kernel | D2H | H2D | ...`  
With pipelines, transfers of chunk *k+1* overlap kernel of chunk *k*.

---

## Build & run

```bash
make ARCH=sm_80
./bin/01_stream_events_axpy 22
./bin/02_chunked_pipeline_newton 22 8   # N=2^22, 8 chunks
```

Compare total time vs a naive single-stream baseline when available.

---

## Attribution

Adapted from CSCS–USI Summer School async CUDA practicals; portfolio packaging by Innocent Kisoka.
