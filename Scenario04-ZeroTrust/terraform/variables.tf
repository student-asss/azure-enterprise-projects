variable "location" {
  type    = string
  default = "westeurope"
}

variable "sql_admin_login" {
  type    = string
  default = "sqladminuser"
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
}

variable "rg_name" {
  type    = string
  default = "rg-s04-zero-trust"
}
