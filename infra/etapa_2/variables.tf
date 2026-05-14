variable "aws_region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "devops-u2-cluster"
}

variable "service_name" {
  default = "app"
}


variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "Nombre de tu Key Pair de AWS"
  default     = "vkey" 
}