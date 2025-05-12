variable "ssh_public_key" {
  type        = string
  description = "The public SSH key to be used for the ec2 instance"
}

variable "access_key" {
    type = string
    sensitive = true
}

variable "secret_key" {
    type = string
    sensitive = true
}