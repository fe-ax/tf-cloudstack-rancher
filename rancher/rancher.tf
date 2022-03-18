resource "helm_release" "rancher" {
  name = "rancher"
  namespace = "cattle-system"
  chart = "rancher"
  repository = "https://releases.rancher.com/server-charts/latest"
  depends_on = [helm_release.cert_manager]

  wait             = true
  create_namespace = true
  force_update     = true
  replace          = true

  set {
    name  = "hostname"
    value = "rancher.debugdomain.com"
  }

  set {
    name  = "ingress.tls.source"
    value = "rancher"
  }
  
  set {
    name  = "bootstrapPassword"
    value = "A-Random-Password"
  }

  set {
    name  = "rancherImageTag"
    value = "v2.6.3-patch1"
  }
}

provider "rancher2" {
  alias = "bootstrap"

  api_url   = "https://rancher.debugdomain.com"
  insecure  = true
  bootstrap = true
}

# Create a new rancher2_bootstrap using bootstrap provider config
resource "rancher2_bootstrap" "admin" {
  provider = rancher2.bootstrap
  depends_on = [helm_release.rancher]
  initial_password = "A-Random-Password"
  # New password will be generated and saved in statefile
  telemetry = false
}

# Provider config for admin
provider "rancher2" {
  alias = "admin"

  api_url = rancher2_bootstrap.admin.url
  token_key = rancher2_bootstrap.admin.token
  insecure = true
}
