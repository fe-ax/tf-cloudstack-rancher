prefix = "example"

cloudstack_provider = {
  api_url    = ""
  api_key    = ""
  secret_key = ""
}

cloud_local_cluster = {
  count            = 3
  service_offering = ""
  network_id       = ""
  template         = "Ubuntu 20.04"
  zone             = ""
  root_disk_size   = 20
}

cloud_extra_cluster = {
  count_cp            = 3
  count_worker        = 3
  service_offering    = ""
  network_id          = ""
  template            = "Ubuntu 20.04"
  zone                = ""
  root_disk_size      = 20
  extra_disk_offering = ""
}

transip = {
  account_name = "myaccount1"
  private_key  = <<EOF
-----BEGIN PRIVATE KEY-----
-----END PRIVATE KEY-----
EOF
}

home_ips = ["1.2.3.4/32"]

domain = {
  domain    = "domain.com"
  subdomain = "my"
}