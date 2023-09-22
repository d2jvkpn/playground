#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# https://docs.gitlab.com/omnibus/settings/memory_constrained_envs.html
# https://forum.gitlab.com/t/gitlab-commit-500-error/53139/5
cp config/gitlab.rb config/gitlab.rb.bk

cat >> config/gitlab.rb << EOF
####
puma['enable'] = true
puma['worker_timeout'] = 120
puma['worker_processes'] = 2
puma['per_worker_max_memory_mb'] = 2048

sidekiq['max_concurrency'] = 10

prometheus_monitoring['enable'] = false

gitlab_rails['env'] = {
  'MALLOC_CONF' => 'dirty_decay_ms:1000,muzzy_decay_ms:1000',
  'GITLAB_RAILS_RACK_TIMEOUT' => 600,
}

#gitaly['cgroups_count'] = 2
#gitaly['cgroups_mountpoint'] = '/sys/fs/cgroup'
#gitaly['cgroups_hierarchy_root'] = 'gitaly'
#gitaly['cgroups_memory_enabled'] = true
#gitaly['cgroups_memory_limit'] = 500000
#gitaly['cgroups_cpu_enabled'] = true
#gitaly['cgroups_cpu_shares'] = 512

#gitaly['concurrency'] = [
#  {
#    'rpc' => "/gitaly.SmartHTTPService/PostReceivePack",
#    'max_per_repo' => 3
#  }, {
#    'rpc' => "/gitaly.SSHService/SSHUploadPack",
#    'max_per_repo' => 3
#  }
#]
#gitaly['env'] = {
#  'LD_PRELOAD' => '/opt/gitlab/embedded/lib/libjemalloc.so',
#  'MALLOC_CONF' => 'dirty_decay_ms:1000,muzzy_decay_ms:1000',
#  'GITALY_COMMAND_SPAWN_MAX_PARALLEL' => '2'
#}
EOF

docker exec gitlab_app gitlab-ctl reconfigure
