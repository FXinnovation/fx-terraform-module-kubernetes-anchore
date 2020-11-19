#####
# Global
#####

variable "namespace" {
  type = string
}

variable "annotations" {
  type = map
}

variable "labels" {
  type = map
}

variable "name_prefix" {
  type = string
}

#####
# Application
#####

variable "replicas" {
  type = number
}

variable "image" {
  type = string
}

variable "image_version" {
  type = string
}

variable "configuation" {
  type = string
}

variable "component" {
  type = string
}

variable "configuration_config_map_name" {
  type = string
}

variable "environment_secret_name" {
  type = string
}

variable "environment_config_map_name" {
  type = string
}

#####
# Deployment
#####

variable "deployment_labels" {
  type = map
}

variable "deployment_template_labels" {
  type = map
}

variable "deployment_annotations" {
  type = map
}

variable "deployment_template_annotations" {
  type = map
}

variable "deployment_strategy" {
  type = string
}

#####
# Service
#####

variable "service_labels" {
  type = map
}

variable "service_annotations" {
  type = map
}

#####
# Config Map
#####

variable "config_map_labels" {
  type = map
}

variable "config_map_annotations" {
  type = map
}
