terraform {
  required_providers {
    cloudstack = {
      source = "cloudstack/cloudstack"
      version = "0.4.0"
    }
  }
}

provider "cloudstack" {
  api_url    = local.api_creds.api_url
  api_key    = local.api_creds.api_key
  secret_key = local.api_creds.secret_key
}

resource "cloudstack_ssh_keypair" "thuiskey" {
  name       = "thuiskey"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

output "ip_addresses" {
  value = {
    "local_nodes" = cloudstack_instance.local_nodes[*].ip_address,
    "shared_controlplanes" = cloudstack_instance.shared_controlplanes[*].ip_address,
    "shared_workers" = cloudstack_instance.shared_workers[*].ip_address
  }
}

