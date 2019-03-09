storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault/"
}

listener "tcp" {
  address     = "127.0.0.1:8200"
  api_addr    = "http://127.0.0.1:18200"
  cluster_addr    = "http://127.0.0.1:18201"
  tls_disable = 1
}
