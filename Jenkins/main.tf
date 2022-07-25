provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project   = "Hillel"
      Lesson    = "27"
      Terraform = "True"
    }
  }
}

resource "aws_ecr_repository" "main" {
  name                 = "jenkins-repository"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository_policy" "main-repo-policy" {
  repository = aws_ecr_repository.main.name
  policy     = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "adds full ecr access to the demo repository",
        "Effect": "Allow",
        "Principal": "arn:aws:iam::554278834118:user/YakovA",
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      }
    ]
  }
  EOF
}

output "url_ecr" {
    value = aws_ecr_repository.main.repository_url
  
}