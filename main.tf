####################################################
# Create two VPC and components
####################################################

module "vpc_a" {
  source               = "./modules/vpc"
  name                 = "VPC-A"
  aws_region           = var.aws_region
  vpc_cidr_block       = var.vpc_cidr_block_a #"10.1.0.0/16"
  public_subnets_cidrs = [cidrsubnet(var.vpc_cidr_block_a, 8, 1)]
  enable_dns_hostnames = var.enable_dns_hostnames
  aws_azs              = var.aws_azs
  common_tags          = local.common_tags
  naming_prefix        = local.naming_prefix
}


module "vpc_b" {
  source               = "./modules/vpc"
  name                 = "VPC-B"
  aws_region           = var.aws_region
  vpc_cidr_block       = var.vpc_cidr_block_b #"10.2.0.0/16"
  public_subnets_cidrs = [cidrsubnet(var.vpc_cidr_block_b, 8, 1)]
  enable_dns_hostnames = var.enable_dns_hostnames
  aws_azs              = var.aws_azs
  common_tags          = local.common_tags
  naming_prefix        = local.naming_prefix
}


####################################################
# Create EC2 Server Instances
####################################################

module "vpc_a_public_host" {
  source        = "./modules/web"
  instance_type = var.instance_type
  instance_key  = var.instance_key
  subnet_id     = module.vpc_a.public_subnets[0]
  vpc_id        = module.vpc_a.vpc_id
  ec2_name      = "Public Host A"
  common_tags   = local.common_tags
  naming_prefix = local.naming_prefix
}

module "vpc_b_public_host" {
  source        = "./modules/web"
  instance_type = var.instance_type
  instance_key  = var.instance_key
  subnet_id     = module.vpc_b.public_subnets[0]
  vpc_id        = module.vpc_b.vpc_id
  ec2_name      = "Public Host B"
  common_tags   = local.common_tags
  naming_prefix = local.naming_prefix
}

####################################################
# Create VPC Peering Connection
####################################################
resource "aws_vpc_peering_connection" "vpc_to_vpc" {
  vpc_id      = module.vpc_a.vpc_id
  peer_vpc_id = module.vpc_b.vpc_id
  auto_accept = true
  tags = merge(local.common_tags, {
    Name = "${local.naming_prefix}-vpc-peering"
  })
}

resource "aws_route" "peering_routes_a" {
  route_table_id            = module.vpc_a.public_route_table_id
  destination_cidr_block    = var.vpc_cidr_block_b
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_to_vpc.id
}

resource "aws_route" "peering_routes_b" {
  route_table_id            = module.vpc_b.public_route_table_id
  destination_cidr_block    = var.vpc_cidr_block_a
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_to_vpc.id
}
