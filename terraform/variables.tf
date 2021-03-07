variable "azure_region" {
  type    = string
  default = "westus2"
}

variable "azure_rg_name" {
  type    = string
  default = "tf-honeypot"
}

variable "azure_sa_name" {
  type    = string
  default = "honeypot"
}

variable "azure_law_name" {
  type    = string
  default = "honeypot"
}

variable "azure_vm_username" {
  type    = string
  default = "Administrator"
}

variable "azure_vm_password" {
  type      = string
  sensitive = true
}

variable "azure_vms" {
  type = map(object({
    size        = string
    vm_hostname = string
    subnet      = string
  }))

  default = {
    exchange = {
      size        = "Standard_B2s"
      vm_hostname = "ex2016-01"
      subnet      = "10.0.99.0/24"
    }
  }
}