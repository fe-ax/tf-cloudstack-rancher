provider "rancher2" {
  alias = "bootstrap"

  api_url   = "https://${var.domain.subdomain}.${var.domain.domain}"
  insecure  = true
  bootstrap = true
}

module "rancher" {
  source = "./modules/rancher"
  depends_on = [
    module.rke
  ]
  providers = {
    rancher2.bootstrap = rancher2.bootstrap
    rancher2.admin     = rancher2.admin
  }
  rancher_domain = join(".", [var.domain.subdomain, var.domain.domain])
}