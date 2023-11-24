check:
	bash check.sh

up:
	mkdir -p logs
	echo "================" >> logs/k8s_up.log

	date +"==> %FT%T%:z: step01_kvm_nodes.sh" >> logs/k8s_up.log

	bash step01_kvm_nodes.sh \
	  k8s-cp01 k8s-cp02 k8s-cp03 \
	  k8s-node01 k8s-node02 k8s-node03 k8s-node04

	date +"==> %FT%T%:z: step02_cluster_up.sh" >> logs/k8s_up.log
	bash step02_cluster_up.sh

	date +"==> %FT%T%:z: step03_kube_apply.sh" >> logs/k8s_up.log
	bash step03_kube_apply.sh

	date +"==> %FT%T%:z: done" >> logs/k8s_up.log

