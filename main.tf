provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  s3_use_path_style           = false
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = "http://localhost:4566"
    apigatewayv2   = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    es             = "http://localhost:4566"
    elasticache    = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    rds            = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    route53        = "http://localhost:4566"
    s3             = "http://s3.localhost.localstack.cloud:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"
  }
}

variable "region" {
  default = "us-east-1"
}

resource "aws_s3_bucket" "this" {
  bucket = "meu-website" 
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html" 
  }

  error_document {
    key = "index.html"
  } 
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
  
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
  
}
 
 resource "aws_s3_bucket_acl" "this" {
  depends_on = [ 
    aws_s3_bucket_ownership_controls.this,
    aws_s3_bucket_public_access_block.this,
   ]

   bucket = aws_s3_bucket.this.id
   acl = "public-read"
   
 }

 resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = <<POLICY
  {
     "Id": "Policy",
     "Statement":[
     {
     "Action": [
     "s3:GetObject"
     ],
     "Effect": "Allow",
     "Resouce": "arn:aws:s3:::${aws_s3_bucket.this.bucket}/*",
     "Principal": {
      "AWS": [
         "*"
        ] 
      }
    }
  ]
 }
 POLICY
 }