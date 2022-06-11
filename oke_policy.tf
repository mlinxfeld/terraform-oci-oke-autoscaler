resource "random_id" "tag" {
  byte_length = 2
}

resource "oci_identity_dynamic_group" "FoggyKitchenInstancePrincipalDynamicGroup" {
  provider       = oci.homeregion
  compartment_id = var.tenancy_ocid
  description    = "Dynamic Group for OKE Nodes/OKE Cluster"
  matching_rule  = "ALL {instance.compartment.id = '${var.compartment_ocid}', tag.oke-${random_id.tag.hex}.autoscaler.value = 'true'}"
  name           = "FoggyKitchenInstancePrincipalDynamicGroup-${random_id.tag.hex}"
}

resource "oci_identity_policy" "FoggyKitchenOKEClusterAutoscalerPolicy1" {
  provider       = oci.homeregion
  compartment_id = var.compartment_ocid
  description    = "Policy to enable OKE Cluster Autoscaler (Instances)"
  name           = "FoggyKitchenOKEClusterAutoscalerPolicy1-${random_id.tag.hex}"
  statements     = [
    "Allow dynamic-group ${oci_identity_dynamic_group.FoggyKitchenInstancePrincipalDynamicGroup.name} to manage cluster-node-pools in compartment ${oci_identity_compartment.FoggyKitchenCompartment.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.FoggyKitchenInstancePrincipalDynamicGroup.name} to manage instance-family in compartment ${oci_identity_compartment.FoggyKitchenCompartment.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.FoggyKitchenInstancePrincipalDynamicGroup.name} to use subnets in compartment ${oci_identity_compartment.FoggyKitchenCompartment.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.FoggyKitchenInstancePrincipalDynamicGroup.name} to use vnics in compartment ${oci_identity_compartment.FoggyKitchenCompartment.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.FoggyKitchenInstancePrincipalDynamicGroup.name} to inspect compartments in compartment ${oci_identity_compartment.FoggyKitchenCompartment.name}"
  ]
}

resource "oci_identity_policy" "FoggyKitchenOKEClusterAutoscalerPolicy2" {
  provider       = oci.homeregion
  compartment_id = var.compartment_ocid
  description    = "Policy to enable OKE Cluster Autoscaling (Networking)"
  name           = "FoggyKitchenOKEClusterAutoscalerPolicy2-${random_id.tag.hex}"
  statements     = [
    "Allow dynamic-group ${oci_identity_dynamic_group.FoggyKitchenInstancePrincipalDynamicGroup.name} to use subnets in compartment ${oci_identity_compartment.FoggyKitchenCompartment.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.FoggyKitchenInstancePrincipalDynamicGroup.name} to read virtual-network-family in compartment ${oci_identity_compartment.FoggyKitchenCompartment.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.FoggyKitchenInstancePrincipalDynamicGroup.name} to use vnics in compartment ${oci_identity_compartment.FoggyKitchenCompartment.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.FoggyKitchenInstancePrincipalDynamicGroup.name} to inspect compartments in compartment ${oci_identity_compartment.FoggyKitchenCompartment.name}"
  ]
}
