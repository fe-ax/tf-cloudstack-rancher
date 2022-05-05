
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.2.2"
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
