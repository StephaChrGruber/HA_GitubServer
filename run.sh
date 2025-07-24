#!/bin/sh

set -e

echo "[GitServer] Setting up Git SSH server..."

# Create git user home and .ssh directory
mkdir -p /home/git/.ssh
chmod 700 /home/git/.ssh
touch /home/git/.ssh/authorized_keys

# Inject public key from add-on config
echo "$PUBLIC_KEY" > /home/git/.ssh/authorized_keys
chmod 600 /home/git/.ssh/authorized_keys
chown -R git:git /home/git

# 🛠 Generate host keys if missing
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
  echo "[GitServer] Generating SSH host keys..."
  ssh-keygen -A
fi

# ✅ Start SSH daemon
echo "[GitServer] Starting SSH daemon..."
exec /usr/sbin/sshd -D
