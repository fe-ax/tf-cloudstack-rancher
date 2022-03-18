# First phase

resource "cloudstack_security_group" "Default-SG" {
  name        = "Default-SG"
  description = "Test SG for terraform tests"
}

resource "cloudstack_security_group_rule" "Default-SG-Home-Ruleset" {
  security_group_id = cloudstack_security_group.Default-SG.id

  rule {
    cidr_list = [format("%s/32", local.home_ip)]
    protocol  = "tcp"
    ports     = ["0-65535"]
  }
  rule {
    cidr_list = [format("%s/32", local.home_ip)]
    protocol  = "udp"
    ports     = ["0-65535"]
  }
}

resource "cloudstack_security_group_rule" "Default-SG-ICMP-Ruleset" {
  security_group_id = cloudstack_security_group.Default-SG.id

  rule {
    cidr_list = ["0.0.0.0/0"]
    protocol  = "icmp"
    icmp_code = -1
    icmp_type = -1
  }
}

# Second phase

resource "cloudstack_security_group" "terratest-SG" {
  name        = "TerraTest-SG"
  description = "Test SG for terraform tests"
}

locals {
  ip_addresses = concat(
    cloudstack_instance.local_nodes[*].ip_address,
    cloudstack_instance.shared_controlplanes[*].ip_address,
    cloudstack_instance.shared_workers[*].ip_address
  )
}

resource "cloudstack_security_group_rule" "TerraTest-SG-Between-Ruleset" {
  security_group_id = cloudstack_security_group.terratest-SG.id

  rule {
    cidr_list = [for s in local.ip_addresses : format("%s/32", s)]
    protocol  = "tcp"
    ports     = ["0-65535"]
  }

  rule {
    cidr_list = [for s in local.ip_addresses : format("%s/32", s)]
    protocol  = "udp"
    ports     = ["0-65535"]
  }

}