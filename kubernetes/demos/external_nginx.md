### External Nginx
---

#### 1.1 install nginx on k8s-cp02
```bash
sudo apt -y install nginx
systemctl status nginx
ls /etc/nginx/nginx.conf /etc/nginx/conf.d /etc/nginx/sites-enabled

sudo sed 's/listen 80 default_server/listen 1024 default_server/; \
  s/listen [::]:80 default_server/listen [::]:1024 default_server/' \
  /etc/nginx/sites-enabled/default

sudo nginx -t && sudo nginx -s reload
```

#### 1.2 k8s apply
```bash
kubectl apply -f k8s_apps/data/external_nginx.yaml

curl -H 'Host: app.nginx.noreply.local' k8s-ingress01
```

#### 2.1 external name
```
cat | kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  namespace: dev
  name: mydomain
spec:
  type: ExternalName
  externalName: mydomain.local
selector: {}
EOF
```
