#####
# Globals
#####

variable "name_prefix" {
  type = string
}

variable "namespace" {
  type = string
}

variable "labels" {
  type = map
}

variable "annotations" {
  type = map
}

#####
# Database
#####

variable "database_host" {
  type = string
}

variable "database_name" {
  type = string
}

variable "database_user" {
  type = string
}

variable "database_password" {
  type = string
}


#####
# Application
#####

variable "configuration" {
  type = string
}

#####
# Configuration
#####

variable "configuration_config_map_labels" {
  type = map
}

variable "configuration_config_map_annotations" {
  type = map
}

#####
# Environment
#####


variable "environment_config_map_labels" {
  type = map
}

variable "environment_config_map_annotations" {
  type = map
}

variable "environment_secret_labels" {
  type = map
}

variable "environment_secret_annotations" {
  type = map
}
