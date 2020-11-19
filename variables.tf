#####
# Global
#####

variable "name_prefix" {
  description = "Prefix that will be used in resource names."
  default     = "anchore-engine"
}

variable "namespace" {
  description = "Namespace in which the resources will be deployed."
  default     = "default"
}

variable "labels" {
  description = "Map of labels to be applied on all resources."
  default     = {}
  type        = map(string)
}

variable "annotations" {
  description = "Map of annotations to be applied on all resources."
  default     = {}
  type        = map(string)
}

#####
# Application
#####

variable "common_configuration" {
  description = "Configuration string that will be applied on all components"
  default     = <<EOT
# Anchore Service Configuration File from ConfigMap
service_dir: /anchore_service
tmp_dir: /analysis_scratch
log_level: INFO
image_analyze_timeout_seconds: 36000
cleanup_images: true
allow_awsecr_iam_auto: false
host_id: "$${ANCHORE_POD_NAME}"
internal_ssl_verify: false
auto_restart_services: false

global_client_connect_timeout: 0
global_client_read_timeout:    0

metrics:
  enabled: false
  auth_disabled: false

# Configure what feeds to sync.
# The sync will hit http://ancho.re/feeds, if any outbound firewall config needs to be set in your environment.
feeds:
  sync_enabled: true
  selective_sync:
    # If enabled only sync specific feeds instead of all that are found.
    enabled:    true
    feeds:
      github: true
      # Vulnerabilities feed is the feed for distro cve sources (redhat, debian, ubuntu, oracle, alpine....)
      vulnerabilities: true
      # NVD Data is used for non-distro CVEs (jars, npm, etc) that are not packaged and released by distros as rpms, debs, etc
      nvdv2: true
      # Warning: enabling the package sync causes the service to require much
      # more memory to do process the significant data volume. We recommend at least 4GB available for the container
      packages: false
      # Enabling vulndb syncs vulndb vulnerability data from an on-premise anchore enterprise feeds service. Please contact
      # anchore support for finding out more about this service
      vulndb: false
      microsoft: false
      # Sync github data if available for GHSA matches
      github: true
  client_url: "https://ancho.re/v1/account/users"
  token_url: "https://ancho.re/oauth/token"
  anonymous_user_username: anon@ancho.re
  anonymous_user_password: pbiU2RYZ2XrmYQ
  connection_timeout_seconds: 3
  read_timeout_seconds:    180
default_admin_password: $${ANCHORE_ADMIN_PASSWORD}
default_admin_email: example@email.com

# Locations for keys used for signing and encryption. Only one of 'secret' or 'public_key_path'/'private_key_path' needs to be set. If all are set then the keys take precedence over the secret value
# Secret is for a shared secret and if set, all components in anchore should have the exact same value in their configs.
keys:
  secret:

# Configuring supported user authentication and credential management
user_authentication:
    oauth:
      enabled: false
      default_token_expiration_seconds: 3600

  # Set this to True to enable storing user passwords only as secure hashes in the db. This can dramatically increase CPU usage if you
  # don't also use oauth and tokens for internal communications (which requires keys/secret to be configured    as well)
  # WARNING: you should not change this after a system has been initialized    as it may cause a mismatch in existing passwords
  hashed_passwords: false

credentials:
  database:
    db_connect: "postgresql://$${ANCHORE_DB_USER}:$${ANCHORE_DB_PASSWORD}@$${ANCHORE_DB_HOST}/$${ANCHORE_DB_NAME}"
    db_connect_args:
      timeout: 120
      ssl: false
    db_pool_size:    30
    db_pool_max_overflow: 100
services:
  apiext:
    enabled: true
    require_auth: true
    endpoint_hostname: $${ANCHORE_APIEXT_SERVICE_NAME}
    max_request_threads: 50
    listen: 0.0.0.0
    port: 80
  analyzer:
    enabled: true
    require_auth: true
    endpoint_hostname: $${ANCHORE_ANALYZER_SERVICE_NAME}
    listen: 0.0.0.0
    port: 80
    max_request_threads: 50
    cycle_timer_seconds: 1
    cycle_timers:
      image_analyzer: 5
    max_threads: 1
    analyzer_driver: 'nodocker'
    layer_cache_enable: false
    layer_cache_max_gigabytes: 0
    enable_hints: false
  catalog:
    enabled: true
    require_auth: true
    endpoint_hostname: $${ANCHORE_CATALOG_SERVICE_NAME}
    listen: 0.0.0.0
    port: 80
    max_request_threads: 50
    cycle_timer_seconds: 1
    cycle_timers:
      # Interval to check for an update to a tag
      image_watcher: 3600
      # Interval to run a policy evaluation on images with the policy_eval subscription activated.
      policy_eval: 3600
      # Interval to run a vulnerability scan on images with the vuln_update subscription activated.
      vulnerability_scan: 14400
      # Interval at which the catalog looks for new work to put on the image analysis queue.
      analyzer_queue: 1
      # Interval notifications will be processed for state changes
      notifications: 30
      # Intervals    service state updates are polled for the system status
      service_watcher: 15
      # Interval between checks to repo for new tags
      repo_watcher: 60
    event_log:
      notification:
        enabled: false
        level:
        - error
    archive:
      compression:
        enabled: true
        min_size_kbytes: 100
      storage_driver:
        config: {}
        name: db
  simplequeue:
    enabled: true
    require_auth: true
    endpoint_hostname: $${ANCHORE_SIMPLEQUEUE_SERVICE_NAME}
    listen: 0.0.0.0
    port: 80
    max_request_threads: 50
  policy_engine:
    enabled: true
    require_auth: true
    max_request_threads: 50
    endpoint_hostname: $${ANCHORE_POLICY_ENGINE_SERVICE_NAME}
    listen: 0.0.0.0
    port: 80
    cycle_timer_seconds:    1
    cycle_timers:
      feed_sync: 14400
      feed_sync_checker: 3600
EOT
}

