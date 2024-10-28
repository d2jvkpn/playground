#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# *https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/*

mkdir -p k8s.local/data

cat > k8s.local/data/tail-f-hosts.ds.yaml <<EOF
apiVersion: apps/v1
kind: DaemonSet
metadata:
  namespace: kube-system
  name: hello-ds
  labels: { k8s-app: hello-ds }
spec:
  selector:
    matchLabels: { name: tail-f-hosts }
  template:
    metadata:
      labels: { name: tail-f-hosts }
    spec:
      tolerations:
      # these tolerations are to have the daemonset runnable on control plane nodes
      # remove them if your control plane nodes should not run pods
      - { key: node-role.kubernetes.io/control-plane, operator: Exists, effect: NoSchedule }
      - { key: node-role.kubernetes.io/master, operator: Exists, effect: NoSchedule }
      terminationGracePeriodSeconds: 30
      volumes:
      - { name: varlog, hostPath: { path: /var/log } }
      containers:
      - name: hello-ds
        image: alpine:latest
        resources:
          limits: { memory: 200Mi }
          requests: { cpu: 100m, memory: 200Mi }
        volumeMounts:
        - { name: varlog, mountPath: /var/log }
        command: [tail, -f, /etc/hosts]
EOF

kubectl apply -f k8s.local/data/tail-f-hosts.ds.yaml

kubectl -n kube-system get pods --selector=name=tail-f-hosts
