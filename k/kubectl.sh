
# Interactive with pods
kubectl get pods -A

kubectl exec -it frontend -- curl -m 5 172.17.0.5
kubectl get pods -o wide
k describe pod kube-proxy-vt85d -n kube-system

k delete pod kube-flannel-ds-lx6hv -n kube-flannel

# Handl network policies
k get networkpolicies
k describe networkpolicies deny-backend

# Handle Daemonset
k get daemonsets -A
k delete daemonsets -n kube-flannel kube-flannel-ds

# Get Pod CIDR
k cluster-info dump | grep -i cluster-cidr

# Get Service CIDR
k get servicecidr

# Handle configmap
k get configmap -A
k delete configmap kube-flannel-cfg -n kube-flannel
k get cm kube-proxy -n kube-system -o yaml | grep mode

# Check type of proxy
k logs -n kube-system kube-proxy-5t6q4 | grep -i "proxier"