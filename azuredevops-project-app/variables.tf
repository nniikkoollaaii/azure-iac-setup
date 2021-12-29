variable "project_name" {
  description = "Name of the Azure DevOps project"
  type        = string
}
variable "project_description" {
  description = "Description of the Azure DevOps project"
  type        = string
}
variable "project_visibility" {
  description = "Visibility of the Azure DevOps project"
  type        = string
}
variable "project_work_item_template" {
  description = "work_item_template of the Azure DevOps project"
  type        = string
  #  # https://docs.microsoft.com/en-us/azure/devops/boards/work-items/guidance/choose-process?view=azure-devops&tabs=basic-process#main-distinctions-among-the-default-processes
}
variable "project_feature_boards" {
  description = "Enable the feature \"Boards\""
  type        = string
  default     = true
}
variable "project_feature_repositories" {
  description = "Enable the feature \"Repositories\""
  type        = string
  default     = true
}
variable "project_feature_pipelines" {
  description = "Enable the feature \"Pipelines\""
  type        = string
  default     = true
}
variable "project_feature_testplans" {
  description = "Enable the feature \"Testplans\""
  type        = string
  default     = true
}
variable "project_feature_artifacts" {
  description = "Enable the feature \"Artifacts\""
  type        = string
  default     = true
}


variable "group_members" {
  description = "Group members"
  type        = list(string)
  default     = []
}


variable "endpoint_registry_config" {
  description = "Configuration for service endpoints for ACRs"
  type        = list(object({ name = string, url = string, username = string, password = string }))
  default     = []
}



