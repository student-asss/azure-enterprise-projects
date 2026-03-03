param actionGroupName string
param shortName string
param emailAddress string

resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: actionGroupName
  location: 'global'
  properties: {
    groupShortName: shortName
    enabled: true
    emailReceivers: [
      {
        name: 'defaultEmail'
        emailAddress: emailAddress
        useCommonAlertSchema: true
      }
    ]
  }
}
