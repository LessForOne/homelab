variable "xo_url" {
  type        = string
  description = "url xenorchestra"
}

variable "xo_user" {
  type        = string
  description = "username xo admin"
}

variable "xo_pass" {
  type        = string
  description = "password xo admin"
}


variable "vms" {
    type = map(object({
        ram = number
        cpu = number
        disk = number
    }))
}