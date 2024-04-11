### Zentao Deployment
---

#### 1. Links
- https://www.zentao.net/
- https://www.zentao.net/book/zentaopms/docker-1111.html

#### 2. Init
```bash
docker pull hub.zentao.net/app/zentao:18.11
docker pull mariadb:11

./docker_deploy.sh 3041
docker-compose up -d
```
