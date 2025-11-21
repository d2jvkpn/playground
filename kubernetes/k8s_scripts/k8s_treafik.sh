#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

# https://doc.traefik.io/traefik/reference/install-configuration/providers/kubernetes/kubernetes-crd/
# https://doc.traefik.io/traefik/setup/kubernetes/

####
image_tag=v3
helm_version=37.3.0
treafik_dir=cache/k8s.download/treafik
mkdir -p $treafik_dir

####
docker pull traefik:$image_tag
docker save traefik:$image_tag | pigz -c > $treafik_dir/traefik--$image_tag.tar.gz

helm repo add traefik https://traefik.github.io/charts
helm repo update
helm pull traefik/traefik --version $helm_version -d $treafik_dir
#ls $treafik_dir/traefik-$helm_version.tgz

exit
####
cat > $treafik_dir/values.yaml <<EOF
# Configure Network Ports and EntryPoints
# EntryPoints are the network listeners for incoming traffic.
ports:
  # Defines the HTTP entry point named 'web'
  web:
    port: 80
    nodePort: 30000
    # Instructs this entry point to redirect all traffic to the 'websecure' entry point
    redirections:
      entryPoint:
        to: websecure
        scheme: https
        permanent: true

  # Defines the HTTPS entry point named 'websecure'
  websecure:
    port: 443
    nodePort: 30001

# Enables the dashboard in Secure Mode
api:
  dashboard: true
  insecure: false

ingressRoute:
  dashboard:
    enabled: true
    matchRule: Host(`dashboard.docker.localhost`)
    entryPoints:
      - websecure
    middlewares:
      - name: dashboard-auth

# Creates a BasiAuth Middleware and Secret for the Dashboard Security
extraObjects:
  - apiVersion: v1
    kind: Secret
    metadata:
      name: dashboard-auth-secret
    type: kubernetes.io/basic-auth
    stringData:
      username: admin
      password: "P@ssw0rd"      # Replace with an Actual Password
  - apiVersion: traefik.io/v1alpha1
    kind: Middleware
    metadata:
      name: dashboard-auth
    spec:
      basicAuth:
        secret: dashboard-auth-secret

# We will route with Gateway API instead.
ingressClass:
  enabled: false

# Enable Gateway API Provider & Disables the KubernetesIngress provider
# Providers tell Traefik where to find routing configuration.
providers:
  kubernetesIngress:
     enabled: false
  kubernetesGateway:
     enabled: true

## Gateway Listeners
gateway:
  listeners:
    web:           # HTTP listener that matches entryPoint `web`
      port: 80
      protocol: HTTP
      namespacePolicy:
        from: All

    websecure:         # HTTPS listener that matches entryPoint `websecure`
      port: 443
      protocol: HTTPS  # TLS terminates inside Traefik
      namespacePolicy:
        from: All
      mode: Terminate
      certificateRefs:    
        - kind: Secret
          name: local-selfsigned-tls  # the Secret we created before the installation
          group: ""

# Enable Observability
logs:
  general:
    level: INFO
  # This enables access logs, outputting them to Traefik's standard output by default. The [Access Logs Documentation](https://doc.traefik.io/traefik/observability/access-logs/) covers formatting, filtering, and output options.
  access:
    enabled: true

# Enables Prometheus for Metrics
metrics:
  prometheus:
    enabled: true
EOF

helm install traefik traefik/traefik --namespace traefik --values $treafik_dir/values.yaml

exit
reference=https://raw.githubusercontent.com/traefik/traefik/v3.6/docs/content/reference

# curl -x socks5h://127.0.0.1:1080 -o $output_dir/kubernetes-crd-definition-v1.yml $reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
wget -P $treafik_dir $reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
wget -P $treafik_dir $reference/dynamic-configuration/kubernetes-crd-rbac.yml

# Install Traefik Resource Definitions:
kubectl apply -f $treafik_dir/lubernetes-crd-definition-v1.yml
# Install RBAC for Traefik:
kubectl apply -f $treafik_dir/kubernetes-crd-rbac.yml

# Check
kubectl get pods -n traefik
kubectl get svc -n traefik
