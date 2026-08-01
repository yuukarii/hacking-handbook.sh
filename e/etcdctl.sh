# Create ETCD backup
ETCDCTL_API=3 etcdctl --endpoints https://127.0.0.1:2379 \
   --cert /etc/kubernetes/pki/apiserver-etcd-client.crt \
   --key /etc/kubernetes/pki/apiserver-etcd-client.key \
   --cacert /etc/kubernetes/pki/etcd/ca.crt \
   snapshot save /opt/etcd-backup.db