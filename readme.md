# Terraform Heroku
A configuration file for Terraform to provision infrastruture on Heroku. **Note** this configuration will provision add-ons that cost money.

## Variables
The following variables are used `app_name` and `app_region`.
- `app_name` is used to name the two apps and the pipeline.
- `app_region` is the region the apps with be provisioned in. The choices are "eu" or "us".

## Apps
The two apps are provisioned, a staging app and a production app. The two apps are coupled together using a pipeline.

### Staging
The staging app will be called `${var.app_name}-staging` and is made up of the following
- Add-ons
  - Heroku Redis (Hobby Dev - Free)
  - Heroku Postgres (Hobby Dev - Free)
- Config variables
  - ENVIRONMENT = "staging"
- Buildpacks
  - "heroku/python"

### Production
The staging app will be called `${var.app_name}-production` and is made up of the following
- Add-ons
  - Heroku Redis (Premium 0 - $15/mo)
  - Heroku Postgres (Hobby Dev - $9/mo)
- Config variables
  - ENVIRONMENT = "production"
- Buildpacks
  - "heroku/python"

## Usage
Once you have set your Heroku credentials, use Terraform and this configuration to install the Heroku provider and then provision you infrastructure.
```
terraform init
```
```
terraform apply -var "app_name=the-name-of-my-app" -var "app_region=eu"
```
**Note** this configuration will provision add-ons that cost money.
