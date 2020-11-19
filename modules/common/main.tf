#####
# Locals
#####

locals {
  labels = {
    component = "common"
  }
  annotations = {}
  name        = format("%s-configuration", var.name_prefix)
}

#####
# Randoms
#####

resource "random_password" "this" {
  length  = 30
  special = false
}

#####
# Configuration
#####

resource "kubernetes_config_map" "configuration" {
  metadata {
    name      = format("%s-configuration", var.name_prefix)
    namespace = var.namespace

    labels = merge(
      var.labels,
      var.configuration_config_map_labels,
      local.labels,
      { instance = format("%s-configuration", var.name_prefix) }
    )

    annotations = merge(
      var.annotations,
      var.configuration_config_map_annotations,
      local.annotations
    )
  }

  data = {
    "config.yaml" = var.configuration
  }
}

resource "kubernetes_config_map" "environment" {
  metadata {
    name      = format("%s-environment", var.name_prefix)
    namespace = var.namespace

    labels = merge(
      var.labels,
      var.environment_config_map_labels,
      local.labels,
      { instance = format("%s-environment", var.name_prefix) }
    )

    annotations = merge(
      var.annotations,
      var.environment_config_map_annotations,
      local.annotations
    )
  }

  data = {
    ANCHORE_DB_HOST                    = var.database_host
    ANCHORE_DB_NAME                    = var.database_name
    ANCHORE_DB_USER                    = var.database_user
    ANCHORE_POLICY_ENGINE_SERVICE_NAME = format("%s-policy_engine", var.name_pefix)
    ANCHORE_SIMPLEQUEUE_SERVICE_NAME   = format("%s-simplequeue", var.name_prefix)
    ANCHORE_CATALOG_SERVICE_NAME       = format("%s-catalog", var.name_prefix)
    ANCHORE_ANALYZER_SERVICE_NAME      = format("%s-analyzer", var.name_prefix)
    ANCHORE_APIEXT_SERVICE_NAME        = format("%s-apiext", var.name_prefix)
  }
}

resource "kubernetes_secret" "environment" {
  metadata {
    name      = format("%s-environment", var.name_prefix)
    namespace = var.namespace

    labels = merge(
      var.labels,
      var.environment_secret_labels,
      local.labels,
      { instance = format("%s-environment", var.name_prefix) }
    )

    annotations = merge(
      var.annotations,
      var.environment_secret_annotations,
      local.annotations
    )
  }

  data = {
    ANCHORE_ADMIN_PASSWORD = random_password.this.result
    ANCHORE_DB_PASSWORD    = var.database_password
  }

  type = "Opaque"
}
