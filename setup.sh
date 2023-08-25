#!/bin/bash

# Install packages...
echo 'Install packages...'
sudo apt-get update && \
sudo apt-get install -y apt-transport-https ca-certificates curl linux-modules-extra-raspi containerd && \
curl -fsSL https://dl.k8s.io/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg && \
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update && \
sudo apt-get install -y kubelet kubeadm kubectl && \
sudo apt-mark hold kubelet kubeadm kubectl

# Configure containerd...
echo 'Configure containerd...'
mkdir -p /etc/containerd && \
containerd config default > /etc/containerd/config.toml && \
sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay && \
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system && \
sudo systemctl restart containerd && \
sudo systemctl restart kubelet

# Reboot
echo 'Setup complete!!'
echo 'A reboot of the device will be performed after 10 seconds.'
sleep 10 && sudo reboot