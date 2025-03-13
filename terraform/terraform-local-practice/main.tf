provider "local" {

}

provider "random" {

}

resource "local_file" "exae" {
    file_name = "pets.txt"
    file_content = "Hi, there! \nMy favorite pet is ${random_pet.pet_name.id}."
    file_permission=0700

#
#    lifecycle {
#        create_before_destroy = true
#        prevent_destroy = true
#        ignore_changes = [
#            content
#        ]
#    }

}

resource "random_pet" "pet_name" {
    pet_name_prefix = 
    pet_name_length = 2 // number of pet to generate
    separator = ", "
}

