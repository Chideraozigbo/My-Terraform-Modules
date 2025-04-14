output "bucket_id" {
  description = "Map of bucket names to bucket IDs"
  value       = aws_s3_bucket.bucket.id
}

output "bucket_arn" {
  description = "Map of bucket names to bucket ARNs"
  value       = aws_s3_bucket.bucket.arn
}