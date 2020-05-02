# kubernetes-cluster-setup

Get join Token:
   kubeadm token create --print-join-command
   Ex: kubeadm join 172.31.14.136:6443 --token 9mt6bb.kgq5zm4g2pm7ljy9 --discovery-token-ca-cert-hash   sha256:802909381775fbb3115452a21a08d14e88d68ff6afa2e118e4e4929f637c9ccb
   
Removing a Worker Node from the Cluster:
   Migrate Pods:
     kubectl drain  <node-name> --delete-local-data --ignore-daemonsets
   Prevent a node from scheduling new pods use:
     kubectl cordon <node-name>
   Revert changes made to the node by 'kubeadm join'
     kubeadm reset
