param location string

module policy 'modules/firewall-policy.bicep' = {
  name: 'firewallPolicy'
  params: {
    location: location
  }
}
