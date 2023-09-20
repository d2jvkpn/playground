# Deploy postgres pod on k8s

#### 1. Deploy
```bash
kubectl apply -f k8s_demos/pod_postgres.yaml
kubectl -n dev get pod/postgres
kubectl -n dev exec -it pod/postgres -- /bin/bash

pod_ip=$(kubectl -n dev get service/postgres --output=yaml | yq eval .spec.clusterIP)

psql --username postgres --host $pod_ip --port 5432
# mysql -u root -h $pod_ip -P 3306 -p
```

#### 2. Port forwarding
```bash
kubectl -n dev port-forward pod/mysql 2001:5432

psql --username postgres --host 127.0.0.1 --port 2001
# mysql -u root -h 127.0.0.1 -P 2001 -p
```
