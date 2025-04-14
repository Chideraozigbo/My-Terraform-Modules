variable "bucket_name" {
  description = "List of bucket names to create"
  type        = string
}

variable "enable_versioning" {
  description = "Whether to enable versioning for all buckets"
  type        = bool
  default     = true
}

variable "bucket_tags" {
  description = "Map of bucket names to their tags"
  type        = map(map(string))
  default     = {}
}

variable "tags" {
  description = "Tags to apply to all buckets"
  type        = map(string)
  default     = {}
}
