kubelet --version

# Kubelet configuration file
less /var/lib/kubelet/config.yaml

# Kubelet kubeconfig (includes the API server endpoint)
grep 'server:' /etc/kubernetes/kubelet.conf

# Check status of the kubelet service
systemctl status kubelet

# Get kubelet logs
journalctl -xeu kubelet --no-pager | tail -50
