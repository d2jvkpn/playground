# Deploy mysql pod on k8s

#### 1. Deploy
```bash
kubectl apply -f k8s_demos/mysql_pod.yaml
kubectl -n dev get pod/mysql
kubectl -n dev exec -it pod/mysql -- /bin/bash

pod_ip=$(kubectl -n dev get service/mysql --output=yaml | yq eval .spec.clusterIP)

mysql -u root -h $pod_ip -P 3306 -p
```

#### 2. Port forwarding
```bash
kubectl -n dev port-forward pod/mysql 2001:3306

mysql -u root -h 127.0.0.1 -P 2001 -p
```
