resource "aws_elasticache_subnet_group" "main" {
  name       = "${local.name_prefix}-subnet-group"
  subnet_ids = var.subnet_ids
  tags = merge(local.tags, {Name = "${local.name_prefix}-subnet-group" })
}
resource "aws_security_group" "main" {
  name        = "${local.name_prefix}-sg"
  description = "${local.name_prefix}-sg"
  vpc_id      = var.vpc_id
  tags = merge(local.tags, {Name = "${local.name_prefix}-sg" })

  ingress {
    description      = "Elastic cache"
    from_port        = var.port
    to_port          = var.port
    protocol         = "tcp"
    cidr_blocks      = var.sg_ingress_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}
resource "aws_docdb_cluster_parameter_group" "main" {
  family      = var.engine_family
  name        = "${local.name_prefix}-pg"
  description = "${local.name_prefix}-gg"
  tags = merge(local.tags, {Name = "${local.name_prefix}-pg" })

}
resource "aws_elasticache_cluster" "example" {
  cluster_id           = "${local.name_prefix}-elasticcahe"
  engine               = var.engine
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = aws_docdb_cluster_parameter_group.main.name
  engine_version       = var.engine_version
  port                 = var.port
  db_subnet_group_name             = aws_elasticache_subnet_group.main.name
  vpc_security_group_ids           = [aws_security_group.main.id]
}