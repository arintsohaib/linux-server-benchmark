#!/bin/bash
set -e

RESULT_FILE="benchmark-$(hostname)-$(date +%Y%m%d-%H%M%S).txt"

exec > >(tee "$RESULT_FILE") 2>&1

echo "======================================"
echo " Linux Server Benchmark"
echo "======================================"
echo "Host: $(hostname)"
echo "Date: $(date)"
echo "======================================"
echo

echo "### Installing dependencies ###"
apt update
apt install -y sysbench fio linux-cpupower util-linux procps
echo

echo "### Setting CPU governor to PERFORMANCE ###"
cpupower frequency-set -g performance || echo "cpupower not supported (virtual CPU)"
echo

echo "### SYSTEM INFORMATION ###"
hostnamectl
echo
lscpu | egrep 'Model name|Socket|Thread|Core|CPU\(s\)'
echo
free -h
echo
lsblk -d -o NAME,ROTA,SIZE,MODEL
echo

CORES=$(nproc)

echo "======================================"
echo " CPU TEST (Single Core)"
echo "======================================"
sysbench cpu --cpu-max-prime=20000 --threads=1 run
echo

echo "======================================"
echo " CPU TEST (All Cores: $CORES)"
echo "======================================"
sysbench cpu --cpu-max-prime=20000 --threads=$CORES run
echo

echo "======================================"
echo " MEMORY TEST (Sequential Write)"
echo "======================================"
sysbench memory \
--memory-block-size=1M \
--memory-total-size=10G \
--memory-oper=write run
echo

echo "======================================"
echo " MEMORY TEST (Sequential Read)"
echo "======================================"
sysbench memory \
--memory-block-size=1M \
--memory-total-size=10G \
--memory-oper=read run
echo

echo "======================================"
echo " DISK TEST (Random RW 4K)"
echo "======================================"
fio --name=randrw \
--ioengine=libaio \
--iodepth=32 \
--rw=randrw \
--rwmixread=70 \
--bs=4k \
--direct=1 \
--size=4G \
--numjobs=1 \
--runtime=60 \
--group_reporting
echo

echo "======================================"
echo " DISK TEST (Sequential Read)"
echo "======================================"
fio --name=seqread \
--ioengine=libaio \
--iodepth=32 \
--rw=read \
--bs=1M \
--direct=1 \
--size=4G \
--numjobs=1 \
--runtime=60 \
--group_reporting
echo

echo "======================================"
echo " DISK TEST (Sequential Write)"
echo "======================================"
fio --name=seqwrite \
--ioengine=libaio \
--iodepth=32 \
--rw=write \
--bs=1M \
--direct=1 \
--size=4G \
--numjobs=1 \
--runtime=60 \
--group_reporting
echo

echo "======================================"
echo " Benchmark completed"
echo " Results saved to: $RESULT_FILE"
echo "======================================"
