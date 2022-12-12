module "autoschaling" {
  source = "./autoschaling" # Nested child modules are sourced from a local modules directory
  namespace = var.namespace # Each module uses var.namespace for resource naming
  ssh_keypair = var.ssh_keypair

  vpc = module.networking.vpc # input arguments for the autoschaling module, set by other module's outputs
  sg = module.networking.sg
  db_config = module.database.db_config
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