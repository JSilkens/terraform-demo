terraform {
  required_version = ">= 0.15"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

variable "words" {
  description = "A word pool to use for Mad Libs"
  type = object({ # Any set value must be corcilbe into this complex type.
    nouns      = list(string),
    adjectives = list(string),
    verbs      = list(string),
    adverbs    = list(string),
    numbers    = list(string),
  })
}

variable "num_files" { #Declares an input variable for setting count on the random_shuffele resources
  default = 100
  type    = number
}


locals {
  uppercase_words = { for k, v in var.words : k => [for s in v : upper(s)] } # for expression to uppercase strings and save to a local value
}

resource "random_shuffle" "random_nouns" {
  count = var.num_files                  # References the num_files variable to dynamically set the count meta argument
  input = local.uppercase_words["nouns"] # A new shuffeled list is generated from the input list
}

resource "random_shuffle" "random_adjectives" {
  count = var.num_files
  input = local.uppercase_words["adjectives"]
}

resource "random_shuffle" "random_verbs" {
  count = var.num_files
  input = local.uppercase_words["verbs"]
}

resource "random_shuffle" "random_adverbs" {
  count = var.num_files
  input = local.uppercase_words["adverbs"]
}

resource "random_shuffle" "random_numbers" {
  count = var.num_files
  input = local.uppercase_words["numbers"]
}

output "mad_libs" {
  value = templatefile("${path.module}/alice.txt",
    {
      nouns      = random_shuffle.random_nouns.result
      adjectives = random_shuffle.random_adjectives.result
      verbs      = random_shuffle.random_verbs.result
      adverbs    = random_shuffle.random_adverbs.result
      numbers    = random_shuffle.random_numbers.result
  })
}