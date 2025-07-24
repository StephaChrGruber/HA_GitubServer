#!/bin/sh

set -e

echo "[GitServer] Setting up Git SSH server..."

# Configure authorized_keys from public_key option
mkdir -p /home/git/.ssh
echo "$PUBLIC_KEY" > /home/git/.ssh/authorized_keys
chmod 700 /home/git/.ssh
chmod 600 /home/git/.ssh/authorized_keys
chown -R git:git /home/git

# Ensure persistent repo directory exists
REPO_PATH="/share/gitbox/repos"
mkdir -p "$REPO_PATH"
chown -R git:git "$REPO_PATH"

# Generate SSH host keys if missing
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
  echo "[GitServer] Generating SSH host keys..."
  ssh-keygen -A
fi

# Launch SSH on port 2222
echo "[GitServer] Starting SSH daemon on port 2222..."
exec /usr/sbin/sshd -D -p 2222
