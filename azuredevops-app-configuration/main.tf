terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}

locals {
  name_replaced = replace(var.name, " ", ".")
}

# Define Git repo
resource "azuredevops_git_repository" "repo" {
  project_id = var.project_id
  name       = local.name_replaced

  initialization {
    init_type = "Clean"
  }
}

resource "azuredevops_build_definition" "pipeline" {
  project_id = var.project_id
  name       = "${var.name} Terraform Pipeline"

  agent_pool_name = "Self Hosted Private Cloud Agent Pool"


  ci_trigger {
    use_yaml = true
  }

  pull_request_trigger {
    use_yaml       = true
    initial_branch = azuredevops_git_repository.repo.default_branch
    forks {
      enabled       = false
      share_secrets = false
    }

  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.repo.id
    branch_name = azuredevops_git_repository.repo.default_branch
    yml_path    = "azure-pipeline.yaml"
  }
}


resource "azuredevops_build_definition_permissions" "pipeline_project_permissions" {
  project_id = var.project_id
  principal  = var.project_team_id

  build_definition_id = azuredevops_build_definition.pipeline.id

  permissions = { # analog "Contributor" org-wide group
    ViewBuilds             = "Allow"
    EditBuildQuality       = "Allow"
    RetainIndefinitely     = "Allow"
    DeleteBuilds           = "Allow"
    ManageBuildQualities   = "Allow"
    DestroyBuilds          = "Allow"
    UpdateBuildInformation = "Allow"
    QueueBuilds            = "Allow"
    StopBuilds             = "Allow"
    ViewBuildDefinition    = "Allow"
    EditBuildDefinition    = "Allow"
    DeleteBuildDefinition  = "Allow"
  }
}
