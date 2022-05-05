terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.2.2"
    }
    rancher2 = {
      source                = "rancher/rancher2"
      version               = "1.22.2"
      configuration_aliases = [rancher2.admin]
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
    cloudstack = {
      source  = "cloudstack/cloudstack"
      version = "0.4.0"
    }
  }
}

variable "local_cluster_ips" {
  type = list(string)
}

variable "local_cluster_sg_id" {
  type = string
}

resource "cloudstack_ssh_keypair" "extra_cluster_key" {
  name       = "${var.prefix}-extra-cluster-key"
  public_key = file("${var.prefix}_extra_cluster_key_rsa.pub")
}

output "ip_addresses_cp" {
  value = cloudstack_instance.extra_cluster_nodes_cps[*].ip_address
}

output "ip_addresses_worker" {
  value = cloudstack_instance.extra_cluster_nodes_workers[*].ip_address
}

