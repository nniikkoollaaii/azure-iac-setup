
resource "azuredevops_build_definition" "pipeline" {
  project_id = var.project_id
  name       = "${var.name} Terraform Pipeline"

  #agent_pool_name = "Self Hosted Private Cloud Agent Pool"


  ci_trigger {
    use_yaml = true
  }

# Error: error creating resource Build Definition: The trigger type PullRequest is not valid for the TfsGit repository type.
#   pull_request_trigger {
#     use_yaml       = true
#     initial_branch = azuredevops_git_repository.repo.default_branch
#     forks {
#       enabled       = false
#       share_secrets = false
#     }
#   }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.repo.id
    branch_name = azuredevops_git_repository.repo.default_branch
    yml_path    = "azure-pipeline.yaml"
  }

  variable {
    name         = "ARM_CLIENT_ID"
    secret_value = var.var_arm_client_id
    is_secret    = true
  }
  variable {
    name         = "ARM_CLIENT_SECRET"
    secret_value = var.var_arm_client_secret
    is_secret    = true
  }
  variable {
    name         = "STORAGE_ACCOUNT_SECRET"
    secret_value = var.var_storage_account_secret
    is_secret    = true
  }
}

# resource "azuredevops_build_definition_permissions" "pipeline_project_permissions" {
#   project_id = var.project_id
#   principal  = data.azuredevops_group.project_group_reader.id

#   build_definition_id = azuredevops_build_definition.pipeline.id

#   permissions = {
#     ViewBuilds = "Allow"
#   }
# }

resource "azuredevops_build_definition_permissions" "pipeline_pipeline_permissions" {
  project_id = var.project_id
  principal  = data.azuredevops_group.team_group.id

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