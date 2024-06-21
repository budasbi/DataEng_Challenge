resource "aws_db_instance" "default" {
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "postgres"
  instance_class    = "db.t3.micro"
  db_name           = "postg"
  identifier        = "datachallenge"
  engine_version    = 16.3
  username          = "postgres"
  password          = var.rds_password
  publicly_accessible = true
  //Network Config
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.my_db_subnet_group.name
  // Maintenance
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "mon:04:00-mon:04:30"
  //Enable Backups
  final_snapshot_identifier = "db-snap"
  skip_final_snapshot       = false
  tags = {
    Name = var.default_tag
  }
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.public_subnet_a.id, aws_subnet.private_subnet_b.id]
  tags = {
    Name = var.default_tag
  }
}