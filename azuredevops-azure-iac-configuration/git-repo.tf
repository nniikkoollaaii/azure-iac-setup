# Define Git repo
resource "azuredevops_git_repository" "repo" {
  project_id = var.project_id
  name       = local.name_replaced

  initialization {
    init_type = "Clean"
  }
}

locals {
    repo_init_path = "${path.module}/repo_init"
}

# fill git repo with inital terraform files from template dir "repo_init/"
resource "azuredevops_git_repository_file" "repo_file" {
  for_each = fileset(local.repo_init_path, "*")

  repository_id       = azuredevops_git_repository.repo.id
  file                = each.key
  content             = file("${local.repo_init_path}/${each.value}")
  branch              = azuredevops_git_repository.repo.default_branch
  commit_message      = "Initial commit"
  overwrite_on_create = false

  lifecycle {
    ignore_changes = all # Ignore changes after inital creation
  }
}

# Git permissions for the "own" git repo
resource "azuredevops_git_permissions" "project_git_repo_permissions" {
  project_id    = var.project_id
  repository_id = azuredevops_git_repository.repo.id
  principal     = data.azuredevops_group.team_group.id
  permissions = {
    GenericContribute = "Allow"
    CreateBranch = "Allow"
    CreateTag = "Allow"
    PullRequestContribute = "Allow"
  }
}

# Git permissions for the default branch ("main")  int the "own" git repo
resource "azuredevops_git_permissions" "project_git_branch_permissions" {
  project_id    = var.project_id
  repository_id = azuredevops_git_repository.repo.id
  branch_name   = azuredevops_git_repository.repo.default_branch
  principal     = data.azuredevops_group.team_group.id
  permissions = {
    RemoveOthersLocks = "Allow"
    ForcePush         = "Deny" # don't allow changing the commit history on the main branch for auditability
  }
}


# Branch policies

## azuredevops_branch_policy_auto_reviewers

## azuredevops_branch_policy_build_validation
resource "azuredevops_branch_policy_build_validation" "azuredevops_branch_policy_build_validation" {
  project_id = var.project_id

  enabled  = true
  blocking = true

  settings {
    display_name        = "Terraform Plan failed"
    build_definition_id = azuredevops_build_definition.pipeline.id
    valid_duration      = 0
    #filename_patterns =  []

    scope {
      repository_id  = azuredevops_git_repository.repo.id
      repository_ref = azuredevops_git_repository.repo.default_branch
      match_type     = "Exact"
    }
  }
  depends_on = [
    azuredevops_git_repository_file.repo_file
  ]
}

## azuredevops_branch_policy_comment_resolution

## azuredevops_branch_policy_merge_types

## azuredevops_branch_policy_min_reviewers
resource "azuredevops_branch_policy_min_reviewers" "azuredevops_branch_policy_min_reviewers" {
  project_id = var.project_id

  enabled  = true
  blocking = true

  settings {
    reviewer_count                         = 1
    submitter_can_vote                     = false
    last_pusher_cannot_approve             = true
    allow_completion_with_rejects_or_waits = false
    on_push_reset_approved_votes           = true # OR on_push_reset_all_votes = true
    on_last_iteration_require_vote         = false

    scope {
      repository_id  = azuredevops_git_repository.repo.id
      repository_ref = azuredevops_git_repository.repo.default_branch
      match_type     = "Exact"
    }
  }
  depends_on = [
    azuredevops_git_repository_file.repo_file
  ]
}

## azuredevops_branch_policy_status_check

## azuredevops_branch_policy_work_item_linking