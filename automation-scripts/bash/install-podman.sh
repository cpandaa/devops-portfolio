#!/usr/bin/env bash
echo Install Podman script
#!/usr/bin/env bash
# install-podman.sh - Install Podman on RHEL/CentOS
set -euo pipefail

echo "[INFO] Checking OS..."
if ! grep -qiE "red hat|centos|rocky|alma" /etc/os-release; then
  echo "[ERROR] This script is intended for RHEL/CentOS/ only."
  exit 1
fi

PKG_MGR=""
if command -v dnf >/dev/null 2>&1; then
  PKG_MGR="dnf"
elif command -v yum >/dev/null 2>&1; then
  PKG_MGR="yum"
else
  echo "[ERROR] Neither dnf nor yum found."
  exit 1
fi

echo "[INFO] Installing Podman..."
sudo $PKG_MGR -y install podman

# Optional but useful: skopeo + buildah for full OCI workflow
if $PKG_MGR list --available skopeo >/dev/null 2>&1; then
  sudo $PKG_MGR -y install skopeo || true
fi
if $PKG_MGR list --available buildah >/dev/null 2>&1; then
  sudo $PKG_MGR -y install buildah || true
fi

echo "[INFO] Configuring registries (add docker.io fallback)..."
sudo mkdir -p /etc/containers
sudo tee /etc/containers/registries.conf >/dev/null <<'EOF'
unqualified-search-registries = ["registry.fedoraproject.org", "registry.access.redhat.com", "docker.io", "quay.io"]

[[registry]]
prefix = "docker.io"
location = "registry-1.docker.io"
blocked = false
EOF

# Optional: configure short-name mode to prompt once then record choice
sudo tee /etc/containers/registries.conf.d/000-shortnames.conf >/dev/null <<'EOF'
short-name-mode="permissive"
EOF

echo "[INFO] Enabling Podman REST API socket (optional)..."
# This is only needed if you plan to use the Docker-compatible REST API over a socket
if systemctl list-unit-files | grep -q podman.socket; then
  sudo systemctl enable --now podman.socket || true
fi

echo "[INFO] Rootless setup tips:"
echo "  - Add your user to subuid/subgid ranges if missing (usually already set by default on modern distros)."
echo "  - You can run: 'podman system migrate' after first install to refresh rootless config."

echo "[INFO] Testing Podman..."
podman --version
# Run a quick test as rootless (preferred) if possible
if [[ $EUID -ne 0 ]]; then
  podman run --rm hello-world 2>/dev/null || podman run --rm quay.io/podman/hello
else
  sudo -u "$(logname)" podman run --rm hello-world 2>/dev/null || \
  sudo -u "$(logname)" podman run --rm quay.io/podman/hello
fi

echo "[SUCCESS] Podman installation complete."
echo "Examples:"
echo "  podman images"
echo "  podman run --rm quay.io/podman/hello"
echo "  # Docker-compatible socket (if enabled): unix:///run/podman/podman.sock"
