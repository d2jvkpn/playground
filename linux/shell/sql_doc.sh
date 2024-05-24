#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# echo "Hello, world!"

inputs=$@

awk '/-- #### Table /{sub("--", ""); sub("^ +", "", $0); print "\n"$0}
  /, *--/{
    sub("^ +", "", $0);
    sub(" +", "\t", $0);
    sub(", +-- *", "\t", $0);
    sub("; *==", "\t", $0);
    print $0
  }' migrations/*.up.sql |
  awk 'BEGIN{FS=OFS="\t"; print "field", "type", "comment", "binding"}
    {if (NF> 0 && NF < 4) { $4=""}; print}' > configs/sql_schema.tsv

exit

echo "==> an example"

cat << EOF
-- #### Table user_org_members 用户账户成员表
CREATE TABLE user_org_members (
  org_id      UUID NOT NULL,                      -- 组织 id; ==user_orgs.id
  account_id  UUID NOT NULL,                      -- 账户 id; ==user_accounts.id
  created_at  timestamptz NOT NULL DEFAULT now(), -- 账户 id
  updated_at  timestamptz DEFAULT NULL,           -- 更新时间
  status      bool DEFAULT true,                  -- 状态

  PRIMARY KEY (org_id, account_id)
);
EOF
