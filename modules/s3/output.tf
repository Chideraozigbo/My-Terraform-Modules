output "bucket_ids" {
  description = "Map of bucket names to bucket IDs"
  value       = { for k, v in aws_s3_bucket.buckets : k => v.id }
}

output "bucket_arns" {
  description = "Map of bucket names to bucket ARNs"
  value       = { for k, v in aws_s3_bucket.buckets : k => v.arn }
}