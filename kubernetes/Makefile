check:
	bash check.sh

up:
	bash step01_kvm_nodes.sh \
	  k8s-cp01 k8s-cp02 k8s-cp03 \
	  k8s-node01 k8s-node02 k8s-node03 k8s-node04
	bash step02_cluster_up.sh
	bash step03_kube_apply.sh
