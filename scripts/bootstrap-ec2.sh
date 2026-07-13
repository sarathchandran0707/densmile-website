#!/bin/bash
# One-time setup script — run this ONCE on a fresh EC2 instance (Amazon Linux 2023 / Ubuntu)
# before the pipeline can deploy to it. It just installs Docker and starts the daemon.
#
# Usage (on the EC2 instance, over SSH):
#   chmod +x bootstrap-ec2.sh
#   ./bootstrap-ec2.sh

set -e

echo "Updating packages..."
sudo yum update -y 2>/dev/null || sudo apt-get update -y

echo "Installing Docker..."
if command -v yum >/dev/null; then
  sudo yum install -y docker
else
  sudo apt-get install -y docker.io
fi

echo "Starting Docker and enabling it on boot..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Allowing the current user to run docker without sudo..."
sudo usermod -aG docker $USER

echo "Done. Log out and back in for group changes to apply, then verify with: docker ps"