variable "configuration_config_map_labels" {
  description = "Map of labels to be applied on the configuration config map."
  default     = {}
  type        = map(string)
}

variable "configuration_config_map_annotations" {
  description = "Map of annotations to be applied on the configuration config map."
  default     = {}
  type        = map(string)
}

variable "environment_config_map_labels" {
  description = "Map of labels to be applied on the environment config map."
  default     = {}
  type        = map(string)
}

variable "environment_config_map_annotations" {
  description = "Map of annotations to be applied on the environment config map."
  default     = {}
  type        = map(string)
}

variable "environment_secret_labels" {
  description = "Map of labels to be applied on the environment secret."
  default     = {}
  type        = map(string)
}

variable "environment_secret_annotations" {
  description = "Map of annotations to be applied on the environment secret."
  default     = {}
  type        = map(string)
}

variable "image" {
  description = "Docker image to use."
  default     = "docker.io/anchore/anchore-engine"
}

variable "image_version" {
  description = "Version of the docker image."
  default     = "v0.8.2"
}

#####
# Database
#####

variable "database_host" {
  description = "URL of the database to use."
  type        = string
}

variable "database_name" {
  description = "Name of the database to use."
  type        = string
}

variable "database_user" {
  description = "User of the database to use."
  type        = string
}

variable "database_password" {
  description = "Password of the database to use."
  type        = string
}

#####
# apiext
#####

variable "apiext_labels" {
  description = "Map of labels that will be applied on all apiext resources."
  default     = {}
  type        = map(string)
}

variable "apiext_annotations" {
  description = "Map of annotations that will be applied on all apiext resources."
  default     = {}
  type        = map(string)
}

variable "apiext_deployment_labels" {
  description = "Map of labels that will be applied on all apiext deployment."
  default     = {}
  type        = map(string)
}

variable "apiext_deployment_annotations" {
  description = "Map of annotations that will be applied on all apiext deployment."
  default     = {}
  type        = map(string)
}

variable "apiext_deployment_template_labels" {
  description = "Map of labels that will be applied on all apiext deployment template."
  default     = {}
  type        = map(string)
}

variable "apiext_deployment_template_annotations" {
  description = "Map of annotations that will be applied on all apiext deployment template."
  default     = {}
  type        = map(string)
}

variable "apiext_service_labels" {
  description = "Map of labels that will be applied on all apiext service."
  default     = {}
  type        = map(string)
}

variable "apiext_service_annotations" {
  description = "Map of annotations that will be applied on all apiext service."
  default     = {}
  type        = map(string)
}

#####
# analyzer
#####

variable "analyzer_labels" {
  description = "Map of labels that will be applied on all analyzer resources."
  default     = {}
  type        = map(string)
}

variable "analyzer_annotations" {
  description = "Map of annotations that will be applied on all analyzer resources."
  default     = {}
  type        = map(string)
}

variable "analyzer_deployment_labels" {
  description = "Map of labels that will be applied on all analyzer deployment."
  default     = {}
  type        = map(string)
}

variable "analyzer_deployment_annotations" {
  description = "Map of annotations that will be applied on all analyzer deployment."
  default     = {}
  type        = map(string)
}

