variable "cidr_block" {}
variable "azs" { type = list(string) }

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
}

output "vpc_id" {
  value = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index + 2)
  availability_zone = element(var.azs, count.index)
}