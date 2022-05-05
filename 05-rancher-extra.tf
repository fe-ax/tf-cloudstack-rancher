# Provider config for admin
provider "rancher2" {
  alias = "admin"

  api_url   = module.rancher.admin_url
  token_key = module.rancher.admin_token
  insecure  = true
}

module "rancher-extra" {
  source = "./modules/rancher-extra"
  depends_on = [
    module.rke
  ]
  providers = {
    rancher2.admin = rancher2.admin
  }
  local_cluster_ips   = module.cloud.ip_addresses
  local_cluster_sg_id = module.cloud.sg_id
  prefix              = var.prefix
  home_ips            = var.home_ips
  cloud_extra_cluster = var.cloud_extra_cluster
}
