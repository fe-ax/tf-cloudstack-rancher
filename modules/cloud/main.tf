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
  }
}

resource "cloudstack_ssh_keypair" "local_rke_key" {
  name       = "${var.prefix}-local-rke-key"
  public_key = file("${var.prefix}_local_rke_key_rsa.pub")
}

output "ip_addresses" {
  value = cloudstack_instance.local_nodes[*].ip_address
}

output "sg_id" {
  value = cloudstack_security_group.Default_SG.id
}