variable "aws_region" {
  description = "Región de AWS"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI de Ubuntu 22.04 LTS"
  default     = "ami-0c7217cdde317cfec"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  default     = "t2.micro"
}