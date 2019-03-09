# hashiCorpConfigs
Configuration files for Hashi Corp Tools such as Vault, consul, vagrant, consul-template, etc.

# EXAMPLES 
Admin@LatitudeE7240 MINGW64 ~
$ vault auth list
Path      Type     Accessor               Description
----      ----     --------               -----------
token/    token    auth_token_7290e495    token based credentials

Admin@LatitudeE7240 MINGW64 ~
$ vault secrets list
Path          Type         Accessor              Description
----          ----         --------              -----------
cubbyhole/    cubbyhole    cubbyhole_105b6982    per-token private secret storage
identity/     identity     identity_8d2c1481     identity store
secret/       kv           kv_d1699a1c           key/value secret storage
sys/          system       system_1aa39786       system endpoints used for control, policy and debugging

Admin@LatitudeE7240 MINGW64 ~
$

Admin@LatitudeE7240 MINGW64 ~
$ vault auth enable approle
Success! Enabled approle auth method at: approle/

Admin@LatitudeE7240 MINGW64 ~
$ vault auth list
Path        Type       Accessor                 Description
----        ----       --------                 -----------
approle/    approle    auth_approle_98160325    n/a
token/      token      auth_token_7290e495      token based credentials

Admin@LatitudeE7240 MINGW64 ~
$
Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault.d (master)
$ cat afs_dev_dla_policy.hcl
path "secret/data/afs/dev/dla" {
  capabilities = ["read", "list"]
}

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault.d (master)
$ vault policy write afs_dev_dla_policy afs_dev_dla_policy.hcl
Success! Uploaded policy: afs_dev_dla_policy

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault.d (master)
$ vault policy list
afs_dev_dla_policy
default
root

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault.d (master)
$ vault policy read afs_dev_dla_policy
path "secret/data/afs/dev/dla" {
  capabilities = ["read", "list"]
}

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault.d (master)
$

# Create token using ROOT token (to do so, login with root token...)
Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault.d (master)
$ vault token create -field=token
s.3tLbJf4a98tLwz9wtT45d6i1

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault-agent.d (master)
$
# AppRole documentation ...
https://www.hashicorp.com/blog/authenticating-applications-with-vault-approle
https://www.vaultproject.io/api/auth/approle/index.html

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/consul-template.d (master)
$ vault delete auth/approle/role/afs_dla_role
Success! Data deleted (if it existed) at: auth/approle/role/afs_dla_role

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/consul-template.d (master)
$ vault write auth/approle/role/afs_dla_role policies=afs_dev_dla_policy token_num_uses=5 token_ttl=5m
Success! Data written to: auth/approle/role/afs_dla_role

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/consul-template.d (master)
$ vault read auth/approle/role/afs_dla_role
WARNING! The following warnings were returned from Vault:

  * The "bound_cidr_list" parameter is deprecated and will be removed in favor
  of "secret_id_bound_cidrs".

Key                      Value
---                      -----
bind_secret_id           true
bound_cidr_list          <nil>
local_secret_ids         false
period                   0s
policies                 [afs_dev_dla_policy]
secret_id_bound_cidrs    <nil>
secret_id_num_uses       0
secret_id_ttl            0s
token_bound_cidrs        <nil>
token_max_ttl            0s
token_num_uses           5
token_ttl                5m
token_type               default

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/consul-template.d (master)
$ cd -
/c/Users/Admin/personalGit/hashiCorpConfigs/vault-agent.d

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault-agent.d (master)
$ vault read auth/approle/role/afs_dla_role/role-id -format=json | jq -r '.data.role_id' > afs_dla_role-id.txt

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault-agent.d (master)
$ vault write -f auth/approle/role/afs_dla_role/secret-id -format=json | jq -r '.data.secret_id' > afs_dla_secret-id.txt

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault-agent.d (master)
$
# === OR ===

# Create ROLE
Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault-agent.d (master)
$ curl --header "X-Vault-Token: s.3tLbJf4a98tLwz9wtT45d6i1" --request POST --data '{"policies": "afs_dev_dla_policy,afs_qa_dla_policy"}' http://127.0.0.1:8200/v1/auth/approle/role/afs_dla_role
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    52    0     0  100    52      0   4000 --:--:-- --:--:-- --:--:--  4333

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault.d (master)
$

