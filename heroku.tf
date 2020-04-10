provider "heroku" {
  version = "~> 2.0"
}


variable "app_name" {
  description = "Name of the Heroku app provisioned"
}
variable "app_region" {
  description = "Region the app is provisioned in"
}


resource "heroku_app" "staging" {
  name   = "${var.app_name}-test"
  region = var.app_region
  buildpacks = [
    "heroku/python",
  ]
  config_vars = {
    ENVIRONMENT = "staging"
  }
}
# Create a redis, and configure the app to use it
resource "heroku_addon" "redis-staging" {
  app  = heroku_app.staging.name
  plan = "heroku-redis:hobby-dev"
}
# Create a redis, and configure the app to use it
resource "heroku_addon" "redis-production" {
  app  = heroku_app.production.name
  plan = "heroku-redis:hobby-dev"
}


resource "heroku_app" "production" {
  name   = "${var.app_name}-live"
  region = var.app_region
  buildpacks = [
    "heroku/python",
  ]
  config_vars = {
    ENVIRONMENT = "production"
  }
}
# Create a redis, and configure the app to use it
resource "heroku_addon" "redis-live" {
  app  = heroku_app.production.name
  plan = "heroku-redis:premium-0"
}
# Create a postgresql, and configure the app to use it
resource "heroku_addon" "postgresql-live" {
  app  = heroku_app.production.name
  plan = "heroku-postgresql:hobby-basic"
}


# Create a Heroku pipeline
resource "heroku_pipeline" "pipeline" {
  name = var.app_name
}
# Couple apps staging app to the pipeline
resource "heroku_pipeline_coupling" "staging" {
  app      = heroku_app.staging.name
  pipeline = heroku_pipeline.pipeline.id
  stage    = "staging"
}
# Couple apps production app to the pipeline
resource "heroku_pipeline_coupling" "production" {
  app      = heroku_app.production.name
  pipeline = heroku_pipeline.pipeline.id
  stage    = "production"
}
