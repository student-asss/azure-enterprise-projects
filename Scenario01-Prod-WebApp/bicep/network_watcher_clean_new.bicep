param networkWatcherName string
param location string = resourceGroup().location

resource networkWatcher 'Microsoft.Network/networkWatchers@2024-07-01' = {
  name: networkWatcherName
  location: location
}

