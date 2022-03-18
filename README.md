# terraform-module-kubernetes-anchore-engine

Terraform module that deploys anchore-engine on kubernetes.

**Note: This module does NOT deploy the postgres database. This has to be deployed seperately!**

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| kubernetes | >= 1.10.0 |
| random | >= 2.2.0 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| analyzer\_annotations | Map of annotations that will be applied on all analyzer resources. | `map(string)` | `{}` | no |
| analyzer\_config\_map\_annotations | Map of annotations that will be applied on all analyzer config\_map. | `map(string)` | `{}` | no |
| analyzer\_config\_map\_labels | Map of labels that will be applied on all analyzer config\_map. | `map(string)` | `{}` | no |
| analyzer\_deployment\_annotations | Map of annotations that will be applied on all analyzer deployment. | `map(string)` | `{}` | no |
| analyzer\_deployment\_labels | Map of labels that will be applied on all analyzer deployment. | `map(string)` | `{}` | no |
| analyzer\_deployment\_template\_annotations | Map of annotations that will be applied on all analyzer deployment template. | `map(string)` | `{}` | no |
| analyzer\_deployment\_template\_labels | Map of labels that will be applied on all analyzer deployment template. | `map(string)` | `{}` | no |
| analyzer\_labels | Map of labels that will be applied on all analyzer resources. | `map(string)` | `{}` | no |
| analyzer\_service\_annotations | Map of annotations that will be applied on all analyzer service. | `map(string)` | `{}` | no |
| analyzer\_service\_labels | Map of labels that will be applied on all analyzer service. | `map(string)` | `{}` | no |
| annotations | Map of annotations to be applied on all resources. | `map(string)` | `{}` | no |
| apiext\_annotations | Map of annotations that will be applied on all apiext resources. | `map(string)` | `{}` | no |
| apiext\_deployment\_annotations | Map of annotations that will be applied on all apiext deployment. | `map(string)` | `{}` | no |
| apiext\_deployment\_labels | Map of labels that will be applied on all apiext deployment. | `map(string)` | `{}` | no |
| apiext\_deployment\_template\_annotations | Map of annotations that will be applied on all apiext deployment template. | `map(string)` | `{}` | no |
| apiext\_deployment\_template\_labels | Map of labels that will be applied on all apiext deployment template. | `map(string)` | `{}` | no |
| apiext\_labels | Map of labels that will be applied on all apiext resources. | `map(string)` | `{}` | no |
| apiext\_service\_annotations | Map of annotations that will be applied on all apiext service. | `map(string)` | `{}` | no |
| apiext\_service\_labels | Map of labels that will be applied on all apiext service. | `map(string)` | `{}` | no |
| catalog\_annotations | Map of annotations that will be applied on all catalog resources. | `map(string)` | `{}` | no |
| catalog\_deployment\_annotations | Map of annotations that will be applied on all catalog deployment. | `map(string)` | `{}` | no |
| catalog\_deployment\_labels | Map of labels that will be applied on all catalog deployment. | `map(string)` | `{}` | no |
| catalog\_deployment\_template\_annotations | Map of annotations that will be applied on all catalog deployment template. | `map(string)` | `{}` | no |
| catalog\_deployment\_template\_labels | Map of labels that will be applied on all catalog deployment template. | `map(string)` | `{}` | no |
| catalog\_labels | Map of labels that will be applied on all catalog resources. | `map(string)` | `{}` | no |
| catalog\_service\_annotations | Map of annotations that will be applied on all catalog service. | `map(string)` | `{}` | no |
| catalog\_service\_labels | Map of labels that will be applied on all catalog service. | `map(string)` | `{}` | no |
| common\_configuration | Configuration string that will be applied on all components | `string` | `"# Anchore Service Configuration File from ConfigMap\nservice_dir: /anchore_service\ntmp_dir: /analysis_scratch\nlog_level: INFO\nimage_analyze_timeout_seconds: 36000\ncleanup_images: true\nallow_awsecr_iam_auto: false\nhost_id: \"${ANCHORE_POD_NAME}\"\ninternal_ssl_verify: false\nauto_restart_services: false\n\nglobal_client_connect_timeout: 0\nglobal_client_read_timeout:    0\n\nmetrics:\n  enabled: false\n  auth_disabled: false\n\n# Configure what feeds to sync.\n# The sync will hit http://ancho.re/feeds, if any outbound firewall config needs to be set in your environment.\nfeeds:\n  sync_enabled: true\n  selective_sync:\n    # If enabled only sync specific feeds instead of all that are found.\n    enabled:    true\n    feeds:\n      github: true\n      # Vulnerabilities feed is the feed for distro cve sources (redhat, debian, ubuntu, oracle, alpine....)\n      vulnerabilities: true\n      # NVD Data is used for non-distro CVEs (jars, npm, etc) that are not packaged and released by distros as rpms, debs, etc\n      nvdv2: true\n      # Warning: enabling the package sync causes the service to require much\n      # more memory to do process the significant data volume. We recommend at least 4GB available for the container\n      packages: false\n      # Enabling vulndb syncs vulndb vulnerability data from an on-premise anchore enterprise feeds service. Please contact\n      # anchore support for finding out more about this service\n      vulndb: false\n      microsoft: false\n      # Sync github data if available for GHSA matches\n      github: true\n  client_url: \"https://ancho.re/v1/account/users"n  token_url: \"https://ancho.re/oauth/token"n  anonymous_user_username: anon@ancho.re\n  anonymous_user_password: pbiU2RYZ2XrmYQ\n  connection_timeout_seconds: 3\n  read_timeout_seconds:    180\ndefault_admin_password: ${ANCHORE_ADMIN_PASSWORD}\ndefault_admin_email: example@email.com\n\n# Locations for keys used for signing and encryption. Only one of 'secret' or 'public_key_path'/'private_key_path' needs to be set. If all are set then the keys take precedence over the secret value\n# Secret is for a shared secret and if set, all components in anchore should have the exact same value in their configs.\nkeys:\n  secret:\n\n# Configuring supported user authentication and credential management\nuser_authentication:\n    oauth:\n      enabled: false\n      default_token_expiration_seconds: 3600\n\n  # Set this to True to enable storing user passwords only as secure hashes in the db. This can dramatically increase CPU usage if you\n  # don't also use oauth and tokens for internal communications (which requires keys/secret to be configured    as well)\n  # WARNING: you should not change this after a system has been initialized    as it may cause a mismatch in existing passwords\n  hashed_passwords: false\n\ncredentials:\n  database:\n    db_connect: \"postgresql://${ANCHORE_DB_USER}:${ANCHORE_DB_PASSWORD}@${ANCHORE_DB_HOST}/${ANCHORE_DB_NAME}\"\n    db_connect_args:\n      timeout: 120\n      ssl: false\n    db_pool_size:    30\n    db_pool_max_overflow: 100\nservices:\n  apiext:\n    enabled: true\n    require_auth: true\n    endpoint_hostname: ${ANCHORE_APIEXT_SERVICE_NAME}\n    max_request_threads: 50\n    listen: 0.0.0.0\n    port: 80\n  analyzer:\n    enabled: true\n    require_auth: true\n    endpoint_hostname: ${ANCHORE_ANALYZER_SERVICE_NAME}\n    listen: 0.0.0.0\n    port: 80\n    max_request_threads: 50\n    cycle_timer_seconds: 1\n    cycle_timers:\n      image_analyzer: 5\n    max_threads: 1\n    analyzer_driver: 'nodocker'\n    layer_cache_enable: false\n    layer_cache_max_gigabytes: 0\n    enable_hints: false\n  catalog:\n    enabled: true\n    require_auth: true\n    endpoint_hostname: ${ANCHORE_CATALOG_SERVICE_NAME}\n    listen: 0.0.0.0\n    port: 80\n    max_request_threads: 50\n    cycle_timer_seconds: 1\n    cycle_timers:\n      # Interval to check for an update to a tag\n      image_watcher: 3600\n      # Interval to run a policy evaluation on images with the policy_eval subscription activated.\n      policy_eval: 3600\n      # Interval to run a vulnerability scan on images with the vuln_update subscription activated.\n      vulnerability_scan: 14400\n      # Interval at which the catalog looks for new work to put on the image analysis queue.\n      analyzer_queue: 1\n      # Interval notifications will be processed for state changes\n      notifications: 30\n      # Intervals    service state updates are polled for the system status\n      service_watcher: 15\n      # Interval between checks to repo for new tags\n      repo_watcher: 60\n    event_log:\n      notification:\n        enabled: false\n        level:\n        - error\n    archive:\n      compression:\n        enabled: true\n        min_size_kbytes: 100\n      storage_driver:\n        config: {}\n        name: db\n  simplequeue:\n    enabled: true\n    require_auth: true\n    endpoint_hostname: ${ANCHORE_SIMPLEQUEUE_SERVICE_NAME}\n    listen: 0.0.0.0\n    port: 80\n    max_request_threads: 50\n  policy_engine:\n    enabled: true\n    require_auth: true\n    max_request_threads: 50\n    endpoint_hostname: ${ANCHORE_POLICY_ENGINE_SERVICE_NAME}\n    listen: 0.0.0.0\n    port: 80\n    cycle_timer_seconds:    1\n    cycle_timers:\n      feed_sync: 14400\n      feed_sync_checker: 3600\n"` | no |
| configuration\_config\_map\_annotations | Map of annotations to be applied on the configuration config map. | `map(string)` | `{}` | no |
| configuration\_config\_map\_labels | Map of labels to be applied on the configuration config map. | `map(string)` | `{}` | no |
| database\_host | URL of the database to use. | `string` | n/a | yes |
| database\_name | Name of the database to use. | `string` | n/a | yes |
| database\_password | Password of the database to use. | `string` | n/a | yes |
| database\_user | User of the database to use. | `string` | n/a | yes |
| environment\_config\_map\_annotations | Map of annotations to be applied on the environment config map. | `map(string)` | `{}` | no |
| environment\_config\_map\_labels | Map of labels to be applied on the environment config map. | `map(string)` | `{}` | no |
| environment\_secret\_annotations | Map of annotations to be applied on the environment secret. | `map(string)` | `{}` | no |
| environment\_secret\_labels | Map of labels to be applied on the environment secret. | `map(string)` | `{}` | no |
| image | Docker image to use. | `string` | `"docker.io/anchore/anchore-engine"` | no |
| image\_version | Version of the docker image. | `string` | `"v0.8.2"` | no |
| labels | Map of labels to be applied on all resources. | `map(string)` | `{}` | no |
| name\_prefix | Prefix that will be used in resource names. | `string` | `"anchore-engine"` | no |
| namespace | Namespace in which the resources will be deployed. | `string` | `"default"` | no |
| policy\_engine\_annotations | Map of annotations that will be applied on all policy\_engine resources. | `map(string)` | `{}` | no |
| policy\_engine\_deployment\_annotations | Map of annotations that will be applied on all policy\_engine deployment. | `map(string)` | `{}` | no |
| policy\_engine\_deployment\_labels | Map of labels that will be applied on all policy\_engine deployment. | `map(string)` | `{}` | no |
| policy\_engine\_deployment\_template\_annotations | Map of annotations that will be applied on all policy\_engine deployment template. | `map(string)` | `{}` | no |
| policy\_engine\_deployment\_template\_labels | Map of labels that will be applied on all policy\_engine deployment template. | `map(string)` | `{}` | no |
| policy\_engine\_labels | Map of labels that will be applied on all policy\_engine resources. | `map(string)` | `{}` | no |
| policy\_engine\_service\_annotations | Map of annotations that will be applied on all policy\_engine service. | `map(string)` | `{}` | no |
| policy\_engine\_service\_labels | Map of labels that will be applied on all policy\_engine service. | `map(string)` | `{}` | no |
| simplequeue\_annotations | Map of annotations that will be applied on all simplequeue resources. | `map(string)` | `{}` | no |
| simplequeue\_deployment\_annotations | Map of annotations that will be applied on all simplequeue deployment. | `map(string)` | `{}` | no |
| simplequeue\_deployment\_labels | Map of labels that will be applied on all simplequeue deployment. | `map(string)` | `{}` | no |
| simplequeue\_deployment\_template\_annotations | Map of annotations that will be applied on all simplequeue deployment template. | `map(string)` | `{}` | no |
| simplequeue\_deployment\_template\_labels | Map of labels that will be applied on all simplequeue deployment template. | `map(string)` | `{}` | no |
| simplequeue\_labels | Map of labels that will be applied on all simplequeue resources. | `map(string)` | `{}` | no |
| simplequeue\_service\_annotations | Map of annotations that will be applied on all simplequeue service. | `map(string)` | `{}` | no |
| simplequeue\_service\_labels | Map of labels that will be applied on all simplequeue service. | `map(string)` | `{}` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Versioning

This repository follows [Semantic Versioning 2.0.0](https://semver.org/)

## Commit Messages

This repository follows the [AFCMF](https://github.com/FXinnovation/fx-pre-commit-afcmf) commit message conventions.

## Git Hooks

This repository uses [pre-commit](https://pre-commit.com/) hooks.

### Usage

```
pre-commit install
pre-commit install -t commit-msg
```

## Changelog

This repository uses the `git-extras` package to generate the changelog file.

### Uage

```
git changelog -a -t x.y.z -p
```
