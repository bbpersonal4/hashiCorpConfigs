storage "inmem" {
}

listener "tcp" {
  address     = "127.0.0.1:18200"
  tls_disable = 1
}
