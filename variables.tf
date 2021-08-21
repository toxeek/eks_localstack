variable "account_id" {
    description "aws account id"
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