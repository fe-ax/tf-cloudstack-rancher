resource "cloudstack_security_group" "Default_SG" {
  name        = "${var.prefix}-default-SG"
  description = "SG for ${var.prefix} local rancher cluster"
}

resource "cloudstack_security_group_rule" "Default_SG_Home_Ruleset" {
  security_group_id = cloudstack_security_group.Default_SG.id

  rule {
    cidr_list = var.home_ips
    protocol  = "tcp"
    ports     = ["22", "6443", "443", "80", "30000-32767"]
  }
}

resource "cloudstack_security_group_rule" "Default_SG_ICMP_Ruleset" {
  security_group_id = cloudstack_security_group.Default_SG.id

  rule {
    cidr_list = ["0.0.0.0/0"]
    protocol  = "icmp"
    icmp_code = -1
    icmp_type = -1
  }
}

resource "cloudstack_security_group_rule" "Default_SG_RKEs_Ruleset" {
  security_group_id = cloudstack_security_group.Default_SG.id

  rule {
    cidr_list = [for s in cloudstack_instance.local_nodes : format("%s/32", s.ip_address)]
    protocol  = "tcp"
    ports     = ["2379", "2380", "10250", "6443", "22", "443"]
  }

  rule {
    cidr_list = [for s in cloudstack_instance.local_nodes : format("%s/32", s.ip_address)]
    protocol  = "udp"
    ports     = ["8472"]
  }
}