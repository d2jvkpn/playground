### External Nginx
---

#### 1 install nginx on k8s-cp02
```bash
sudo apt -y install nginx
systemctl status nginx

ls /etc/nginx/nginx.conf /etc/nginx/conf.d /etc/nginx/sites-enabled

sudo sed 's/listen 80 default_server/listen 1024 default_server/; \
  s/listen [::]:80 default_server/listen [::]:1024 default_server/' \
  /etc/nginx/sites-enabled/default

sudo nginx -t && sudo nginx -s reload
```

#### 2 k8s apply
```bash
kubectl apply -f k8s_demos/external_nginx.yaml

curl -H 'Host: app.nginx.k8s.local' k8s.local
```
