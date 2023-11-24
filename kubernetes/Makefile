check:
	bash check.sh

up:
	mkdir -p logs
	echo "================================================================" > logs/k8s_up.log

	date +"==> %FT%T%:z step01_kvm_node.sh" >> logs/k8s_up.log
	bash step01_kvm_node.sh ubuntu k8s-cp01

	date +"==> %FT%T%:z step02_clone_nodes.sh" >> logs/k8s_up.log
	bash step02_clone_nodes.sh k8s-cp01 \
	  k8s-cp02 k8s-cp03 \
	  k8s-node01 k8s-node02 k8s-node03 k8s-node04

	date +"==> %FT%T%:z step03_cluster_up.sh" >> logs/k8s_up.log
	bash step03_cluster_up.sh k8s-cp01 k8s-node01

	date +"==> %FT%T%:z step04_kube_apply.sh" >> logs/k8s_up.log
	bash step04_kube_apply.sh k8s-cp01 k8s-node01

	date +"==> %FT%T%:z done" >> logs/k8s_up.log

down:
	ansible k8s_all -m shell --become -a 'shutdown now'

erase:
	for node in $(shell awk '{print \$2}' configs/kvm_k8s.txt); do
	    bash ../kvm/src/virsh_delete.sh $node || true
	done
