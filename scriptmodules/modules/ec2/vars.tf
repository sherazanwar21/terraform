variable "ami" {
    description = "ami for instance"
    type = string
    default = "ami-09040d770ffe2224f"
}

variable "itype" {
    description = "type of instance"
    type = string
    default = "t2.micro"
}

variable "az" {
    description = "az for instance"
    type = string
    default = "us-east-2c"
}

variable "instancename" {
    description = "name for instance"
    type = string
    default = "instance1"
}