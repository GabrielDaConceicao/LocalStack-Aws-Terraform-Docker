output "website_url" {
    value = "https://${aws_s3_bucket.this.bucket}.s3-website.localhost.localstack.cloud:4566/"  
}