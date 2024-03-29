terraform {
  backend "gcs" {
    bucket = "f9849d27fafa2296-bucket-tfstate"
    prefix = "paleksa-portfolio"
  }
#  backend "local" {}
}
