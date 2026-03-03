variable "location" {}
variable "admin_username" {}
variable "admin_password" {
  sensitive = true
}
variable "subnet_id" {}
variable "backend_pool_id" {}
