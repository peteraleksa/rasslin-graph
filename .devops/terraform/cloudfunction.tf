data "archive_file" "scrape_kayfabe_persona_links_source" {
  type        = "zip"
  source_dir  = "../../pipelines/ingest/serverless/google_cloud_functions/python/scrape_kayfabe_persona_links"
  output_path = "${path.module}/zips/scrape_kayfabe_persona_links_function.zip"
}

resource "google_storage_bucket_object" "scrape_kayfabe_persona_links_zip" {
  source       = data.archive_file.scrape_kayfabe_persona_links_source.output_path
  content_type = "application/zip"
  name         = "src-${data.archive_file.scrape_kayfabe_persona_links_source.output_md5}.zip"
  bucket       = google_storage_bucket.Cloud_function_bucket.name
  depends_on = [
    google_storage_bucket.Cloud_function_bucket,
    data.archive_file.scrape_kayfabe_persona_links_source
  ]
}

resource "google_cloudfunctions_function" "scrape_kayfabe_persona_links_function" {
  name                  = "scrape_kayfabe_persona_links_function_trigger"
  description           = "cloud function to scrape kayfabe persona links from cagematch.net"
  runtime               = "python39"
  project               = var.project_id
  region                = var.region
  source_archive_bucket = google_storage_bucket.Cloud_function_bucket.name
  source_archive_object = google_storage_bucket_object.scrape_kayfabe_persona_links_zip.name
  trigger_http          = true
  entry_point           = "get_persona_links_http"
  depends_on = [
    google_storage_bucket.Cloud_function_bucket,
    google_storage_bucket_object.scrape_kayfabe_persona_links_zip,
  ]
}

data "archive_file" "scrape_kayfabe_persona_source" {
  type        = "zip"
  source_dir  = "../../pipelines/ingest/serverless/google_cloud_functions/python/scrape_kayfabe_persona"
  output_path = "${path.module}/zips/scrape_kayfabe_persona_function.zip"
}

resource "google_storage_bucket_object" "scrape_kayfabe_persona_zip" {
  source       = data.archive_file.scrape_kayfabe_persona_source.output_path
  content_type = "application/zip"
  name         = "src-${data.archive_file.scrape_kayfabe_persona_source.output_md5}.zip"
  bucket       = google_storage_bucket.Cloud_function_bucket.name
  depends_on = [
    google_storage_bucket.Cloud_function_bucket,
    data.archive_file.scrape_kayfabe_persona_source
  ]
}

resource "google_cloudfunctions_function" "scrape_kayfabe_persona_function" {
  name                  = "scrape_kayfabe_persona_function_trigger"
  description           = "cloud function to scrape kayfabe persona from cagematch.net"
  runtime               = "python39"
  project               = var.project_id
  region                = var.region
  source_archive_bucket = google_storage_bucket.Cloud_function_bucket.name
  source_archive_object = google_storage_bucket_object.scrape_kayfabe_persona_zip.name
  trigger_http          = true
  entry_point           = "get_persona_http"
  depends_on = [
    google_storage_bucket.Cloud_function_bucket,
    google_storage_bucket_object.scrape_kayfabe_persona_zip,
  ]
}

data "archive_file" "scrape_promotion_source" {
  type        = "zip"
  source_dir  = "../../pipelines/ingest/serverless/google_cloud_functions/python/scrape_promotion"
  output_path = "${path.module}/zips/scrape_promotion_function.zip"
}

resource "google_storage_bucket_object" "scrape_promotion_zip" {
  source       = data.archive_file.scrape_promotion_source.output_path
  content_type = "application/zip"
  name         = "src-${data.archive_file.scrape_promotion_source.output_md5}.zip"
  bucket       = google_storage_bucket.Cloud_function_bucket.name
  depends_on = [
    google_storage_bucket.Cloud_function_bucket,
    data.archive_file.scrape_promotion_source
  ]
}

resource "google_cloudfunctions_function" "scrape_promotion_function" {
  name                  = "scrape_promotion_function_trigger"
  description           = "cloud function to scrape promotions from cagematch.net"
  runtime               = "python39"
  project               = var.project_id
  region                = var.region
  source_archive_bucket = google_storage_bucket.Cloud_function_bucket.name
  source_archive_object = google_storage_bucket_object.scrape_promotion_zip.name
  trigger_http          = true
  entry_point           = "get_promotion_http"
  depends_on = [
    google_storage_bucket.Cloud_function_bucket,
    google_storage_bucket_object.scrape_promotion_zip,
  ]
}
