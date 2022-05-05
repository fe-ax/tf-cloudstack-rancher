provider "cloudstack" {
  api_url    = var.cloudstack_provider.api_url
  api_key    = var.cloudstack_provider.api_key
  secret_key = var.cloudstack_provider.secret_key
}

module "cloud" {
  source              = "./modules/cloud"
  cloud_local_cluster = var.cloud_local_cluster
  home_ips            = var.home_ips
  prefix              = var.prefix
}