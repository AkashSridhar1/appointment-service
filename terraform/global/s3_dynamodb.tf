resource "aws_s3_bucket" "tf_state1" {
  bucket = "my-tf-state-bucket-test-20250617"
}
resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state1.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "tf_lock1" {
  name         = "my-tf-lock-table1-20250617"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
