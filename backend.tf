# This file is used to configure the backend for Terraform state management.
# It specifies that the state will be stored in an S3 bucket and uses DynamoDB for state locking.
# The backend configuration is set up for the staging environment.
# The S3 bucket is named "state-file-all-env-vnc" and the state file will be stored at "terraform/staging/terraform.tfstate".
# The DynamoDB table used for state locking is "terraform-lock-staging".
# The region for both the S3 bucket and DynamoDB table is set to "us-east-1".
# The state file is encrypted for security.
# The backend configuration is essential for managing the state of your Terraform infrastructure.
# It allows for collaboration and ensures that the state is consistent across different environments.


terraform {
  backend "s3" {
    bucket = "state-file-all-env-vnc"
    key    = "terraform/staging/terraform.tfstate"
    # dynamodb_table = "terraform-lock-staging"
    region  = "us-east-1"
    encrypt = true
  }
}

