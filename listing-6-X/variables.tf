variable "namespace" {
  description = "The project namepace tho us"
}

variable "principal_arns" {
  description = "A list of prinipal arns allowed to assume the IAM role"
  default = null
  type = list(string)
}

variable "force_destroy_state" {
  description = "Force destroy the S3 bucket containing state files"
  default = true
  type = bool
}