#!/bin/bash

# Init control plane...
echo 'Init control plane...'
kubeadm init --pod-network-cidr=10.244.0.0/16
# Setup flannel...
echo 'Setup  flannel...'
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

# export KUBECONFIG
echo 'export KUBECONFIG'
export KUBECONFIG=/etc/kubernetes/admin.conf