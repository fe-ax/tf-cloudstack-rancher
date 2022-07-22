# Cloud provider
variable "cloudstack_provider" {
  type = object({
    api_url    = string
    api_key    = string
    secret_key = string
  })
  description = "The settings for the CloudStack provider"
}

variable "cloud_local_cluster" {
  type = object({
    count            = number
    service_offering = string
    network_id       = string
    template         = string
    zone             = string
    root_disk_size   = number
  })
  description = "The settings for local-cluster VM's in CloudStack"
}

variable "cloud_extra_cluster" {
  type = object({
    count_cp              = number
    count_worker          = number
    service_offering      = string
    network_id            = string
    template              = string
    zone                  = string
    root_disk_size_cp     = number
    root_disk_size_worker = number
    extra_disk_offering   = string
  })
  description = "The settings for extra-cluster VM's in CloudStack"
}

variable "domain" {
  type = object({
    domain    = string
    subdomain = string
  })
  description = "The domain information"
}

variable "transip" {
  type = object({
    account_name = string
    private_key  = string
  })
  description = "TransIP credentials"
}

variable "home_ips" {
  type        = list(string)
  description = "The home IP's"
}

variable "prefix" {
  type        = string
  description = "Global prefix"
}
