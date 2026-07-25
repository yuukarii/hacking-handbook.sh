# Create kustomization.yaml.
cat > kustomization.yaml <<'EOF'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - db/db-config.yaml
  - db/db-depl.yaml
  - db/db-service.yaml
  - message-broker/rabbitmq-config.yaml
  - message-broker/rabbitmq-depl.yaml
  - message-broker/rabbitmq-service.yaml
  - nginx/nginx-depl.yaml
  - nginx/nginx-service.yaml

namespace: logging

commonAnnotations:
  owner: bob@gmail.com

commonLabels:
  sandbox: dev

images:
  - name: postgres
    newName: mysql
    newTag: "1.2.3"

components:
  - components/logging-sidecar

patches:
  - path: patch-delete-memcached.yaml
    target:
      kind: Deployment
      name: api-deployment

  - patch: |-
      - op: remove
        path: /spec/template/metadata/labels/org
    target:
      kind: Deployment
      name: mongo-deployment

  - patch: |-
      - op: replace
        path: /spec/template/spec/containers/0/image
        value: caddy
    target:
      kind: Deployment
      name: api-deployment
EOF

# Create patch-delete-memcached.yaml.
cat > patch-delete-memcached.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-deployment
spec:
  template:
    spec:
      containers:
        - name: memcached
          $patch: delete
EOF

# Create components/logging-sidecar/kustomization.yaml.
mkdir -p components/logging-sidecar
cat > components/logging-sidecar/kustomization.yaml <<'EOF'
apiVersion: kustomize.config.k8s.io/v1alpha1
kind: Component
patches:
  - path: sidecar-patch.yaml
resources:
  - configmap.yaml
EOF


#####################################################

# Check which resources added
kubectl kustomize .

# Apply the configurations
kubectl apply -k .
