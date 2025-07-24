#!/bin/sh

set -e

echo "[GitServer] Starting SSH and Git service..."

# Set up SSH key (public key must be placed manually)
if [ ! -f /home/git/.ssh/authorized_keys ]; then
  echo "[GitServer] No authorized_keys found, refusing to start"
  exit 1
fi

# Set proper permissions
chown -R git:git /home/git/.ssh
chmod 700 /home/git/.ssh
chmod 600 /home/git/.ssh/authorized_keys

# Start SSH daemon
/usr/sbin/sshd -D
