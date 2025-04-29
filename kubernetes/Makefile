SHELL := /bin/bash

latest:
	bash k8s_misc/k8s_latest.sh

# version=1.32.1 make download
download:
	bash k8s_cluster.sh download $(version)

check:
	bash k8s_cluster.sh check

create-mini:
	bash k8s_cluster.sh create k8s-cp01 k8s-node01 k8s-node02

create-full:
	bash k8s_cluster.sh create k8s-cp01 k8s-cp{02,03} k8s-node{01..04}

list:
	bash k8s_cluster.sh list

start:
	bash k8s_cluster.sh start

down:
	bash k8s_cluster.sh down

erase:
	sudo bash k8s_cluster.sh erase
