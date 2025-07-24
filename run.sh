#!/bin/sh

set -e

echo "[GitServer] Starting Git SSH server..."

# Ensure home and ssh directory exists
mkdir -p /home/git/.ssh
chmod 700 /home/git/.ssh
touch /home/git/.ssh/authorized_keys

# Populate authorized_keys from config
echo "$PUBLIC_KEY" > /home/git/.ssh/authorized_keys

# Set correct permissions
chown -R git:git /home/git
chmod 600 /home/git/.ssh/authorized_keys

# Start SSH server
echo "[GitServer] Starting SSH daemon..."
exec /usr/sbin/sshd -D
