#!/bin/sh
set -e

# Generate SSH host keys if not already present
[ ! -f /etc/ssh/ssh_host_rsa_key ] && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' -q
[ ! -f /etc/ssh/ssh_host_ecdsa_key ] && ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' -q
[ ! -f /etc/ssh/ssh_host_ed25519_key ] && ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N '' -q

# Start the SSH daemon
exec /usr/sbin/sshd -D
