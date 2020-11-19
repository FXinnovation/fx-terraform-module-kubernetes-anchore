#####
# Locals
#####

locals {
  labels = {
    "version"    = var.image_version
    "part-of"    = "anchore-engine"
    "managed-by" = "terraform"
  }
  annotations = {}
}

#####
# common
#####

module "common" {
  source = "./modules/common"

  # Global
  namespace   = var.namespace
  annotations = merge(var.annotations, local.annotations)
  labels      = merge(var.labels, local.labels)
  name_prefix = var.name_prefix

  # Database
  database_host     = var.database_host
  database_name     = var.database_name
  database_user     = var.database_user
  database_password = var.database_password

  # Application
  configuration = var.common_configuration

  # Configuration
  configuration_config_map_labels      = var.configuration_config_map_labels
  configuration_config_map_annotations = var.configuration_config_map_annotations

  # Environment
  environment_config_map_labels      = var.environment_config_map_labels
  environment_config_map_annotations = var.environment_config_map_annotations
  environment_secret_labels          = var.environment_secret_labels
  environment_secret_annotations     = var.environment_secret_annotations
}

#####
# apiext
#####

module "apiext" {
  source = "./modules/component"

  # Global
  namespace   = var.namespace
  annotations = merge(var.annotations, var.apiext_annotations, local.annotations)
  labels      = merge(var.labels, var.apiext_labels, local.labels)
  name_prefix = var.name_prefix

  # Application
  replicas                      = 1
  image                         = var.image
  image_version                 = var.image_version
  configuration                 = ""
  component                     = "apiext"
  configuration_config_map_name = module.common.configuration_config_map.metadata.0.name
  environment_secret_name       = module.common.environment_secret.metadata.0.name
  environment_config_map_name   = module.common.environment_config_map.metadata.0.name

  # Deployment
  deployment_labels               = var.apiext_deployment_labels
  deployment_annotations          = var.apiext_deployment_annotations
  deployment_template_labels      = var.apiext_deployment_template_labels
  deployment_template_annotations = var.apiext_deployment_template_annotations
  deployment_strategy             = var.apiext_deployment_strategy

  # Service
  service_labels      = var.apiext_service_labels
  service_annotations = var.apiext_service_annotations

  # ConfigMap
  config_map_labels      = {}
  config_map_annotations = {}
}

#####
# analyzer
#####

module "analyzer" {
  source = "./modules/component"

  # Global
  namespace   = var.namespace
  annotations = merge(var.annotations, var.analyzer_annotations, local.annotations)
  labels      = merge(var.labels, var.analyzer_labels, local.labels)
  name_prefix = var.name_prefix

  # Application
  replicas                      = 1
  image                         = var.image
  image_version                 = var.image_version
  configuration                 = var.analyzer_configuration
  component                     = "analyzer"
  configuration_config_map_name = module.common.configuration_config_map.metadata.0.name
  environment_secret_name       = module.common.environment_secret.metadata.0.name
  environment_config_map_name   = module.common.environment_config_map.metadata.0.name

  # Deployment
  deployment_labels               = var.analyzer_deployment_labels
  deployment_annotations          = var.analyzer_deployment_annotations
  deployment_template_labels      = var.analyzer_deployment_template_labels
  deployment_template_annotations = var.analyzer_deployment_template_annotations
  deployment_strategy             = var.analyzer_deployment_strategy

  # Service
  service_labels      = var.analyzer_service_labels
  service_annotations = var.analyzer_service_annotations

  # ConfigMap
  config_map_labels      = var.analyzer_config_map_labels
  config_map_annotations = var.analyzer_config_map_annotations
}

#####
# catalog
#####

module "catalog" {
  source = "./modules/component"

  # Global
  namespace   = var.namespace
  annotations = merge(var.annotations, var.catalog_annotations, local.annotations)
  labels      = merge(var.labels, var.catalog_labels, local.labels)
  name_prefix = var.name_prefix

  # Application
  replicas                      = 1
  image                         = var.image
  image_version                 = var.image_version
  configuration                 = ""
  component                     = "catalog"
  configuration_config_map_name = module.common.configuration_config_map.metadata.0.name
  environment_secret_name       = module.common.environment_secret.metadata.0.name
  environment_config_map_name   = module.common.environment_config_map.metadata.0.name

  # Deployment
  deployment_labels               = var.catalog_deployment_labels
  deployment_annotations          = var.catalog_deployment_annotations
  deployment_template_labels      = var.catalog_deployment_template_labels
  deployment_template_annotations = var.catalog_deployment_template_annotations
  deployment_strategy             = var.catalog_deployment_strategy

  # Service
  service_labels      = var.catalog_service_labels
  service_annotations = var.catalog_service_annotations

  # ConfigMap
  config_map_labels      = {}
  config_map_annotations = {}
}

#####
# policy_engine
#####

module "policy_engine" {
  source = "./modules/component"

  # Global
  namespace   = var.namespace
  annotations = merge(var.annotations, var.policy_engine_annotations, local.annotations)
  labels      = merge(var.labels, var.policy_engine_labels, local.labels)
  name_prefix = var.name_prefix

  # Application
  replicas                      = 1
  image                         = var.image
  image_version                 = var.image_version
  configuration                 = ""
  component                     = "policy_engine"
  configuration_config_map_name = module.common.configuration_config_map.metadata.0.name
  environment_secret_name       = module.common.environment_secret.metadata.0.name
  environment_config_map_name   = module.common.environment_config_map.metadata.0.name

  # Deployment
  deployment_labels               = var.policy_engine_deployment_labels
  deployment_annotations          = var.policy_engine_deployment_annotations
  deployment_template_labels      = var.policy_engine_deployment_template_labels
  deployment_template_annotations = var.policy_engine_deployment_template_annotations
  deployment_strategy             = var.policy_engine_deployment_strategy

  # Service
  service_labels      = var.policy_engine_service_labels
  service_annotations = var.policy_engine_service_annotations

  # ConfigMap
  config_map_labels      = {}
  config_map_annotations = {}
}

#####
# simplequeue
#####

module "simplequeue" {
  source = "./modules/component"

  # Global
  namespace   = var.namespace
  annotations = merge(var.annotations, var.simplequeue_annotations, local.annotations)
  labels      = merge(var.labels, var.simplequeue_labels, local.labels)
  name_prefix = var.name_prefix

  # Application
  replicas                      = 1
  image                         = var.image
  image_version                 = var.image_version
  configuration                 = ""
  component                     = "simplequeue"
  configuration_config_map_name = module.common.configuration_config_map.metadata.0.name
  environment_secret_name       = module.common.environment_secret.metadata.0.name
  environment_config_map_name   = module.common.environment_config_map.metadata.0.name

  # Deployment
  deployment_labels               = var.simplequeue_deployment_labels
  deployment_annotations          = var.simplequeue_deployment_annotations
  deployment_template_labels      = var.simplequeue_deployment_template_labels
  deployment_template_annotations = var.simplequeue_deployment_template_annotations
  deployment_strategy             = var.simplequeue_deployment_strategy

  # Service
  service_labels      = var.simplequeue_service_labels
  service_annotations = var.simplequeue_service_annotations

  # ConfigMap
  config_map_labels      = {}
  config_map_annotations = {}
}
