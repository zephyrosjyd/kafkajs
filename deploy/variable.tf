variable "do_ams2" {
  description = "Digital Ocean Amsterdam Data Center 2"
  default     = "ams2"
}

variable "do_ams3" {
  description = "Digital Ocean Amsterdam Data Center 3"
  default     = "ams3"
}

variable "do_fra1" {
  description = "Digital Ocean Frankfurt Data Center 1"
  default     = "fra1"
}

variable "do_lon1" {
  description = "Digital Ocean London Data Center 1"
  default     = "lon1"
}

# Default Os

variable "ubuntu" {
  description = "Default LTS"
  default     = "ubuntu-18-04-x64"
}

variable "centos" {
  description = "Default Centos"
  default     = "centos-72-x64"
}

variable "coreos" {
  description = "Default Coreos"
  default     = "coreos-stable"
}
