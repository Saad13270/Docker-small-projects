#!/bin/bash

set -e

echo "Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "Removing any old Docker versions if they exist..."
sudo apt-get remove -y docker docker-engine docker.io containerd runc || true

echo "Installing required dependencies..."
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common lsb-release gnupg

echo "Adding Docker's official GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating package index with Docker packages..."
sudo apt-get update -y

echo "Installing Docker Engine, CLI, containerd, and Compose plugin..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Enabling Docker service to start on boot..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Adding current user ($USER) to docker group to run Docker without sudo..."
sudo usermod -aG docker $USER

echo "Docker installation completed successfully."

echo "IMPORTANT: You may need to log out and log back in for group changes to take effect."

echo "Testing Docker installation..."
docker --version
docker run hello-world || echo "If you see this, log out and log in again, then re-run the 'hello-world' container."
