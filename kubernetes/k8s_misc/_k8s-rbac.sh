#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


#### 1. **创建证书和私钥：**
## 首先，为用户 `bob` 创建证书和私钥，并使用 Kubernetes CA 签署这个证书，这需要有 OpenSSL 或者类似工具：

account=bob
org=dev
role=dev
namespace=dev

# kubectl cluster-info
server=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
cluster=k8s

openssl genrsa -out $account.k8s.key 2048
openssl req -new -key $account.k8s.key -out $account.csr -subj "/CN=$account/O=$org"

sudo openssl x509 -req -in $account.k8s.csr \
  -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key \
  -CAcreateserial -out $account.k8s.crt -days 365

#### 2. **创建 KubeConfig 文件：**
## 为 `bob` 创建一个新的 KubeConfig 文件，以用于访问集群：

k8s_ca=$(base64 -w 0 /etc/kubernetes/pki/ca.crt)
crt=$(base64 -w 0 $account.k8s.crt)
key=$(base64 -w 0 $account.k8s.key)

cat > $account.k8s-config.yaml <<EOF
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: $k8s_ca
    server: $server
  name: $cluster
contexts:
- context:
    cluster: $cluster
    user: $account
    namespace: $namespace
  name: $account@$cluster
current-context: $account@$cluster
users:
- name: $account
  user:
    client-certificate-data: $crt
    client-key-data: $key
EOF

#### 3. **创建 Role 和 RoleBinding：**
## 创建一个 Role，定义 `bob` 可以在 `dev` 命名空间中执行的操作。例如，允许 `bob` 查看和编辑所有资源：

cat > $role.role.yaml <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: $namespace
  name: $role
rules:
- apiGroups: [""]
  resources: ["configmaps", "pods", "deployments", "services"] # "secrets"
  verbs: ["get", "list", "watch", "create", "update", "delete"]
- apiGroups: ["metrics.k8s.io"]
  resources: ["pods"]
  verbs: ["get", "list"]
EOF

kubectl apply -f $role.role.yaml

## 创建一个 RoleBinding，将 `dev` 绑定到用户 `bob`：

cat > ${role}-${account}.rb.yaml <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  namespace: $namespace
  name: ${role}-${account}
subjects:
- kind: User
  name: $account
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: $role
  apiGroup: rbac.authorization.k8s.io
EOF

kubectl apply -f ${role}-${account}.rb.yaml

#### 4. 测试

export KUBECONFIG=$account.k8s-config.yaml

kubectl config current-context
kubectl get pods
kubectl top pods
