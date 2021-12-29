terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}

# Create project
resource "azuredevops_project" "project" {
  name               = var.project_name
  description        = var.project_description
  visibility         = "private"
  version_control    = "Git"
  work_item_template = var.project_work_item_template

  features = {
    "boards"       = var.project_feature_boards
    "repositories" = var.project_feature_repositories
    "pipelines"    = var.project_feature_pipelines
    "testplans"    = var.project_feature_testplans
    "artifacts"    = var.project_feature_artifacts
  }
}

# other docker registry service connection
resource "azuredevops_serviceendpoint_dockerregistry" "endpoint_registry" {
  #for_each   = {
  #  for index, config in var.endpoint_registry_config:
  #  index => config.name
  #}
  for_each = toset(keys({ for i, r in var.endpoint_registry_config : i => r }))

  project_id            = azuredevops_project.project.id
  service_endpoint_name = var.endpoint_registry_config[each.value]["name"]
  docker_registry       = var.endpoint_registry_config[each.value]["url"]
  docker_username       = var.endpoint_registry_config[each.value]["username"]
  docker_password       = var.endpoint_registry_config[each.value]["password"]
  registry_type         = "Others"
}

resource "azuredevops_resource_authorization" "endpoint_registry_authz" {
  for_each = azuredevops_serviceendpoint_dockerregistry.endpoint_registry

  project_id  = azuredevops_project.project.id
  resource_id = each.value.id
  # definition_id
  authorized = true
}