# Azure IaC Setup

Setup IaC to manage your multi-subscription multi-team Azure environment via Azure DevOps

## Scenario 1

You're using a multi-subscription multi-team setup as proposed by the Azure Cloud Adoption Framework.

All of your Azure infrastructure should be managed in Terraform.

You already have defined your Platform- and LandingZone-Subscriptions.

You created one or more ServicePrincipal(s) with the required permissions for each of you Platform/LandingZone-Subscriptions.

### Target Setup

The code should be stored in Git

For easier handling and collaboration the terraform lifecycle should be executed in an Azure Pipeline.

All repos and pipelines are placed next to each other to improve visibility and collobaration. But the setup has to comply with team-boundaries. Only the Platform.Connectivity team is allowed to merge in their repo and manage their pipeline.

## Scenario 2

Setup a project with multipe repos and pipelines for multiple components/services of an application.
See <./azuredevops-project-app>

## Modules

### azuredevops-project-initial

Module for initial setup up of a project

### azuredevops-app-configuration

Module for initial setup up of a project

### azuredevops-azure-iac-configuration

Module for configuring Repos, Pipelines and Teams for permissions management inside a project.


## Commands

    terraform init

    terraform plan -var-file=values.tfvars