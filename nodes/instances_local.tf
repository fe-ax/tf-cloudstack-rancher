resource "cloudstack_instance" "local_nodes" {
  count              = 3
  name               = "local-node${count.index + 1}"
  service_offering   = local.defaults.service_offering
  network_id         = local.defaults.network_id
  template           = local.defaults.template
  zone               = local.defaults.zone
  security_group_ids = [cloudstack_security_group.Default-SG.id, cloudstack_security_group.terratest-SG.id]
  keypair            = cloudstack_ssh_keypair.thuiskey.id
  expunge            = true
  root_disk_size     = 20
  group              = "local-nodes"

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
    host        = self.ip_address
  }
  
  provisioner "remote-exec" {
    inline  = ["curl https://releases.rancher.com/install-docker/20.10.sh | sh"]
  }
}