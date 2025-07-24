#!/bin/sh

set -e

echo "[GitServer] Setting up Git SSH server..."

# === Inject authorized_keys ===
mkdir -p /home/git/.ssh
echo "$PUBLIC_KEY" > /home/git/.ssh/authorized_keys
chmod 700 /home/git/.ssh
chmod 600 /home/git/.ssh/authorized_keys
chown -R git:git /home/git

# === Persistent SSH host keys ===
HOSTKEY_DIR="/share/gitbox/hostkeys"
mkdir -p "$HOSTKEY_DIR"

# If no host keys exist in persistent storage, generate them
if [ ! -f "$HOSTKEY_DIR/ssh_host_ed25519_key" ]; then
  echo "[GitServer] Generating new SSH host keys..."
  ssh-keygen -t rsa -f "$HOSTKEY_DIR/ssh_host_rsa_key" -N ""
  ssh-keygen -t ed25519 -f "$HOSTKEY_DIR/ssh_host_ed25519_key" -N ""
fi

# Symlink keys into /etc/ssh (where sshd expects them)
ln -sf "$HOSTKEY_DIR/ssh_host_rsa_key" /etc/ssh/ssh_host_rsa_key
ln -sf "$HOSTKEY_DIR/ssh_host_rsa_key.pub" /etc/ssh/ssh_host_rsa_key.pub
ln -sf "$HOSTKEY_DIR/ssh_host_ed25519_key" /etc/ssh/ssh_host_ed25519_key
ln -sf "$HOSTKEY_DIR/ssh_host_ed25519_key.pub" /etc/ssh/ssh_host_ed25519_key.pub

# === Repo dir ===
REPO_PATH="/share/gitbox/repos"
mkdir -p "$REPO_PATH"
chown -R git:git "$REPO_PATH"

# === Start SSH ===
echo "[GitServer] Starting SSH daemon on port 2222..."
exec /usr/sbin/sshd -D -p 2222
