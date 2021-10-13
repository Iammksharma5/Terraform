resource "local_file" "pet" {	
      filename = var.filename
      content = "My Favourite pet is ${random_pet.my-pet.id}"
      file_permission = var.file_permission
}

resource "random_pet" "my-pet" {
      prefix = var.prefix
      separator = var.separator
      length = var.length

}