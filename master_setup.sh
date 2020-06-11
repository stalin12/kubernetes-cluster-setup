#!/bin/bash

# set up the Docker and Kubernetes repositories:

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

#Install Docker and Kubernetes packages:
#Note that if you want to use a newer version of Kubernetes, change the version installed for 
#kubelet, kubeadm, and kubectl.
#Make sure all three use the same version.
#Note: There is currently a bug in Kubernetes 1.13.4 (and earlier) 
#that can cause problems installaing the packages. Use 1.13.5-00 to avoid this issue.

apt-get update

apt-get install -y docker-ce kubelet=1.13.5-00 kubeadm=1.13.5-00 kubectl=1.13.5-00

apt-mark hold docker-ce kubelet kubeadm kubectl

#Enable iptables bridge call:
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf

sysctl -p

#Initialize the cluster:
 kubeadm init --pod-network-cidr=10.244.0.0/16

#Set up local kubeconfig:
 mkdir -p $HOME/.kube
 cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
 chown $(id -u):$(id -g) $HOME/.kube/config

#Install Flannel networking:
  kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml



