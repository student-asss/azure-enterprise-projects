param alertName string
param appServiceId string
param threshold int = 100

resource metricAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: alertName
  location: 'global'
  properties: {
    severity: 3
    enabled: true
    scopes: [
      appServiceId
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: 'HighRequests'
          metricNamespace: 'Microsoft.Web/sites'
          metricName: 'Requests'
          operator: 'GreaterThan'
          threshold: threshold
          timeAggregation: 'Total'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
    }
    autoMitigate: true
    targetResourceType: 'Microsoft.Web/sites'
  }
}
