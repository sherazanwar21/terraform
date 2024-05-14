resource "aws_s3_bucket" "tfbucket1" {
  bucket = var.bucketname
}

resource "aws_s3_bucket_versioning" "tfbucket1version" {
  bucket = aws_s3_bucket.tfbucket1.id
  versioning_configuration {
    status = var.versstatus
  }
}

resource "aws_kms_key" "tfkmskey" {
  description = "This key is used to encrypt bucket objects"
  key_usage   = "ENCRYPT_DECRYPT"

  tags = {
    Name = var.keyname
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3encryption" {
  bucket = aws_s3_bucket.tfbucket1.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tfkmskey.id
      sse_algorithm     = "aws:kms"
    }
  }
}