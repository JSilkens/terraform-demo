resource "randon_password" "password" { # Uses the random provider to create a 16-character password
  length = 16
  special = true
  #verride_special "_%@/'\""
}

resource "aws_db_instance" "database" {
  allocated_storage = 10
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t2.micro"
  identifier = "${var.namespace}-db-instance"
  name = "pets"
  username = "admin"
  password = randon_password.password.result

  db_subnet_group_name = var.vpc.database_subnet_group # These values came from the networking module
  vpc_security_group_ids = [var.sg.db] # These values came from the networking module
  skip_final_snapshot = true
}