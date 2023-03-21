# terraform config file
terraform {

  required_version = "1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.57.0"
    }
  }

}
