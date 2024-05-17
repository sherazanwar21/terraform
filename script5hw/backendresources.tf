resource "aws_s3_bucket" "s3" {
  bucket = "backends3bucket"
}

resource "aws_s3_bucket_versioning" "s3versioning" {
  bucket = aws_s3_bucket.s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3encrypt" {
  bucket = aws_s3_bucket.s3.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.kmskey.key_id
    }
  }
  depends_on = [aws_kms_key.kmskey]
}

resource "aws_kms_key" "kmskey" {
  description = "kms key for s3 bucket"
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}