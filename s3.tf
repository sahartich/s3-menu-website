resource "aws_s3_bucket" "main" {
  bucket = "menu.tichover.tech"
  tags = {
    Name        = "static website"
    Environment = "Web-${terraform.workspace}" # just for funsies
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  rotation_period_in_days = 90

  tags = {
    name = "Web-Menu-Key"
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.restrict-ip.json
  lifecycle {
    ignore_changes = [policy]
  }
}

resource "aws_s3_object" "index" {
  key          = "index.html"
  bucket       = aws_s3_bucket.main.id
  source       = "website/index.html"
  content_type = "text/html"

  tags = {
    Env = "Web-${terraform.workspace}"
  }
}

resource "aws_s3_bucket_website_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  index_document {
    suffix = aws_s3_object.index.key
  }
}

resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "main" { # not specifying anything will allow public access by default
  bucket = aws_s3_bucket.main.id
}