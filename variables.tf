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
