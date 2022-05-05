resource "cloudstack_disk" "extradisk" {
  depends_on = [
    cloudstack_instance.extra_cluster_nodes_workers
  ]
  for_each           = { for vm in cloudstack_instance.extra_cluster_nodes_workers : vm.id => vm }
  name               = "${var.prefix}-extradisk-disk-${each.key}"
  attach             = "true"
  disk_offering      = var.cloud_extra_cluster.extra_disk_offering
  virtual_machine_id = each.value.id
  zone               = var.cloud_extra_cluster.zone
}