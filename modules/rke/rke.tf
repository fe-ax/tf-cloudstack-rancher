variable "rke_cluster_ips" {
  type = list(string)
}

resource "rke_cluster" "cluster_local" {
  delay_on_creation = 10

  dynamic "nodes" {
    for_each = var.rke_cluster_ips
    content {
      address = nodes.value
      user    = "root"
      role    = ["controlplane", "worker", "etcd"]
      ssh_key = file("${var.prefix}_local_rke_key_rsa")
    }
  }
}

resource "local_sensitive_file" "kube_config_yaml" {
  content  = rke_cluster.cluster_local.kube_config_yaml
  filename = "kubeconfig.yaml"
}

resource "null_resource" "wait-for-rollout" {
  depends_on = [
    local_sensitive_file.kube_config_yaml,
    rke_cluster.cluster_local
  ]
  provisioner "local-exec" {
    command     = "/usr/local/bin/kubectl rollout status --kubeconfig=kubeconfig.yaml -n ingress-nginx daemonsets/nginx-ingress-controller"
    interpreter = ["/bin/sh", "-c"]
  }
}



