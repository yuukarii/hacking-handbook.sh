# Overall
k create -f file.yaml
k delete -f file.yaml
k apply -f file.yaml


# Interactive with pods
kubectl get pods -A

kubectl exec -it frontend -- curl -m 5 172.17.0.5
kubectl get pods -o wide
k describe pod kube-proxy-vt85d -n kube-system

k delete pod kube-flannel-ds-lx6hv -n kube-flannel

# Handle network policies
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
k describe cm coredns -n kube-system

# Check type of proxy
k logs -n kube-system kube-proxy-5t6q4 | grep -i "proxier"

# Handle service
k describe service kube-dns -n kube-system
k get svc -n webapp

# test connection
k exec -it test -- curl web-service
k exec -it test -- curl web-service.default
k exec -it test -- curl web-service.default.svc
k exec -it test -n default -- curl web-service.payroll.svc.cluster.local

# Deployments
k get deployments -A
k get deployments -n ingress-nginx

# Ingress
k get ingress -A
k describe ingress web-app-ingress -n webapp
k get ingress ingress-wear-watch -n app-space -o yaml > ingress-full.yaml
k delete ingress ingress-wear-watch -n app-space

cat > web-app-ingress.yaml <<'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
  name: web-app-ingress
  namespace: webapp
spec:
  tls:
  - hosts:
      - app.kodekloud.local
    secretName: app-tls
  ingressClassName: nginx
  rules:
  - host: app.kodekloud.local
    http:
      paths:
      - backend:
          service:
            name: web-app
            port:
              number: 80
        path: /
        pathType: Prefix
EOF

# Secret
k get secrets -n webapp
k get secret app-tls -n webapp -o yaml

# Gateway
# Install the Gateway API resources
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v1.5.1" | kubectl apply -f -
# Deploy the NGINX Gateway Fabric CRDs
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v1.6.1/deploy/crds.yaml
# Deploy NGINX Gateway Fabric
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v1.6.1/deploy/nodeport/deploy.yaml
# Verify the Deployment
kubectl get pods -n nginx-gateway
# View the nginx-gateway service
kubectl get svc -n nginx-gateway nginx-gateway -o yaml
# Update the nginx-gateway service to expose ports 30080 for HTTP and 30081 for HTTPS
kubectl patch svc nginx-gateway -n nginx-gateway --type='json' -p='[
  {"op": "replace", "path": "/spec/ports/0/nodePort", "value": 30080},
  {"op": "replace", "path": "/spec/ports/1/nodePort", "value": 30081}
]'

# Create a Kubernetes Gateway resource
cat > nginx-gateway.yaml <<'EOF'
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: nginx-gateway
  namespace: nginx-gateway
spec:
  gatewayClassName: nginx
  listeners:
  - name: http
    protocol: HTTP
    port: 80
    allowedRoutes:
      namespaces:
        from: All
EOF

k describe gateway nginx-gateway -n nginx-gateway

# Create an HTTPRoute
cat > frontend-route.yaml <<'EOF'
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: frontend-route
  namespace: default
spec:
  parentRefs:
  - name: nginx-gateway
    namespace: nginx-gateway
    sectionName: http
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: frontend-svc
      port: 80
EOF

kubectl get httproute frontend-route
kubectl describe httproute frontend-route

# Flannel
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
# In the Flannel DaemonSet spec
containers:
  - name: kube-flannel
    args:
      - --ip-masq
      - --kube-subnet-mgr
      - --iface=eth0    # Force Flannel to use eth0