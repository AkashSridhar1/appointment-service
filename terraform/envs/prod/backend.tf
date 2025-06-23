terraform {
  backend "s3" {
    bucket         = "my-tf-state-bucket-test-20250617"
    key            = "prod/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "my-tf-lock-table1-20250617"
    encrypt        = true
  }
}
