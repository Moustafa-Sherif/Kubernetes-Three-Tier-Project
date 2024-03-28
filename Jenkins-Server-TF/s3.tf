resource "aws_s3_bucket" "terraform_state"{
  bucket = "devops-terraform-statefile-bucket-us-east-1"

  # Prevent accidental deletion of this S3 bucket
  /*lifecycle {
    prevent_destroy = true
  }*/
}

/*
aws_s3_bucket_versioning resource to enable
versioning on the S3 bucket so that every update to a file in the bucket
actually creates a new version of that file. This allows you to see older
versions of the file and revert to those older versions at any time
*/

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }

}


/*
aws_s3_bucket_server_side_encryption_configuration
resource to turn server-side encryption on by default for all data written to
this S3 bucket. This ensures that the state files, and any secrets they might
contain, are always encrypted on disk when stored in S3
*/

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

/*
aws_s3_bucket_public_access_block resource to
block all public access to the S3 bucket.
*/

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets  = true

}

/*
DynamoDB table to use for locking. DynamoDB
is Amazon’s distributed key-value store. It supports strongly consistent
reads and conditional writes, which are all the ingredients you need for a
distributed lock system.
*/

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "Lock-Files"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}