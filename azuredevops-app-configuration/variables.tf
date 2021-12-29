variable "name" {
  description = "Name used in the Git repo and Pipeline definition"
  type        = string
}
variable "project_id" {
  description = "Id of the Azure DevOps project"
  type        = string
}
variable "project_team_id" {
  description = "Id of the team for the Azure DevOps project"
  type        = string
}