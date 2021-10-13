resource "local_file" "mine" {
  filename        = var.filename
  content         = var.content
  file_permission = var.file_permission
}
 