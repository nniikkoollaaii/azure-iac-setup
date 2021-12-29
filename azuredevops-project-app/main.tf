terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}

# Create project
module "project" {
  source = "../azuredevops-project-initial"

  project_name                 = "Application FooBar"
  project_description          = "Project description"
  project_work_item_template   = "Scrum"
  project_feature_boards       = "disabled"
  project_feature_repositories = "enabled"
  project_feature_pipelines    = "enabled"
  project_feature_testplans    = "disabled"
  project_feature_artifacts    = "enabled"
  endpoint_registry_config = [
    {
      name     = "registry1-service-endpoint"
      url      = "test.azureacr.io"
      username = "test"
      password = "test"
    },
    {
      name     = "registry2-service-endpoint"
      url      = "test2.azureacr.io"
      username = "test"
      password = "test"
    }
  ]
}

# Project level git permissions
resource "azuredevops_git_permissions" "project-git-root-permissions" {
  project_id = module.project.project_id
  principal  = module.project.group_id
  permissions = {
    GenericContribute     = "Allow"
    CreateBranch          = "Allow"
    CreateTag             = "Allow"
    PullRequestContribute = "Allow"
  }
}

module "service1" {
  source = "../azuredevops-app-configuration"

  name            = "service1"
  project_id      = module.project.project_id
  project_team_id = module.project.project_team_id
}
module "service2" {
  source = "../azuredevops-app-configuration"

  name            = "service2"
  project_id      = module.project.project_id
  project_team_id = module.project.project_team_id
}