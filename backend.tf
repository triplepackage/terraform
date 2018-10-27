terraform {
  backend "s3" {
    bucket = "tf-rental-service-state-storage"
    key    = "terraform/rental-service/terraform.tfstate"
    region = "us-east-1"
  }
}
