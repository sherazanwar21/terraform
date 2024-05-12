variable "ami_id" {
  description = "variable for amazon linux 2 ami id"
  type        = string
  default     = "ami-0ddda618e961f2270"
}

variable "az" {
  description = "variable for availability zone for instance "
  type        = string
  default     = "us-east-2c"
}

variable "key" {
  description = "variable for instance keyy"
  type        = string
  default     = "newkey"
}

variable "itype" {
  description = "variable for instance type"
  type        = string
  default     = "t2.micro"
}

variable "ec2name" {
  description = "variable for instance name"
  type        = string
  default     = "tfvm1"
}

variable "user1" {
  description = "variable for username"
  type        = string
  default     = "atlasuser"
}

variable "user2" {
  description = "variable for username2"
  type        = string
  default     = "atlasuser2"
}

