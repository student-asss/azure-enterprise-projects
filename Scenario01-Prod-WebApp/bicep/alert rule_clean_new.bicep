param alertRuleName string
param appInsightsId string
param actionGroupId string

resource smartDetector 'Microsoft.AlertsManagement/smartDetectorAlertRules@2021-04-01' = {
  name: alertRuleName
  location: 'global'
  properties: {
    description: 'Failure Anomalies notifies you of an unusual rise in failed HTTP requests or dependency calls.'
    state: 'Enabled'
    severity: 'Sev3'
    frequency: 'PT1M'
    detector: {
      id: 'FailureAnomaliesDetector'
    }
    scope: [
      appInsightsId
    ]
    actionGroups: {
      groupIds: [
        actionGroupId
      ]
    }
  }
}
