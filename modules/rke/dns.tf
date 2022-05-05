data "transip_domain" "rancher_domain" {
  name = var.domain.domain
}

resource "transip_dns_record" "rancher" {
  domain = data.transip_domain.rancher_domain.id
  name   = var.domain.subdomain
  type   = "A"
  expire = 300

  content = var.rke_cluster_ips
}
