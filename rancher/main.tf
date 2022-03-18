terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
      version = "1.22.2"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.4.1"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "../rke/kubeconfig.yaml"
  }
}

data "terraform_remote_state" "rke" {
  backend = "local" 
  config = {
    path    = "../rke/terraform.tfstate"
  }
}
