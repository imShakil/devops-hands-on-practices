variable "file_name" {
    description = "The name of the file to create"
    type = string
    default = "example.txt"
}

variable "file_content" {
    description = "The content of the file"
    type = string
    default = "Hello, terraform!"
}

variable "pet_name_prefix" {
    description = "The prefix of the random pet name"
    type = string
    default = "pet"
}

variable "pet_name_length" {
    description = "The size of random pet name generate"
    type = number
    default = 2 // minimum value
}

