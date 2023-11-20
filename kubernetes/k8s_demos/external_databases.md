### External Database
---

#### 1. postgres up on k8s-cp02
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

#### 2. External Database
```bash
kubectl apply -f k8s_demos/external_databases.yaml
```

#### 3. Test
```bah
kubectl apply -f k8s_demos/pod_ubuntu.yaml
# kubectl delete pod/ubuntu

kubectl exec ubuntu -- bash -c 'apt update && apt install -y netcat postgresql-client curl'

kubectl exec -it ubuntu -- bash
# nc -zv k8s-cp02-databases 5432
# psql --host=k8s-cp02-databases --port=5432 --username=postgres
```
