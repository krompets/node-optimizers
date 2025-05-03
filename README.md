## 🚀 Node Optimizer Script for Ethereum / SSV / Beacon Nodes

This script applies a set of **system-level optimizations** to improve the performance, stability, and responsiveness of validator infrastructure. It is tailored for:

- Ethereum Execution Clients (e.g., Nethermind)
- Consensus Clients (e.g., Prysm)
- SSV Nodes and related tooling

---

### 🔧 What It Does

The script automatically performs the following:

1. ✅ **Enables `performance` CPU governor**  
   Ensures your CPU runs at maximum frequency to reduce validation delays.

2. ✅ **Disables swap memory**  
   Prevents disk-based memory usage that can introduce harmful latency.

3. ✅ **Sets `vm.swappiness = 1`**  
   Instructs the kernel to avoid using swap unless absolutely necessary.

4. ✅ **Installs and starts `chrony`**  
   Maintains highly accurate system time — critical for consensus operations.

5. ✅ **Enables TCP BBR congestion control**  
   Improves network throughput and lowers latency for P2P and RPC traffic.

6. ✅ **Runs full validation checks**  
   Verifies each optimization and prints results with ✅ or ❌ indicators.

---

### 📦 Requirements

- Ubuntu 20.04 / 22.04 (or similar Debian-based Linux)
- Root or `sudo` access

---

### 🖥️ Example Usage

```bash
wget https://example.com/node_optimizer.sh -O node_optimizer.sh
chmod +x node_optimizer.sh
sudo ./node_optimizer.sh
```

Expected output:
```
✅ CPU governor: performance
✅ Swappiness is 1
✅ Swap is disabled
✅ Chrony is running
✅ TCP congestion control: bbr
✅ BBR module loaded
✅ default_qdisc: fq
```

---

### 💡 Why It Matters

Validator nodes are sensitive to:

- CPU frequency scaling  
- Disk I/O (swap) lag  
- Network latency and congestion  
- Time synchronization issues

This script ensures your node is **optimized for maximum responsiveness** and **ready for high-performance validator duties**.
