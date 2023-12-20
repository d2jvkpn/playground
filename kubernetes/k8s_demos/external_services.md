### External Services
---

#### 1. Postgres up on k8s-node01
```bash
mkdir -p docker_dev/postgres_dev

cd docker_dev/postgres_dev

mkdir -p data/postgres

cat > docker-compose.yaml << EOF
version: '3'

services:
  postgres:
    image: postgres:16-alpine
    container_name: postgres_dev
    restart: always
    # network_mode: bridge
    networks: ["net"]
    # ports: ["127.0.0.1:${PORT}:5432"]
    ports: ["5432:5432"]
    environment:
    - TZ=Asia/Shanghai
    - PGTZ=Asia/Shanghai
    - POSTGRES_USER=postgres
    - POSTGRES_DB=postgres
    - POSTGRES_PASSWORD=postgres
    # - POSTGRES_PASSWORD_FILE=/run/secrets/postgres-passwd
    - PGDATA=/var/lib/postgresql/data
    volumes:
    - ./data/postgres:/var/lib/postgresql/data
    # - postgres:/var/lib/postgresql/data
    # - ./configs/postgresql.conf:/var/lib/postgresql/data/pgdata/postgresql.conf
    # - ./configs/pg_hba.conf:/var/lib/postgresql/data/pgdata/pg_hba.conf

# volums:
#   postgres: { name: postgres_storage, driver: local }

networks:
  net: { name: "postgres", driver: "bridge", external: false }
EOF

docker-compose up -d
```

#### 2. Create pod/postgres
```bash
kubectl apply -f k8s_demos/pod_postgres.yaml
kubectl -n dev get pod/postgres
kubectl -n dev exec -it pod/postgres -- /bin/bash

pod_ip=$(kubectl -n dev get service/postgres --output=yaml | yq eval .spec.clusterIP)

psql --username postgres --host $pod_ip --port 5432
# mysql -u root -h $pod_ip -P 3306 -p

kubectl -n dev port-forward pod/postgres 2001:5432

psql --username postgres --host 127.0.0.1 --port 2001
# mysql -u root -h 127.0.0.1 -P 2001 -p
```

#### 3. External databases endpoint
```bash
cat > k8s_apps/data/external_databases.yaml  <<EOF
apiVersion: v1
kind: Service
metadata:
   namespace: dev
   name: k8s-node01-databases
spec:
   type: ClusterIP
   ports:
   - { protocol: TCP, name: postgres, port: 5432, targetPort: 5432 }
   - { protocol: TCP, name: mysql, port: 3306, targetPort: 3306 }

---
apiVersion: v1
kind: Endpoints
metadata:
  namespace: dev
  name: k8s-node01-databases
subsets:
  - addresses:
    # localhost ip or the serivce ip
    - ip: 192.168.122.136
    ports:
    - { name: postgres, port: 5432 }
    - { name: mysql, port: 3306 }
EOF

kubectl apply -f k8s_apps/data/external_databases.yaml
```

#### 4. Test
```bah
kubectl apply -f k8s_demos/pod_ubuntu.yaml
# kubectl delete pod/ubuntu

kubectl exec ubuntu -- bash -c 'apt update && apt install -y netcat postgresql-client curl'

kubectl exec -it ubuntu -- bash
# nc -zv k8s-node01-databases 5432
# psql --host=k8s-node01-databases --port=5432 --username=postgres
```

#### 5. External nginx on k8s-node01
```bash
sudo apt -y install nginx
systemctl status nginx

ls /etc/nginx/nginx.conf /etc/nginx/conf.d /etc/nginx/sites-enabled

sudo sed 's/listen 80 default_server/listen 1024 default_server/; \
  s/listen [::]:80 default_server/listen [::]:1024 default_server/' \
  /etc/nginx/sites-enabled/default

sudo nginx -t && sudo nginx -s reload

kubectl apply -f k8s_demos/endpoint_nginx.yaml

curl -H 'Host: app.nginx.k8s.local' k8s.local
```
