output "db_config" { # All the data in db_config comes from select output of the aws_db_instance
  value = {
    user = aws_db_instance.database.username
    password = aws_db_instance.database.password
    database = aws_db_instance.database.name
    hostname = aws_db_instance.database.address
    port = aws_db_instance.database.port
  }
}