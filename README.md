# Linux Server Benchmark

A simple, reproducible benchmark suite for Linux servers focused on **CPU, memory, and disk performance**.

Designed for:
- Cloud VPS comparison (OVH,Hetzner, Netcup, AWS, DO, etc.)
- Build/compile workloads (Node.js, Python, Docker, CI)
- Debian-based systems (Debian 12 / 13)

---

## What this benchmark tests

### CPU
- Single-core performance
- Multi-core scalability

### Memory
- Sequential read & write bandwidth

### Disk
- Random 4K read/write (IOPS & latency)
- Sequential read/write throughput

---

## Why this exists

Most provider benchmarks are:
- Non-reproducible
- Biased
- Disk-only or CPU-only

This script:
- Uses **sysbench** and **fio**
- Forces CPU into `performance` governor
- Produces **comparable numeric output**
- Runs unattended
- Saves results automatically

---

## Requirements

- Debian 12 or Debian 13
- Root access
- At least 8GB RAM recommended

---

## Usage

```bash
git clone https://github.com/arintsohaib/linux-server-benchmark.git
cd linux-server-benchmark
chmod +x benchmark.sh
sudo ./benchmark.sh
