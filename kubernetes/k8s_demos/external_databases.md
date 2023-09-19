### External Database
---

#### 1. External Database
```bash
kubectl apply -f k8s_demos/external_database.yaml
```

#### 2. Test
```bah
kubectl apply -f k8s_demos/ubuntu_pod.yaml
# kubectl delete pod/ubuntu

kubectl exec ubuntu -- bash -c 'apt update && apt install -y netcat postgresql-client curl'

kubectl exec -it ubuntu -- bash
# nc -zv cp02-database 5432
# psql --host=cp02-database --port=5432 --username=postgres
```
