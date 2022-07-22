
resource "cloudstack_instance" "extra_cluster_nodes_cps" {
  count              = var.cloud_extra_cluster.count_cp
  name               = "${var.prefix}-extra-cp${count.index + 1}"
  service_offering   = var.cloud_extra_cluster.service_offering
  network_id         = var.cloud_extra_cluster.network_id
  template           = var.cloud_extra_cluster.template
  zone               = var.cloud_extra_cluster.zone
  keypair            = cloudstack_ssh_keypair.extra_cluster_key.id
  expunge            = true
  security_group_ids = [cloudstack_security_group.extra_cluster_SG.id]
  root_disk_size     = var.cloud_extra_cluster.root_disk_size_cp
  user_data = templatefile(
    "${path.module}/provision-docker.tftpl", {
      node_command = rancher2_cluster.extra_cluster.cluster_registration_token[0].node_command,
      worker       = false,
      etcd         = true,
      controlplane = true
    }
  )

  lifecycle {
      ignore_changes = [
          user_data,
      ]
  }

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("${var.prefix}_extra_cluster_key_rsa")
    host        = self.ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait > /dev/null"
    ]
  }
}

resource "cloudstack_instance" "extra_cluster_nodes_workers" {
  depends_on = [
    cloudstack_instance.extra_cluster_nodes_cps
  ]

  count              = var.cloud_extra_cluster.count_worker
  name               = "${var.prefix}-extra-worker${count.index + 1}"
  service_offering   = var.cloud_extra_cluster.service_offering
  network_id         = var.cloud_extra_cluster.network_id
  template           = var.cloud_extra_cluster.template
  zone               = var.cloud_extra_cluster.zone
  keypair            = cloudstack_ssh_keypair.extra_cluster_key.id
  expunge            = true
  security_group_ids = [cloudstack_security_group.extra_cluster_SG.id]
  root_disk_size     = var.cloud_extra_cluster.root_disk_size_worker
  user_data = templatefile(
    "${path.module}/provision-docker.tftpl", {
      node_command = rancher2_cluster.extra_cluster.cluster_registration_token[0].node_command,
      worker       = true,
      etcd         = false,
      controlplane = false
    }
  )

  lifecycle {
      ignore_changes = [
          user_data,
      ]
  }

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("${var.prefix}_extra_cluster_key_rsa")
    host        = self.ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait > /dev/null"
    ]
  }
}
