#!/bin/bash

# NOTE: run this script to bootstrap a managed ansible node by using:
# export SSH_PUB_KEY=$(cat ~/.ssh/id_rsa.pub) && ssh user@host "sudo SSH_PUB_KEY='$SSH_PUB_KEY' bash -s" < "$SCRIPTS/ansible/bootstrap-managed-node.sh"

set -euo pipefail

ANSIBLE_USER="ansible"

# create ansible user
echo "Creating user ${ANSIBLE_USER}"
useradd -m -s /bin/bash "$ANSIBLE_USER" || true

# grant sudo privileges
echo "Giving user ${ANSIBLE_USER} sudo permissions"
usermod -aG sudo "$ANSIBLE_USER"
echo "${ANSIBLE_USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/ansible

# set up ssh auth
echo "Setting up SSH auth for user ${ANSIBLE_USER}"
echo "Public key:"
echo "$SSH_PUB_KEY"
mkdir -p /home/${ANSIBLE_USER}/.ssh
echo "$SSH_PUB_KEY" >/home/${ANSIBLE_USER}/.ssh/authorized_keys
chmod 700 /home/${ANSIBLE_USER}/.ssh
chmod 600 /home/${ANSIBLE_USER}/.ssh/authorized_keys
chown -R ${ANSIBLE_USER}:${ANSIBLE_USER} /home/${ANSIBLE_USER}/.ssh

# make sure python is installed
echo "Making sure python exists"
apt-get update && apt-get install -y python3