# RETRIEVE role-id for the role created above
Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault-agent.d (master)
$ curl -s --header "X-Vault-Token: s.3tLbJf4a98tLwz9wtT45d6i1" http://127.0.0.1:8200/v1/auth/approle/role/afs_dla_role/role-id | jq -r ".data.role_id" > afs_dla_role-id.txt

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault-agent.d (master)
$ cat afs_dla_role-id.txt
e975a682-7424-23ce-f977-9d219c74141e

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault-agent-agent.d (master)
$

# CREATE secret-id for the role created above (Each time you run this command creates new secret-id ...)
Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault.d (master)
$ curl -s --header "X-Vault-Token: s.3tLbJf4a98tLwz9wtT45d6i1" --request POST http://127.0.0.1:8200/v1/auth/approle/role/afs_dla_role/secret-id  | jq -r ".data.secret_id"  > afs_dla_secret-id.txt

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault-agent.d (master)
$ cat afs_dla_secret-id.txt
5d15f45a-af94-66bb-4a29-6f850cc8fa15

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault-agent.d (master)
$


# VAULT AGENT:
https://www.vaultproject.io/docs/agent/index.html


Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault-agent.d (master)
Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault-agent.d (master)
$ cat afs_dla_app_role.hcl
pid_file = "./pidfile"

exit_after_auth = true

auto_auth {
        method "approle" {
                mount_path = "auth/approle"
                config = {
                        role_id_file_path = "./afs_dla_role-id.txt"
                        secret_id_file_path = "./afs_dla_secret-id.txt"
                        remove_secret_id_file_after_reading = "false"
                }
        }

        sink "file" {
                config = {
                        path = ".vault-token"
                }
        }
}

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/vault-agent.d (master)
$

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/consul-template.d (master)
$ export VAULT_TOKEN=$(cat ../vault-agent.d/.vault-token); consul-template -config=consulTemplate.hcl -log-level=info -once;  export VAULT_TOKEN=''; ls -lrt ./consulTemplate_out.txt
2019/03/09 21:38:06.172749 [INFO] consul-template v0.20.0 (b709612c)
2019/03/09 21:38:06.172749 [INFO] (runner) creating new runner (dry: false, once: true)
2019/03/09 21:38:06.172749 [WARN] (clients) disabling vault SSL verification
2019/03/09 21:38:06.172749 [INFO] (runner) creating watcher
2019/03/09 21:38:06.173749 [INFO] (runner) starting
2019/03/09 21:38:06.192023 [INFO] (runner) once mode and all templates rendered
2019/03/09 21:38:06.192023 [INFO] (runner) stopping
-rw-r--r-- 1 Admin 197121 7 Mar  9 16:20 ./consulTemplate_out.txt

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/consul-template.d (master)
$ export VAULT_TOKEN=$(cat ../vault-agent.d/.vault-token); rm -f ./consulTemplate_out.txt; consul-template -config=consulTemplate.hcl -log-level=info -once;  export VAULT_TOKEN=''; ls -lrt ./consulTemplate_out.txt
2019/03/09 21:38:31.961141 [INFO] consul-template v0.20.0 (b709612c)
2019/03/09 21:38:31.961141 [INFO] (runner) creating new runner (dry: false, once: true)
2019/03/09 21:38:31.962124 [WARN] (clients) disabling vault SSL verification
2019/03/09 21:38:31.962124 [INFO] (runner) creating watcher
2019/03/09 21:38:31.962124 [INFO] (runner) starting
2019/03/09 21:38:31.996114 [INFO] (runner) rendered "./consulTemplate_in.ctmpl" => "./consulTemplate_out.txt"
2019/03/09 21:38:31.996114 [INFO] (runner) once mode and all templates rendered
2019/03/09 21:38:31.996114 [INFO] (runner) stopping
-rw-r--r-- 1 Admin 197121 7 Mar  9 16:38 ./consulTemplate_out.txt

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/consul-template.d (master)
$ cat ./consulTemplate_out.txt
user01

Admin@LatitudeE7240 MINGW64 ~/personalGit/hashiCorpConfigs/consul-template.d (master)
$

