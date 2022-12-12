module "autoschaling" {
  source = "./autoschaling" # Nested child modules are sourced from a local modules directory
  namespace = var.namespace # Each module uses var.namespace for resource naming
}

module "database" {
  source = "./database"
  namespace = var.namespace

  vpc = module.networking.vpc # Data bubbles up from the networking module and tricles down into the database module
  sg = module.networking.sg
}

module "networking" {
  souce = "./networking"
  namespace = var.namespace
}