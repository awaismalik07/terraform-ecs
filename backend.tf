terraform {
  backend "s3" {
    bucket = "awais-terraform-state-bucket"
    key = "global/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "awais-terraform-state-table"
    encrypt = true    
  }
}