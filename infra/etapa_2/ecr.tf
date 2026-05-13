resource "aws_ecr_repository" "backend" {
  name                 = "devops-u2-backend"
  force_delete         = true
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "frontend" {
  name                 = "devops-u2-frontend"
  force_delete         = true
  image_tag_mutability = "MUTABLE"
}