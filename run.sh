#!/bin/sh

set -e

echo "[GitServer] Setting up Git SSH server..."

# Create .ssh folder and inject key
mkdir -p /home/git/.ssh
chmod 700 /home/git/.ssh
echo "$PUBLIC_KEY" > /home/git/.ssh/authorized_keys
chmod 600 /home/git/.ssh/authorized_keys
chown -R git:git /home/git

# Generate SSH host keys if needed
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
  echo "[GitServer] Generating SSH host keys..."
  ssh-keygen -A
fi

# Optional: keep container alive for debugging
# tail -f /dev/null &

# Start sshd on custom port
echo "[GitServer] Starting SSH daemon on port 2222..."
exec /usr/sbin/sshd -D -p 2222
