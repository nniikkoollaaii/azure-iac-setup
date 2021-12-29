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

# create team for this setup
resource "azuredevops_team" "team" {
  project_id = var.project_id
  name       = "${var.name} Team"
  # administrators = []
  members = var.terraform_setup_team_members
}
# group automatically created for the team above -> use the group to assign permissions
data "azuredevops_group" "team_group" {
  project_id = var.project_id
  name       = "${azuredevops_team.team.name}"
  depends_on = [
    azuredevops_team.team
  ]
}

# add created team to project-wide "Reader" group"
data "azuredevops_group" "project_group_reader" {
  project_id = var.project_id
  name       = "Readers"
}
resource "azuredevops_group_membership" "project_group_reader_membership" {
  group = data.azuredevops_group.project_group_reader.id
  members = [
    data.azuredevops_group.team_group.descriptor
  ]
}