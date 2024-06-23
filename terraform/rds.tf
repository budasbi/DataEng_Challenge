resource "aws_db_instance" "default" {
  allocated_storage   = 20
  storage_type        = "gp2"
  engine              = "postgres"
  instance_class      = "db.t3.micro"
  db_name             = var.DATABASE
  identifier          = "datachallenge"
  engine_version      = 16.3
  username            = var.DATABASE_USER
  password            = var.DATABASE_PASSWORD
  publicly_accessible = true
  //Network Config
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.my_db_subnet_group.name
  // Maintenance
  skip_final_snapshot = true

  tags = {
    Name = var.default_tag
  }
}

output "database_endpoint" {
  value = aws_db_instance.default.endpoint

}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id, aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]
  tags = {
    Name = var.default_tag
  }
}