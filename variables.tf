variable "allowed_read_principals" {
  description = "allowed_read_principals defines which external principals are allowed to read from the ECR repository"
  type        = "list"
}

variable "allowed_write_principals" {
  description = "allowed_write_principals defines which external principals are allowed to write to the ECR repository"
  type        = "list"
  default     = []
}

variable "ecr_repo_name" {
  type        = "string"
  description = "The name of the repository"
}

variable "enable_ecr_lifecycle" {
  description = "Set to false to prevent the module from creating a ECR lifecycle policy"
  default     = true
}

variable "max_images" {
  description = "The maximum number of images the repository should contain"
  default     = 100
}

variable "tags" {
  type        = "map"
  description = "A map of tags to add to all resources"
  default     = {}
}
