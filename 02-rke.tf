provider "helm" {
  kubernetes {
    config_path = "kubeconfig.yaml"
  }
}

provider "rke" {
  debug    = true
  log_file = "rke_debug.log"
}

module "rke" {
  source = "./modules/rke"
  depends_on = [
    module.cloud
  ]
  domain          = var.domain
  rke_cluster_ips = module.cloud.ip_addresses
  prefix          = var.prefix
}