#####
# Locals
#####

locals {
  labels = {
    component = var.component
    instance  = local.name
  }
  annotations = {}
  selector    = format("anchore-engine-%s-%s", var.component, random_string.selector.result)
  name        = format("%s-%s", var.name_prefix, var.component)
}

#####
# Randoms
#####

resource "random_string" "selector" {
  special = false
  upper   = false
  number  = false
  length  = 8
}

######
# Deployment
######

resource "kubernetes_deployment" "this" {
  metadata {
    name      = local.name
    namespace = var.namespace

    labels = merge(
      var.labels,
      var.deployment_labels,
      local.labels
    )

    annotations = merge(
      var.annotations,
      var.deployment_annotations,
      local.annotations
    )
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        selector = local.selector
      }
    }

    template {
      metadata {
        labels = merge(
          var.labels,
          var.deployment_template_labels,
          local.labels,
          {
            selector = local.selector
          }
        )
        annotations = merge(
          var.annotations,
          var.deployment_annotations,
          local.annotations
        )
      }

      spec {
        volume {
          name = "configuration"

          config_map {
            name         = var.configuration_config_map_name
            default_mode = "0644"
          }
        }

        dynamic "volume" {
          for_each = "analyzer" == var.component || "policy_engine" == var.component ? [1] : []

          content {
            name = "scratch"
          }
        }

        dynamic "volume" {
          for_each = "analyzer" == var.component ? [1] : []

          content {
            name = "analyzer-configuration"

            config_map {
              name         = element(concat(kubernetes_config_map.this.*.metadata.0.name, list("")), 0)
              default_mode = "0644"
            }
          }
        }

        container {
          name              = format("anchore-engine-%s", var.component)
          image             = format("%s:%s", var.image, var.image_verison)
          image_pull_policy = "IfNotPresent"
          args              = ["anchore-manager", "service", "start", "--no-auto-upgrade", var.component]

          port {
            name           = "http"
            container_port = 8228
            protocol       = "TCP"
          }

          env_from {
            secret_ref {
              name = var.environment_secret_name
            }
          }

          env_from {
            config_map_ref {
              name = var.environment_config_map_name
            }
          }

          env {
            name = "ANCHORE_POD_NAME"

            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "metadata.name"
              }
            }
          }

          env {
            name = "ANCHORE_CLI_PASS"

            value_from {
              secret_key_ref {
                name = var.environment_secret_name
                key  = "ANCHORE_ADMIN_PASSWORD"
              }
            }
          }

          volume_mount {
            name       = "configuration"
            mount_path = "/config/config.yaml"
            sub_path   = "config.yaml"
          }

          dynamic "volume_mount" {
            for_each = "analyzer" == var.component ? [1] : []

            content {
              name       = "analyzer-configuration"
              mount_path = "/anchore_service/analyzer_config.yaml"
              sub_path   = "analyzer_config.yaml"
            }
          }

          dynamic "volume_mount" {
            for_each = "analyzer" == var.component || "policy_engine" == var.component ? [1] : []
            content {
              name       = "scratch"
              mount_path = "/analysis_scratch"
            }
          }

          liveness_probe {
            http_get {
              path   = "/health"
              port   = "http"
              scheme = "HTTP"
            }

            initial_delay_seconds = 120
            timeout_seconds       = 10
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 6
          }

          readiness_probe {
            http_get {
              path   = "/health"
              port   = "http"
              scheme = "HTTP"
            }

            timeout_seconds   = 10
            period_seconds    = 10
            success_threshold = 1
            failure_threshold = 3
          }
        }

        security_context {
          run_as_user  = 1000
          run_as_group = 1000
        }
      }
    }

    strategy {
      type = var.deployment_strategy
    }
  }
}

#####
# Service
#####

resource "kubernetes_service" "this" {
  metadata {
    name      = local.name
    namespace = var.namespace

    labels = merge(
      var.labels,
      var.service_labels,
      local.labels,
    )

    annotations = merge(
      var.annotations,
      var.service_annotations,
      local.annotations
    )
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = "http"
    }

    selector = {
      selector = local.selector
    }

    type = "ClusterIP"
  }
}

#####
# Config Map
#####

resource "kubernetes_config_map" "this" {
  count = "analyzer" == var.component ? 1 : 0

  metadata {
    name      = local.name
    namespace = var.namespace

    labels = merge(
      var.labels,
      var.config_map_labels,
      local.labels
    )

    annotations = merge(
      var.annotations,
      var.config_map_annotations,
      local.annotations
    )
  }

  data = {
    "analyzer_config.yaml" = var.configuration
  }
}
