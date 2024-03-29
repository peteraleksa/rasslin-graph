resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  name          = "${random_id.bucket_prefix.hex}-bucket-tfstate"
  force_destroy = false
  location      = var.region
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
# should set up at rest encryption for added security
#  encryption {
#    default_kms_key_name = google_kms_crypto_key.terraform_state_bucket.id
#  }
#  depends_on = [
#    google_project_iam_member.default
#  ]
}
