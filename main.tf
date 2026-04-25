provider "aws" {
  region = "us-west-1"
}


# create s3 bucket #
resource "aws_s3_bucket" "my_bucket" {
  bucket = "saga-cicd-bucket-22"

}


# enable website hosting #
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.my_bucket.id
  
  index_document {
    suffix = "index.html"
  }
}


# allow public acces #
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.my_bucket.id
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}


# add bucket policy #
resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.my_bucket.id

depends_on = [ 
    aws_s3_bucket_public_access_block.public_accessgit 
 ]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = "*"
      Action = "s3:GetObject"
      Resource = "${aws_s3_bucket.my_bucket.arn}/*"
    }]
  })
}


# uploed object #
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.my_bucket.id
  key = "index.html"
  source = "index.html"
    content_type = "text/html"
    etag = filemd5("index.html")

}