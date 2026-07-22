HELM_BUILDKITE_APT_KEY_ID="DDF78C3E6EBB2D2CC223C95C62BA89D07698DBC6"

sudo apt-get install curl gpg apt-transport-https --yes

curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey > "${TMPDIR:-/tmp}/helm.gpg"

# Ensure that the key ID matches to prevent a repository compromise from establishing an attacker controlled key
if [ "$(gpg --show-keys --with-colons "${TMPDIR:-/tmp}/helm.gpg" | awk -F: '$1 == "fpr" {print $10}' | head -n 1)" != "${HELM_BUILDKITE_APT_KEY_ID}" ]; then echo "ERROR: Unexpected Helm APT key ID: potential key compromise"; exit 1; fi

cat "${TMPDIR:-/tmp}/helm.gpg" | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

sudo apt-get update
sudo apt-get install helm

helm version

# Search from Artifact Hub
helm search hub wordpress

# Add a repo
helm repo add bitnami https://charts.bitnami.com/bitnami

# Search chart on a repo
helm search repo wordpress

# list the repo
helm repo list
helm repo remove chart-repo

# Install chart
helm install amaze-surf bitnami/apache

# List releases of charts
helm list

# Uninstall a release
helm uninstall happy-browse

# Upgrade a release
helm upgrade dazzling-web bitnami/nginx --version 18.3.6

# Rollback a release
helm rollback dazzling-web 3