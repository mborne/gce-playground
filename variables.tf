variable "project_id" {
  type     = string
  nullable = false
}

variable "region_name" {
  type    = string
  default = "us-west1"
}

variable "zone_name" {
  type    = string
  default = "us-west1-a"
}