variable "analyzer_deployment_template_labels" {
  description = "Map of labels that will be applied on all analyzer deployment template."
  default     = {}
  type        = map(string)
}

variable "analyzer_deployment_template_annotations" {
  description = "Map of annotations that will be applied on all analyzer deployment template."
  default     = {}
  type        = map(string)
}

variable "analyzer_service_labels" {
  description = "Map of labels that will be applied on all analyzer service."
  default     = {}
  type        = map(string)
}

variable "analyzer_service_annotations" {
  description = "Map of annotations that will be applied on all analyzer service."
  default     = {}
  type        = map(string)
}

variable "analyzer_config_map_labels" {
  description = "Map of labels that will be applied on all analyzer config_map."
  default     = {}
  type        = map(string)
}

variable "analyzer_config_map_annotations" {
  description = "Map of annotations that will be applied on all analyzer config_map."
  default     = {}
  type        = map(string)
}

#####
# catalog
#####

variable "catalog_labels" {
  description = "Map of labels that will be applied on all catalog resources."
  default     = {}
  type        = map(string)
}

variable "catalog_annotations" {
  description = "Map of annotations that will be applied on all catalog resources."
  default     = {}
  type        = map(string)
}

variable "catalog_deployment_labels" {
  description = "Map of labels that will be applied on all catalog deployment."
  default     = {}
  type        = map(string)
}

variable "catalog_deployment_annotations" {
  description = "Map of annotations that will be applied on all catalog deployment."
  default     = {}
  type        = map(string)
}

variable "catalog_deployment_template_labels" {
  description = "Map of labels that will be applied on all catalog deployment template."
  default     = {}
  type        = map(string)
}

variable "catalog_deployment_template_annotations" {
  description = "Map of annotations that will be applied on all catalog deployment template."
  default     = {}
  type        = map(string)
}

variable "catalog_service_labels" {
  description = "Map of labels that will be applied on all catalog service."
  default     = {}
  type        = map(string)
}

variable "catalog_service_annotations" {
  description = "Map of annotations that will be applied on all catalog service."
  default     = {}
  type        = map(string)
}

#####
# policy_engine
#####

variable "policy_engine_labels" {
  description = "Map of labels that will be applied on all policy_engine resources."
  default     = {}
  type        = map(string)
}

variable "policy_engine_annotations" {
  description = "Map of annotations that will be applied on all policy_engine resources."
  default     = {}
  type        = map(string)
}

variable "policy_engine_deployment_labels" {
  description = "Map of labels that will be applied on all policy_engine deployment."
  default     = {}
  type        = map(string)
}

variable "policy_engine_deployment_annotations" {
  description = "Map of annotations that will be applied on all policy_engine deployment."
  default     = {}
  type        = map(string)
}

variable "policy_engine_deployment_template_labels" {
  description = "Map of labels that will be applied on all policy_engine deployment template."
  default     = {}
  type        = map(string)
}

variable "policy_engine_deployment_template_annotations" {
  description = "Map of annotations that will be applied on all policy_engine deployment template."
  default     = {}
  type        = map(string)
}

variable "policy_engine_service_labels" {
  description = "Map of labels that will be applied on all policy_engine service."
  default     = {}
  type        = map(string)
}

variable "policy_engine_service_annotations" {
  description = "Map of annotations that will be applied on all policy_engine service."
  default     = {}
  type        = map(string)
}

#####
# simplequeue
#####

variable "simplequeue_labels" {
  description = "Map of labels that will be applied on all simplequeue resources."
  default     = {}
  type        = map(string)
}

variable "simplequeue_annotations" {
  description = "Map of annotations that will be applied on all simplequeue resources."
  default     = {}
  type        = map(string)
}

variable "simplequeue_deployment_labels" {
  description = "Map of labels that will be applied on all simplequeue deployment."
  default     = {}
  type        = map(string)
}

variable "simplequeue_deployment_annotations" {
  description = "Map of annotations that will be applied on all simplequeue deployment."
  default     = {}
  type        = map(string)
}

variable "simplequeue_deployment_template_labels" {
  description = "Map of labels that will be applied on all simplequeue deployment template."
  default     = {}
  type        = map(string)
}

variable "simplequeue_deployment_template_annotations" {
  description = "Map of annotations that will be applied on all simplequeue deployment template."
  default     = {}
  type        = map(string)
}

variable "simplequeue_service_labels" {
  description = "Map of labels that will be applied on all simplequeue service."
  default     = {}
  type        = map(string)
}

variable "simplequeue_service_annotations" {
  description = "Map of annotations that will be applied on all simplequeue service."
  default     = {}
  type        = map(string)
}
