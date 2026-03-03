param metricAlerts_high_traffic_alert_name string
param sites_webapp_s01_prod_externalid string

resource metricAlerts_high_traffic_alert_name_resource 'microsoft.insights/metricAlerts@2018-03-01' = {
  name: metricAlerts_high_traffic_alert_name
  location: 'global'
  properties: {
    severity: 3
    enabled: true
    scopes: [
      sites_webapp_s01_prod_externalid
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          threshold: json('100')
          name: 'Metric1'
          metricNamespace: 'Microsoft.Web/sites'
          metricName: 'Requests'
          operator: 'GreaterThan'
          timeAggregation: 'Total'
          skipMetricValidation: false
          criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    autoMitigate: true
    targetResourceType: 'Microsoft.Web/sites'
    targetResourceRegion: 'swedencentral'
    actions: []
  }
}
