echo '{"name": "pod-1", "status": "Running"}' | jq '.'
echo '{"name": "pod-1"}' | jq '.name'
kubectl get pod mypod -o json | jq '.status.phase'
echo '[1,2,3]' | jq '.[0]'
kubectl get pods -o json | jq '.items[].metadata.name'

# Filtering
kubectl get pods -o json | jq '.items[] | select(.status.phase == "Running")'
kubectl get pods -o json | jq '.items[] | select(.status.phase == "Running") | .metadata.name'
kubectl get pods -o json | jq '.items[] | {name: .metadata.name, phase: .status.phase}'
kubectl get pods -o json | jq '[.items[] | {name: .metadata.name, phase: .status.phase}]'

# raw output
kubectl get pods -o json | jq -r '.items[].metadata.name'