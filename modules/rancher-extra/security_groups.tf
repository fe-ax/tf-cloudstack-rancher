resource "cloudstack_security_group" "extra_cluster_SG" {
  name        = "${var.prefix}-extra-cluster-SG"
  description = "SG ${var.prefix} extra cluster"
}

resource "cloudstack_security_group_rule" "extra_cluster_SG_Home_Ruleset" {
  security_group_id = cloudstack_security_group.extra_cluster_SG.id

  rule {
    cidr_list = var.home_ips
    protocol  = "tcp"
    ports     = ["22", "6443", "443", "80", "30000-32767"]
  }
}

resource "cloudstack_security_group_rule" "extra_cluster_SG_ICMP_Ruleset" {
  security_group_id = cloudstack_security_group.extra_cluster_SG.id

  rule {
    cidr_list = ["0.0.0.0/0"]
    protocol  = "icmp"
    icmp_code = -1
    icmp_type = -1
  }
}

resource "cloudstack_security_group_rule" "extra_cluster_SG_RKEs_Ruleset" {
  security_group_id = cloudstack_security_group.extra_cluster_SG.id

  rule {
    cidr_list = [for ip in var.local_cluster_ips : format("%s/32", ip)]
    protocol  = "tcp"
    ports     = ["2379", "2380", "10250", "6443", "22", "443"]
  }

  rule {
    cidr_list = [for ip in var.local_cluster_ips : format("%s/32", ip)]
    protocol  = "udp"
    ports     = ["8472"]
  }

  rule {
    cidr_list = [for s in concat(cloudstack_instance.extra_cluster_nodes_cps, cloudstack_instance.extra_cluster_nodes_workers) : format("%s/32", s.ip_address)]
    protocol  = "tcp"
    ports     = ["2379", "2380", "10250", "6443", "22", "443", "3366", "3367", "3370", "7000-7999"]
    #ports = ["1-65535"]
  }

  rule {
    cidr_list = [for s in concat(cloudstack_instance.extra_cluster_nodes_cps, cloudstack_instance.extra_cluster_nodes_workers) : format("%s/32", s.ip_address)]
    protocol  = "udp"
    ports     = ["8472"]
    #ports = ["1-65535"]
  }
}

resource "cloudstack_security_group_rule" "local_cluster_SG_RKEs_Ruleset" {
  security_group_id = var.local_cluster_sg_id

  rule {
    cidr_list = [for s in concat(cloudstack_instance.extra_cluster_nodes_cps, cloudstack_instance.extra_cluster_nodes_workers) : format("%s/32", s.ip_address)]
    protocol  = "tcp"
    ports     = ["2379", "2380", "10250", "6443", "22", "443"]
  }

  rule {
    cidr_list = [for s in concat(cloudstack_instance.extra_cluster_nodes_cps, cloudstack_instance.extra_cluster_nodes_workers) : format("%s/32", s.ip_address)]
    protocol  = "udp"
    ports     = ["8472"]
  }
}