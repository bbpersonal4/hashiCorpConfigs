vault {
  address = "http://127.0.0.1:8200"

  grace = "5m"

  # Will be set as VAULT_TOKEN variable ...
  #token = ""

  unwrap_token = false

  renew_token = false

  retry {
  }

  ssl {
    enabled = false

    verify = false

    #ca_cert = "./devops_interm.pem"
  }
}

syslog {
  enabled = false

  facility = "LOCAL5"
}

deduplicate {
  enabled = false

  #prefix = "consul-template/dedup/"
}

template {
  source = "./consulTemplate_in.ctmpl"

  destination = "./consulTemplate_out.txt"

  create_dest_dirs = true

  error_on_missing_key = false

  perms = 0600

  backup = true

  left_delimiter  = "{{"

  right_delimiter = "}}"

  #wait {
   # min = "2s"

    #max = "10s"
  #}
}
