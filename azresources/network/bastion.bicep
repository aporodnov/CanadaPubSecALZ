// ----------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
//
// THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, 
// EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES 
// OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
// ----------------------------------------------------------------------------------

@description('Azure Bastion Name')
param name string

@description('Key/Value pair of tags.')
param tags object = {}

// Networking
@description('Subnet Resource Id.')
param subnetId string

resource bastionPublicIP 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  location: resourceGroup().location
  name: '${name}PublicIp'
  tags: tags
  sku: {
      name: 'Standard'
  }
  properties: {
      publicIPAddressVersion: 'IPv4'
      publicIPAllocationMethod: 'Static'
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2020-06-01' = {
  location: resourceGroup().location
  name: name
  tags: tags
  properties: {
      dnsName: uniqueString(resourceGroup().id)
      ipConfigurations: [
          {
              name: 'IpConf'
              properties: {
                  subnet: {
                      id: subnetId
                  }
                  publicIPAddress: {
                      id: bastionPublicIP.id
                  }
              }
          }
      ]
  }
}