#!/usr/bin/env bash
# Create a user with sudo, SSH key, and no-password sudo option (optional)
set -euo pipefail

usage(){ echo "Usage: $(basename "$0") <username> [/path/to/public_key.pub]"; exit 1; }
[[ $# -ge 1 ]] || usage

USER_NAME="$1"
PUBKEY="${2:-}"

sudo id -u "${USER_NAME}" >/dev/null 2>&1 || sudo useradd -m -s /bin/bash "${USER_NAME}"
sudo usermod -aG sudo "${USER_NAME}" 2>/dev/null || sudo usermod -aG wheel "${USER_NAME}" || true

if [[ -n "${PUBKEY}" && -f "${PUBKEY}" ]]; then
  sudo -u "${USER_NAME}" mkdir -p "/home/${USER_NAME}/.ssh"
  sudo install -m 600 "${PUBKEY}" "/home/${USER_NAME}/.ssh/authorized_keys"
  sudo chown -R "${USER_NAME}:${USER_NAME}" "/home/${USER_NAME}/.ssh"
fi

if [[ "${NOPASS_SUDO:-false}" == "true" ]]; then
  echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/90-${USER_NAME}" >/dev/null
fi

echo "User ${USER_NAME} provisioned."

