resource "aws_s3_bucket" "buckets" {
  for_each = toset(var.bucket_names)
  
  bucket = each.key
  tags = merge(
    var.tags,
    {
      Name = var.bucket_names[each.key]
    }
  )
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  for_each = toset(var.bucket_names)
  
  bucket = aws_s3_bucket.buckets[each.key].id
  
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}