terraform {
  backend "s3" {
    bucket         = "my-tf-state-bucket"     # <-- change
    key            = "demo/dev/terraform.tfstate"
    region         = "us-east-1"              # <-- change if needed
    dynamodb_table = "my-tf-locks"            # <-- change
    encrypt        = true
  }

  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
