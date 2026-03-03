# Scenario 1 – Implementation Notes

## What I created
- Resource Group
- Virtual Network (10.0.0.0/16)
- Subnet (10.0.1.0/24)
- NSG with HTTP/HTTPS rules
- App Service Plan (Free tier)
- Web App
- Application Insights
- Alert Rule

## Issues I faced
- Web App name must be globally unique
- NSG rule priorities cannot overlap
- App Insights region must match Web App region
- Free tier App Service has limited metrics

## What I learned
- How to structure a basic production-style environment
- How NSG rules work and how they affect traffic
- How App Service Plans determine performance and features
- How to enable monitoring and alerts in Azure
- How to organize a cloud project in GitHub
