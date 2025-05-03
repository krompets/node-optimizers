#!/bin/sh

echo "🔧 Applying validator node optimizations..."

# 1. Install required tools
echo "📦 Installing packages..."
apt update -y
apt install -y cpufrequtils chrony linux-tools-common linux-tools-$(uname -r)

# 2. CPU governor
echo 'GOVERNOR="performance"' > /etc/default/cpufrequtils
systemctl enable cpufrequtils
systemctl start cpufrequtils
/usr/lib/linux-tools-$(uname -r)/cpupower frequency-set -g performance

# 3. Swappiness
sysctl vm.swappiness=1
grep -q "vm.swappiness" /etc/sysctl.conf || echo "vm.swappiness=1" >> /etc/sysctl.conf

# 4. Disable swap
swapoff -a
cp /etc/fstab /etc/fstab.bak
sed -i '/swap/s/^/#/' /etc/fstab

# 5. Chrony
systemctl enable chrony
systemctl start chrony

# 6. TCP BBR
modprobe tcp_bbr
echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
sysctl -p

# === VERIFICATION ===
echo ""
echo "🔍 Verification checks:"
echo "---------------------------"

# CPU governor
echo "🧪 CPU Governor:"
for CPU in /sys/devices/system/cpu/cpu[0-9]*; do
  GOV=$(cat "$CPU/cpufreq/scaling_governor")
  if [ "$GOV" = "performance" ]; then
    echo "✅ $CPU: $GOV"
  else
    echo "❌ $CPU: $GOV"
  fi
done

# Swappiness
echo ""
echo "🧪 Swappiness:"
SWAP=$(cat /proc/sys/vm/swappiness)
if [ "$SWAP" -eq 1 ]; then
  echo "✅ Swappiness is 1"
else
  echo "❌ Swappiness is $SWAP"
fi

# Swap usage
echo ""
echo "🧪 Swap usage:"
if swapon --noheadings | grep -q .; then
  echo "❌ Swap is still active"
else
  echo "✅ Swap is disabled"
fi

# Chrony
echo ""
echo "🧪 Chrony status:"
if systemctl is-active --quiet chrony; then
  echo "✅ Chrony is running"
else
  echo "❌ Chrony is not active"
fi

# TCP BBR
echo ""
echo "🧪 TCP BBR:"
CC=$(sysctl -n net.ipv4.tcp_congestion_control)
if [ "$CC" = "bbr" ]; then
  echo "✅ Congestion control: bbr"
else
  echo "❌ Congestion control: $CC"
fi

lsmod | grep -q bbr && echo "✅ BBR module loaded" || echo "❌ BBR module not loaded"

# Qdisc
echo ""
echo "🧪 default_qdisc:"
DQ=$(sysctl -n net.core.default_qdisc)
if [ "$DQ" = "fq" ]; then
  echo "✅ default_qdisc: fq"
else
  echo "❌ default_qdisc: $DQ"
fi

echo "---------------------------"
echo "✅ Done."
