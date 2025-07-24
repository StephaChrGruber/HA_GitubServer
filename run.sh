#!/bin/sh

set -e

echo "[GitServer] Loading config from /data/options.json..."

# Read the public_key from the JSON config file
PUBLIC_KEY=$(jq -r .public_key /data/options.json)

echo "[GitServer] Injecting public key: $PUBLIC_KEY"

# === Setup authorized_keys ===
mkdir -p /home/git/.ssh
echo "$PUBLIC_KEY" > /home/git/.ssh/authorized_keys
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
chmod 700 /home/git/.ssh
chmod 600 /home/git/.ssh/authorized_keys
chown -R git:git /home/git

# === Persistent host keys ===
HOSTKEY_DIR="/share/gitbox/hostkeys"
mkdir -p "$HOSTKEY_DIR"

if [ ! -f "$HOSTKEY_DIR/ssh_host_ed25519_key" ]; then
  echo "[GitServer] Generating new SSH host keys..."
  ssh-keygen -t rsa -f "$HOSTKEY_DIR/ssh_host_rsa_key" -N ""
  ssh-keygen -t ed25519 -f "$HOSTKEY_DIR/ssh_host_ed25519_key" -N ""
fi

ln -sf "$HOSTKEY_DIR"/ssh_host_* /etc/ssh/

# === Persistent Git repos ===
REPO_PATH="/share/git_server/repos"
mkdir -p "$REPO_PATH"
chown -R git:git "$REPO_PATH"

echo "[GitServer] ENV DUMP:"
env

echo "[GitServer] PUBLIC_KEY value:"
echo "$PUBLIC_KEY"

# === Start SSH ===
echo "[GitServer] Unlocking git user and setting valid shell..."
echo "[GitServer] Unlocking git user..."
sed -i 's/^git:!:/git::/' /etc/shadow
echo "[GitServer] Starting SSH daemon on port 2222..."
exec /usr/sbin/sshd -p 2222

# Keep container running
echo "[GitServer] Running tail to keep container alive..."
