
resource "rancher2_cluster" "extra_cluster" {
  provider    = rancher2.admin
  name        = "extra-cluster"
  description = "Terraform extra-cluster"
  rke_config {
    network {
      plugin = "canal"
    }
    services {
      etcd {
        creation  = "6h"
        retention = "24h"
      }
      kube_api {
        audit_log {
          enabled = true
          configuration {
            max_age    = 5
            max_backup = 5
            max_size   = 100
            path       = "-"
            format     = "json"
            policy     = "apiVersion: audit.k8s.io/v1\nkind: Policy\nmetadata:\n  creationTimestamp: null\nomitStages:\n- RequestReceived\nrules:\n- level: RequestResponse\n  resources:\n  - resources:\n    - pods\n"
          }
        }
      }
    }
    upgrade_strategy {
      drain                  = true
      max_unavailable_worker = "20%"
    }
  }
}