variable "region" {
  type = string
  default = "eu-west-2"
}

variable "name" {
  type = string
  default = "wordpress"
}

variable "ssh_access_ip" {
  type = string
  default = "109.105.90.107/32"
}

variable "az" {
  type    = list(string)
  default = ["a", "b"]
} 

variable "subnet_cidr" {
  type    = list(string)
  default = ["10.2.1.0/24", "10.2.2.0/24"]
} 
