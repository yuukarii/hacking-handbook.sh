# List containers
crictl ps -a

crictl ps -a | grep etcd

# Show logs for an etcd container.
ETCD_CONTAINER_ID="$(crictl ps -a --name etcd -q | head -n1)"
crictl logs "$ETCD_CONTAINER_ID"
