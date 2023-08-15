
variable "image_id" {
  type = string
  default = "ami-0e0102e3ff768559b"
}

variable "instance_type" {
  type = string
  default = "t3.medium"
}

variable "my_key" {
  type = string
  default = "roha_account2"
}

variable "full_key-path" {
  type = string
  default = "/home/ubuntu/.ssh/your_private_key_file.pem"
  # Please make sure this file is in the PATH as specified.
}

variable "clustername" {
  type = string
  default = "democluster"
}

variable "number_of_masternodes" {
  description = "Number of master nodes (minimum=1, best practice=3 or 5 - must be uneven)"
  type = number
  default = 3
}

variable "number_of_workernodes" {
  description = "Number of worker nodes (minimum=1, best practice=3+ - depends on K8s workload)"
  type = number
  default = 3
}

variable "name-for-SG" {
  type = string
  default = "K0s_SecurityGroup"
}


