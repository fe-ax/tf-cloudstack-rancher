terraform {
  required_providers {
    rke = {
      source = "my.local/marco/rke"
      version = "1.3.1"
    }
    local = {
      source = "hashicorp/local"
      version = "2.2.2"
    }
  }
}

provider "rke" {
  debug = true
  log_file = "rke_debug.log"
}

data "terraform_remote_state" "nodes" {
  backend = "local" 
  config = {
    path    = "../nodes/terraform.tfstate"
  }
}

resource "rke_cluster" "cluster_local" {
  kubernetes_version  = "v1.21.9-rancher1-1" # needs custom provider, recompile RKE with go.mod RKE 1.3.7
  # use for_each
  nodes {
    address = data.terraform_remote_state.nodes.outputs.ip_addresses.local_nodes[0]
    user    = "root"
    role    = ["controlplane", "worker", "etcd"]
    ssh_key = file("~/.ssh/id_rsa")
  }
  nodes {
    address = data.terraform_remote_state.nodes.outputs.ip_addresses.local_nodes[1]
    user    = "root"
    role    = ["controlplane", "worker", "etcd"]
    ssh_key = file("~/.ssh/id_rsa")
  }
  nodes {
    address = data.terraform_remote_state.nodes.outputs.ip_addresses.local_nodes[2]
    user    = "root"
    role    = ["controlplane", "worker", "etcd"]
    ssh_key = file("~/.ssh/id_rsa")
  }
}

resource "local_file" "kube_config_yaml" {
  content = rke_cluster.cluster_local.kube_config_yaml
  filename = "kubeconfig.yaml"
}