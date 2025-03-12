# ENVIRONMENT VARIABLE SECTION (dev,staging,prod)
variable "environment" {
  type        = string
  default     = "staging"
  nullable    = false
  description = "for all different environment"
}
# S3 BUCKET CREATION
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Region we are used to create bucket"
}


variable "bucket" {
  type = map(string)
  default = {
    "dev"     = "dev-bucket"
    "staging" = "staging-bucket"
    "prod"    = "prod-bucket"
  }
  description = "bucket for store the infra state files"
}

# Versioning Configuration 
variable "status" {
  type        = string
  default     = "Enabled"
  description = "Versioning type"
}

variable "visibility" {
  type        = string
  default     = "private"
  description = "visibility of the content"
}