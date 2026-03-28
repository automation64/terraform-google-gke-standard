resource "google_service_account" "main" {
  project = var.shared__project_id

  account_id                   = local.google_service_account.account_id
  display_name                 = local.google_service_account.description
  disabled                     = local.google_service_account.disabled
  create_ignore_already_exists = local.google_service_account.create_ignore_already_exists
}

resource "google_project_iam_member" "main" {
  for_each = local.google_project_iam_member__roles
  project  = var.shared__project_id
  role     = each.key
  member   = google_service_account.main.member
}
