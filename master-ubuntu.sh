#!/bin/bash
sudo apt-get update 
yes | sudo apt-get install -y apt-transport-http
yes | sudo apt-get install -y ca-certificates
yes | sudo apt-get install  -y curl
yes | sudo apt-get install -y gnupg-agent 
yes | sudo apt-get install -y software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
yes | sudo apt-get install -y docker-ce
yes | sudo apt-get install -y  docker-ce-cli
yes | sudo apt-get install -y  containerd.io
sudo systemctl status docker
sudo usermod -aG docker ubuntu


curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" >> ~/kubernetes.list
sudo mv ~/kubernetes.list /etc/apt/sources.list.d
sudo apt update
yes | sudo apt-get install -y kubelet
yes | sudo apt-get install -y kubeadm
yes | sudo apt-get install -y kubectl 
yes | sudo apt-get install -y kubernetes-cni
sudo swapoff -a
sudo hostnamectl set-hostname master
lsmod | grep br_netfilter
sudo modprobe br_netfilter
sudo sysctl net.bridge.bridge-nf-call-iptables=1
cat <<EOF | sudo tee /etc/docker/daemon.json
 { "exec-opts": ["native.cgroupdriver=systemd"],
 "log-driver": "json-file",
 "log-opts":
  { "max-size": "100m" },
  "storage-driver": "overlay2"
  }
EOF
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo rm -rf /etc/containerd/config.toml
sudo systemctl restart containerd
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=NumCPU,Mem
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo ufw allow 6443
sudo ufw allow 6443/tcp 
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
