output "vpc" {
  value = module.vpc # Passes a reference to the entire vpc module as an output
}

output "sg" { # Constructs a new object containing the ID for each of the three securiry groups
  value = {
    lb = module.lb_sg.security_group.id
    db = module.db_sg.security_group.id
    websrv = module.websrv_sg.security_group.id
  }
}