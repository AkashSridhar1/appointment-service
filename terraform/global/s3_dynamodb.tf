resource "aws_s3_bucket" "tf_state" {
  bucket = "my-tf-state-bucket"
  versioning { enabled = true }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "my-tf-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}