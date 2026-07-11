# Calico is a Container Network Interface (CNI) that provides support for Kubernetes NetworkPolicy enforcement.

# Installation Guidelines
# Follow the self-managed on-premises installation guide for Calico, available from the links in the top-right corner of the terminal:

# https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.32.1/manifests/v1_crd_projectcalico_org.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.32.1/manifests/tigera-operator.yaml

# Critical Requirements

# Dataplane Selection:
# Use the standard Linux dataplane (iptables-based)
# Do NOT use the eBPF dataplane option — it is incompatible with this lab environment

curl -O https://raw.githubusercontent.com/projectcalico/calico/v3.32.1/manifests/custom-resources.yaml
vim custom-resources.yaml
kubectl create -f custom-resources.yaml
watch kubectl get tigerastatus

# Installation Components:
# Calico is deployed using the Tigera Operator
# You must install both the operator and the custom resource definitions (CRDs)
# Follow the installation steps in the correct order as specified in the documentation

# Network Configuration:
# The pod network CIDR must be configured as 172.17.0.0/16
# This setting is critical for pod-to-pod communication in this cluster
# You will need to create and modify a Calico Installation custom resource manifest
# Ensure the cidr field matches the required value before applying the configuration

# Verification
# Confirm that all Calico pods reach a Running state before proceeding:

watch kubectl get pods -n calico-system

# Note: You may see errors on the csi-node-driver pod deployed in the calico-system namespace after you deploy Calico. These can be safely ignored and will not affect network policy enforcement.