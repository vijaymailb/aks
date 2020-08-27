provider "azurerm" {
  version = "2.13.0"

  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "imageRG"
  location = "eastus"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name       = "gssck8slab"
  location   = azurerm_resource_group.rg.location
  dns_prefix = "gssck8slab"

  resource_group_name = azurerm_resource_group.rg.name
  kubernetes_version  = "1.18.4"

  default_node_pool {
    name            = "aks"
    node_count      = "1"
    vm_size         = "Standard_B2s"
    os_disk_size_gb = "32"
  }

  identity {
    type = "SystemAssigned"
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.cluster.kube_config_raw
}
