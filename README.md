# My Terraform Modules

This repository contains a collection of reusable Terraform modules for AWS infrastructure. Each module is designed to be modular, configurable, and follows AWS best practices.

## Table of Contents
- [VPC Module](#vpc-module)
- [Subnets Module](#subnets-module)
- [Security Module](#security-module)
- [EC2 Module](#ec2-module)
- [S3 Module](#s3-module)
- [Peering Module](#peering-module)

## VPC Module

The VPC module creates a Virtual Private Cloud with configurable networking components.

### Usage
```hcl
module "vpc" {
  source = "./modules/vpc"

  cidr_block           = "10.0.0.0/16"
  vpc_name            = "my-vpc"
  create_igw          = true
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy    = "default"
  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

### Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| cidr_block | CIDR block for the VPC | string | - | yes |
| vpc_name | Name of the VPC | string | - | yes |
| create_igw | Whether to create an Internet Gateway | bool | false | no |
| enable_dns_support | Whether to enable DNS support | bool | true | no |
| enable_dns_hostnames | Whether to enable DNS hostnames | bool | true | no |
| instance_tenancy | The allowed tenancy of instances launched into the VPC | string | "default" | no |
| tags | Tags to apply to all resources | map(string) | {} | no |

### Outputs
| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| vpc_name | The name of the VPC |
| public_route_table_id | The ID of the public route table |
| private_route_table_id | The ID of the private route table |
| internet_gateway_id | The ID of the Internet Gateway |

## Subnets Module

The Subnets module creates public and private subnets within a VPC.

### Usage
```hcl
module "subnets" {
  source = "./modules/subnets"

  vpc_id              = module.vpc.vpc_id
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones  = ["us-east-1a", "us-east-1b"]
  tags = {
    Environment = "production"
  }
}
```

### Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vpc_id | ID of the VPC | string | - | yes |
| public_subnet_cidrs | List of CIDR blocks for public subnets | list(string) | - | yes |
| private_subnet_cidrs | List of CIDR blocks for private subnets | list(string) | - | yes |
| availability_zones | List of availability zones | list(string) | - | yes |
| tags | Tags to apply to all resources | map(string) | {} | no |

### Outputs
| Name | Description |
|------|-------------|
| public_subnet_ids | List of public subnet IDs |
| private_subnet_ids | List of private subnet IDs |

## Security Module

The Security module creates security groups and IAM roles for your infrastructure.

### Usage
```hcl
module "security" {
  source = "./modules/security"

  vpc_id = module.vpc.vpc_id
  security_group_rules = [
    {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  iam_role_name = "my-role"
  tags = {
    Environment = "production"
  }
}
```

### Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vpc_id | ID of the VPC | string | - | yes |
| security_group_rules | List of security group rules | list(map(string)) | - | yes |
| iam_role_name | Name of the IAM role | string | - | yes |
| tags | Tags to apply to all resources | map(string) | {} | no |

### Outputs
| Name | Description |
|------|-------------|
| security_group_id | ID of the security group |
| iam_role_arn | ARN of the IAM role |

## EC2 Module

The EC2 module creates EC2 instances with configurable parameters.

### Usage
```hcl
module "ec2" {
  source = "./modules/ec2"

  ami_id          = "ami-12345678"
  instance_type   = "t2.micro"
  subnet_id       = module.subnets.public_subnet_ids[0]
  security_groups = [module.security.security_group_id]
  key_name        = "my-key"
  tags = {
    Environment = "production"
  }
}
```

### Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| ami_id | ID of the AMI to use | string | - | yes |
| instance_type | Type of EC2 instance | string | - | yes |
| subnet_id | ID of the subnet | string | - | yes |
| security_groups | List of security group IDs | list(string) | - | yes |
| key_name | Name of the key pair | string | - | yes |
| tags | Tags to apply to all resources | map(string) | {} | no |

### Outputs
| Name | Description |
|------|-------------|
| instance_id | ID of the EC2 instance |
| public_ip | Public IP address of the instance |
| private_ip | Private IP address of the instance |

## S3 Module

The S3 module creates S3 buckets with configurable settings.

### Usage
```hcl
module "s3" {
  source = "./modules/s3"

  bucket_name = "my-bucket"
  acl         = "private"
  versioning  = true
  tags = {
    Environment = "production"
  }
}
```

### Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| bucket_name | Name of the S3 bucket | string | - | yes |
| acl | Access control list for the bucket | string | "private" | no |
| versioning | Whether to enable versioning | bool | false | no |
| tags | Tags to apply to all resources | map(string) | {} | no |

### Outputs
| Name | Description |
|------|-------------|
| bucket_id | ID of the S3 bucket |
| bucket_arn | ARN of the S3 bucket |

## Peering Module

The Peering module creates VPC peering connections between VPCs.

### Usage
```hcl
module "peering" {
  source = "./modules/peering"

  requester_vpc_id = module.vpc.vpc_id
  accepter_vpc_id  = "vpc-12345678"
  auto_accept      = true
  tags = {
    Environment = "production"
  }
}
```

### Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| requester_vpc_id | ID of the requester VPC | string | - | yes |
| accepter_vpc_id | ID of the accepter VPC | string | - | yes |
| auto_accept | Whether to automatically accept the peering connection | bool | false | no |
| tags | Tags to apply to all resources | map(string) | {} | no |

### Outputs
| Name | Description |
|------|-------------|
| peering_connection_id | ID of the VPC peering connection |
| peering_connection_status | Status of the VPC peering connection |

## Contributing

Feel free to contribute to this project by submitting issues or pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.