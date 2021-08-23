variable "account_id" {
    description "aws account id"
    type = "string"
}

variable "profile" {
    description = "aws profile to use (this is localstack, so use mock one)"
    default = "local-test"
    type = "string"
}

variable "region" {
    description "aws region"
    default = "eu-west-1"
    type = "string"
}

variable "is_nat_gw" {
    description = "indicates whether to deploy a nat gw"
    default = true
    type = bool
}

variable "is_internet_ge" {
    description = "whether to deploy a IGW in the VPC"
    default = true
    type = bool
}

variable "developer_users" {
    description = "list of developers users"
    type = list(string)
}

variable "admin_users" {
    description = "list of admin users"
    type = list(string)
}

variable "name_prefix" {
    description = "unique name prefix for cluster"
    type = "string"
    default = "test"
}

variable "cluster_version" {
    description = "the eks cluster version to use"
    type = "string"
    default = "1.19"
}

variable "instance_type" {
    description = "worker nodes instance type"
    type = "string"
    default = "m5.large"
}

variable "asg_desired_capacity" {
    description = "worker nodes asg desired capacity"
    type = "string"
    default = "3"
}

variable "asg_min_size" {
    description = "worker nodes asg minimum size"
    type = "string"
    default = "3"
}

variable "asg_max_size" {
    description = "worker nodes asg maximum size"
    type = "string"
    default = "9"
}

variable "domain" {
    description = "domain to use with external dns"
    type = "string"
}

// VPC

variable "region" {
  description = "The AWS region where the infraestructure will be located"
  default     = "eu-west-2"
  type        = string
}

variable "azs" {
  description = "The availability zones where the infraestructure will be located"
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  type        = list(string)
}

variable "vpc_cidr" {
  description = "The CIDR block for the cloud VPC"
  default     = "172.16.0.0/16"
  type        = string
}

variable "private_subnets_cidrs" {
  description = "The CIDRs of private subnets of the cloud VPC. The default values allow 4094 hosts per subnet"
  default     = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  type        = list(string)
}

variable "public_subnets_cidrs" {
  description = "The CIDRs of public subnets of the cloud VPC. The default values allow 4094 hosts per subnet"
  default     = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
  type        = list(string)
}
