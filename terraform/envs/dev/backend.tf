terraform {
  backend "s3" {
    bucket         = "my-tf-state-bucket-test"
    key            = "dev/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "my-tf-lock-table1"
    encrypt        = true
  }
}
