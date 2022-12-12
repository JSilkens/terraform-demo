variable "namespace" {
  type = string
}

variable "ssh_keypair" {
  type = string
}

variable "vpc" {
  type = any
}

variable "sg" {
  type = any
}

variable "db_config" {
  type = object ( # Enforces a strict type schema for the db_config object. The value set for this variable must implement the same type schema
    {
        user = string
        password = string
        database = string
        hostname = string 
        port = string
    }
  )
}