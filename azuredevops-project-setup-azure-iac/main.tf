terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}
provider "azuredevops" {
}

# Create project
module "project" {
  source = "../azuredevops-project-initial"

  project_name                 = "Azure Infrastructure Test"
  project_description          = "Project containing all source code of a corporations's multi-subscription multi-team Azure environment"
  project_work_item_template   = "Basic"
  project_feature_boards       = "enabled"
  project_feature_repositories = "enabled"
  project_feature_pipelines    = "enabled"
  project_feature_testplans    = "disabled"
  project_feature_artifacts    = "enabled"
  endpoint_registry_config = [{
    name     = "registry1-service-endpoint"
    url      = "test.azureacr.io"
    username = "test"
    password = "test"
  }]
}

# Project level git permissions
data "azuredevops_group" "project_group_reader" {
  project_id = module.project.project_id
  name       = "Readers"
}
resource "azuredevops_git_permissions" "project-git-root-permissions" {
  project_id = module.project.project_id
  principal  = data.azuredevops_group.project_group_reader.id
  permissions = {
    # in addition to default Org-wide Readers permissions allow:
    CreateBranch = "Allow"
  }
}

module "platform_connectivity" {
  source = "../azuredevops-azure-iac-configuration"

  project_id                   = module.project.project_id
  project_name                 = module.project.project_name
  name                         = "Platform Connectivity"
  terraform_setup_team_members = [] # empty for demo
  var_arm_client_id            = "ToDo"
  var_arm_client_secret        = "ToDo"
  var_storage_account_secret   = "ToDo"
}

module "landingzone_containerplatform" {
  source = "../azuredevops-azure-iac-configuration"

  project_id                   = module.project.project_id
  project_name                 = module.project.project_name
  name                         = "LandingZone ContainerPlatform"
  terraform_setup_team_members = [] # empty for demo
  var_arm_client_id            = "ToDo"
  var_arm_client_secret        = "ToDo"
  var_storage_account_secret   = "ToDo"
}