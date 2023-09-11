### External Postgres
---

#### 1. Commands
```bash
kubectl apply -f k8s_data/external_database.yaml

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  namespace: dev
  name: ubuntu
  labels:
    app: ubuntu
spec:
  containers:
  - name: ubuntu
    image: ubuntu:22.04
    command: ["tail", "-f", "/etc/hosts"]
    imagePullPolicy: IfNotPresent
  restartPolicy: Always
EOF
# kubectl delete pod/ubuntu

kubectl exec ubuntu -- bash -c 'apt update && apt install -y netcat postgresql-client curl'

kubectl exec -it ubuntu -- bash
# nc -zv cp02-database 5432
# psql --host=cp02-database --port=5432 --username=postgres
```
