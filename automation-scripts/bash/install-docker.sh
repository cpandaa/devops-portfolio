#!/usr/bin/env bash
echo Install Docker script
#!/usr/bin/env bash
# install-docker.sh - Install Docker CE on RHEL/CentOS/Rocky/AlmaLinux
set -euo pipefail

echo "[INFO] Checking OS..."
if ! grep -qiE "red hat|centos|rocky|alma" /etc/os-release; then
  echo "[ERROR] This script is intended for RHEL/CentOS/Rocky/AlmaLinux only."
  exit 1
fi

echo "[INFO] Removing old Docker versions (if any)..."
sudo yum remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine || true

echo "[INFO] Installing dependencies..."
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

echo "[INFO] Adding Docker CE repo..."
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "[INFO] Installing Docker CE..."
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[INFO] Configuring Docker daemon..."
sudo mkdir -p /etc/docker
cat <<'EOF' | sudo tee /etc/docker/daemon.json >/dev/null
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": { "max-size": "100m" },
  "storage-driver": "overlay2"
}
EOF

echo "[INFO] Enabling and starting Docker..."
sudo systemctl enable --now docker

echo "[SUCCESS] Docker installation complete!"
docker --version
