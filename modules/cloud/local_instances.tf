resource "cloudstack_instance" "local_nodes" {
  count              = var.cloud_local_cluster.count
  name               = "${var.prefix}-local-node${count.index + 1}"
  service_offering   = var.cloud_local_cluster.service_offering
  network_id         = var.cloud_local_cluster.network_id
  template           = var.cloud_local_cluster.template
  zone               = var.cloud_local_cluster.zone
  keypair            = cloudstack_ssh_keypair.local_rke_key.id
  expunge            = true
  security_group_ids = [cloudstack_security_group.Default_SG.id]
  root_disk_size     = var.cloud_local_cluster.root_disk_size
  user_data          = file("${path.module}/provision-docker.tftpl")

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("${var.prefix}_local_rke_key_rsa")
    host        = self.ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait > /dev/null"
    ]
  }

}
