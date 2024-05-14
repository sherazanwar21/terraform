variable "ami" {
  description = "ami of the instance"
  type        = string
  default     = "ami-09040d770ffe2224f"
}

variable "AZ" {
  description = "availability zone for instance"
  type        = string
  default     = "us-east-2c"
}


variable "itype" {
  description = "instance type"
  type        = string
  default     = "t2.micro"
}

variable "ec2name" {
  description = "name of instance"
  type        = string
  default     = "atlasec2tf"
}
