
variable "vm_ami" {
  type    = string
  default = "ami-0b45ae66668865cd6" # Amazon Linux
}

variable "api_public_key" {
  type = string
}

variable "web_public_key" {
  type = string
}

variable "sftp_public_key" {
  type = string
}
