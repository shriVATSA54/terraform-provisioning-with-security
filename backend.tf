terraform {
  backend "s3" {
    bucket       = "terraform-state-54"
    key          = "training-terraform/terraform-3.0.state"
    region       = "ap-south-1"
    use_lockfile = true
  }
}
