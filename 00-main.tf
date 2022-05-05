terraform {
  required_providers {
    cloudstack = {
      source  = "cloudstack/cloudstack"
      version = "0.4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.2"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "1.22.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
    rke = {
      source  = "rancher/rke"
      version = "1.3.0"
    }
    transip = {
      source = "aequitas/transip"
    }
  }
}

output "rke_cluster_ips" {
  value = module.cloud.ip_addresses
}

output "extra_cluster_ips_cp" {
  value = module.rancher-extra.ip_addresses_cp
}

output "extra_cluster_ips_worker" {
  value = module.rancher-extra.ip_addresses_worker
}