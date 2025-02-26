#!//bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

kubectl get deployments -o json | jq -r '
  .items[] | 
  {
    namespace: .metadata.namespace,
    name: .metadata.name,
    requests_cpu: .spec.template.spec.containers[].resources.requests.cpu,
    requests_memory: (
      .spec.template.spec.containers[].resources.requests.memory |
      if . == null then null
      elif endswith("Ki") then (.[:-2] | tonumber / 1024 | tostring + "Mi")
      elif endswith("Mi") then .
      elif endswith("Gi") then (.[:-2] | tonumber * 1024 | tostring + "Mi")
      elif endswith("K") then (.[:-1] | tonumber / 1024 | tostring + "Mi")
      elif endswith("M") then (.[:-1] | tostring + "Mi")
      elif endswith("G") then (.[:-1] | tonumber * 1024 | tostring + "Mi")
      else . + "Mi" end
    ),
    limits_cpu: .spec.template.spec.containers[].resources.limits.cpu,
    limits_memory: (
      .spec.template.spec.containers[].resources.limits.memory |
      if . == null then null
      elif endswith("Ki") then (.[:-2] | tonumber / 1024 | tostring + "Mi")
      elif endswith("Mi") then .
      elif endswith("Gi") then (.[:-2] | tonumber * 1024 | tostring + "Mi")
      elif endswith("K") then (.[:-1] | tonumber / 1024 | tostring + "Mi")
      elif endswith("M") then (.[:-1] | tostring + "Mi")
      elif endswith("G") then (.[:-1] | tonumber * 1024 | tostring + "Mi")
      else . + "Mi" end
    )
  }' |
    jq -r -s '. |
  ["namespace", "name", "requests_cpu", "requests_memory", "limits_cpu", "limits_memory"],
  (.[] | [.namespace, .name, .requests_cpu, .requests_memory, .limits_cpu, .limits_memory])  | @tsv'

exit
for ns in $(kubectl get ns); do
   kubectl get pods
    kubectl top pods  --containers
    echo $ns
done
