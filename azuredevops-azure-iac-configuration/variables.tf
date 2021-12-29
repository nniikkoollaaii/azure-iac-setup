variable "project_name" {
  description = "Name of the Azure DevOps project"
  type        = string
}
variable "project_id" {
  description = "ID of the Azure DevOps project"
  type        = string
}

variable "name" {
  description = "Name used throughout this module for the Team, Repo and Pipeline"
  type        = string
}

variable "terraform_setup_team_members" {
  description = "IDs of members of the created team"
  type        = list(string)
}

variable "var_arm_client_id" {
  description = "Azure pipeline variable value for the Terraform ServicePrincipal ID"
  type        = string
}

variable "var_arm_client_secret" {
  description = "Azure pipeline variable value for the Terraform ServicePrincipal Secret"
  type        = string
}

variable "var_storage_account_secret" {
  description = "Azure pipeline variable value for the storage account secret where to save the terraform state inside the created pipeline"
  type        = string
}



