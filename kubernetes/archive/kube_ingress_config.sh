#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0)

exit
kubectl -n kube-system get configmap nginx-configuration -o yaml |
  yq .data.log-format-upstream

exit
{
  "allow-backend-server-header": "true",
  "enable-underscores-in-headers": "true",
  "generate-request-id": "true",
  "ignore-invalid-headers": "true",
  "log-format-upstream": "$remote_addr - [$remote_addr] - $remote_user [$time_local] \"$request\" $status $body_bytes_sent \"$http_referer\" \"$http_user_agent\" $request_length $request_time [$proxy_upstream_name] $upstream_addr $upstream_response_length $upstream_response_time $upstream_status $req_id $host [$proxy_alternative_upstream_name]",
  "max-worker-connections": "65536",
  "proxy-body-size": "20m",
  "proxy-connect-timeout": "10",
  "reuse-port": "true",
  "server-tokens": "false",
  "ssl-ciphers": "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA256:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA",
  "ssl-protocols": "TLSv1 TLSv1.1 TLSv1.2 TLSv1.3",
  "ssl-redirect": "false",
  "upstream-keepalive-timeout": "900",
  "worker-cpu-affinity": "auto"
}


exit
kubectl -n ingress-nginx get configmap ingress-nginx-controller

nginx-ingress-controller
