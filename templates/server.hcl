server {
  enabled = true
  bootstrap_expect = 3

  server_join {
    retry_join = ["%%BOOTSTRAP_IP%%:4648"]
  }
}
