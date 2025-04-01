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
  type        = string
  default     = "state-file-all-env"
  description = "bucket for store the infra state files"
}

# Versioning Configuration 
variable "status" {
  type        = string
  default     = "Enabled"
  description = "Versioning type"
}

# variable "visibility" {
#   type        = string
#   default     = "private"
#   description = "visibility of the content"
# }

# variable "visibility_for_report" {
#   type = string
#   default = "public"
#   description = "visibility of the report content"
# }