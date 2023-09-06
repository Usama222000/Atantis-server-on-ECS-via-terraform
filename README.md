# Atlantis on AWS ECS

This repository contains Terraform configurations to set up Atlantis, a self-hosted infrastructure as code (IaC) automation tool, on AWS ECS (Elastic Container Service). Atlantis enables automated Terraform workflows within your organization while maintaining version control and collaboration.

### Clone the Repo
Clone the repository from atltis-repo-git-repo-to-be-added.

### AWS Related Inputs:
* subnets: <Lits>  (Fargate Service Subnets)
* security_groups: <List> (Fargate Service Security group)
* ALB_SUBNET_IDS: <List> (Load Balancer Subnets, Must be public)
* ALB_SECURITY_GROUP_IDS: <List> (Load Balancer Security group)
* ALB_VPC_ID: <String> (Your Network VPC ID)
* certificate_arn: <String> (ALB_HTTPS_LISTENERS, Listener certificate arn for https)
* KMS_KEY_ID: <String> (KMS Key ID)
* execution_role_arn: <String>
 
### Atlantis Server Inputs
The following inputs are environment variables of atlantis server for our container definition
* ATLANTIS_ATLANTIS_URL: add a sub-domain for atlantis e.g https://atlantis.scaleops.io/
* ATLANTIS_GH_USER: your github username
* ATLANTIS_GH_TOKEN: your github access token
* ATLANTIS_GH_WEBHOOK_SECRET: Altantis webhook secrets e.g generate a random secertes from https://www.browserling.com/tools/random-string and add the secret value.
* ATLANTIS_REPO_CONFIG_JSON: Convert the file into json string (Atlantis needs repo.yaml file for its server level configuration example file is provided in misc/examples/atlantis/repo.yaml and docs reference https://www.runatlantis.io/docs/repo-level-atlantis-yaml.html)
* ATLANTIS_REPO_ALLOWLIST: Added your repos which you want atlantis to check for Pull request change. e.g `github.com/myorg/*` and incase of personal repo `github.com/akbar-eurus/*`

### Deploying Atlantis Server
After Updating the above variables in vars file of terraform project. Run the following atlantis commands.
Note: Currently we're using only dev.tfvars for deploying atlantis server you can change and create a new file by your own needs.
```
terraform plan -var-file=./config/dev.tfvars
```

Check your plan and verify the changes and apply changes using 
```
terraform apply -var-file=./config/dev.tfvars
```

### Adding WebHook To Github Repo.

Onces the atlantis server is up. Now you have to add webhook to your github repo, Open your repo got to settings -> webhooks
In payload URL: 'https://<atlantis-server-url>/events' e.g https://ltscaleatlantis.groveops.net/events
Content type: 'application/json'
Events to trigger this webhook: Select `Let me select individual events` add the following events (Pull request reviews,Pull requests, Pushes and Issue comments) and save your webhook changes.

Check the status by entering atlantis url `https://ltScaleatlantis.groveops.net` in your browser.
