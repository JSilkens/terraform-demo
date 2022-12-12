variable "namespace" {
  type = string
}

variable "vpc" {
  type = any # A type constraint of “any” type means Terraform will skip type checking.
}

variable "sg" {
  type = any
}