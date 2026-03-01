resource "azurerm_monitor_data_collection_rule" "dcr" {
  name                = "dcr-s07-deployments"
  location            = var.location
  resource_group_name = var.resource_group_name

  destinations {
    log_analytics {
      workspace_resource_id = var.log_analytics_id
      name                  = "la"
    }
  }

  data_flow {
    streams      = ["Custom-DeploymentEvents"]
    destinations = ["la"]
  }

  data_sources {
    custom_logs {
      name          = "deployment_events"
      stream        = "Custom-DeploymentEvents"
      format        = "json"
      sample_data   = "{\"DeploymentId\":\"00000000-0000-0000-0000-000000000000\",\"AppName\":\"sample\",\"Environment\":\"dev\",\"Pipeline\":\"API CD\",\"Status\":\"Success\",\"DeployedBy\":\"GitHub\",\"Version\":\"1.0.0\"}"
    }
  }
}

resource "azurerm_log_analytics_custom_table" "table" {
  name                = "DeploymentEvents_CL"
  resource_group_name = var.resource_group_name
  workspace_name      = split("/", var.log_analytics_id)[8]
  plan                = "Analytics"

  schema_json = jsonencode({
    columns = [
      { name = "DeploymentId_g", type = "guid" },
      { name = "AppName_s",      type = "string" },
      { name = "Environment_s",  type = "string" },
      { name = "Pipeline_s",     type = "string" },
      { name = "Status_s",       type = "string" },
      { name = "DeployedBy_s",   type = "string" },
      { name = "Version_s",      type = "string" }
    ]
  })
}

