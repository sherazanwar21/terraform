#bucket vars
variable "bucketname" {
  description = "s3 bucket name"
  type        = string
  default     = "sheraztf-state-bucket"
}

variable "versstatus" {
  description = "status of bucket versioning"
  type        = string
  default     = "Enabled"
}

#vpc vars
variable "vpccidr" {
  description = "cidr block for vpc"
  type        = string
  default     = "192.168.0.0/16"
}

variable "vpcname" {
  description = "name of vpc"
  type        = string
  default     = "tfvpc"
}

variable "pubcidr" {
  description = "public cidr"
  type        = string
  default     = "192.168.1.0/24"
}

variable "privcidr" {
  description = "private cidr"
  type        = string
  default     = "192.168.2.0/24"
}

variable "pubsubnetname" {
  description = "name of public subnet"
  type        = string
  default     = "tfpublicsubnet1"
}

variable "privsubnetname" {
  description = "name of private subnet"
  type        = string
  default     = "tfprivatesubnet1"
}

variable "igname" {
  description = "name of internet gateway"
  type        = string
  default     = "tfig1"
}

variable "pubroutecidr" {
  description = "where the public cidr can communicate to"
  type        = string
  default     = "0.0.0.0/0"
}

variable "publicroutetable" {
  description = "name of public route table"
  type        = string
  default     = "tfpubrt"
}

variable "ngname" {
  description = "name for nat gateway"
  type        = string
  default     = "tfngw"
}

variable "privateroutetable" {
  description = "name of private route table"
  type        = string
  default     = "tfprivrt"
}