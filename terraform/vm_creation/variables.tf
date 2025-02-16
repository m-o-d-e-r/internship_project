variable "vm_name" {
  type = string
}
variable "vm_memory" {
  type    = string
  default = "2048"
}
variable "vm_vcpu" {
  type    = number
  default = 2
}
variable "vm_os_image_name" {
  type = string
}
variable "vm_os_image_format" {
  type = string
}

variable "auth_public_key" {
  type = string
}
