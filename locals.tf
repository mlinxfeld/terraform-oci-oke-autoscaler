locals {

  compute_flexible_shapes = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex",
    "VM.Standard.A1.Flex",
    "VM.Optimized3.Flex"
  ]

  compute_arm_shapes = [
    "VM.Standard.A1.Flex"
  ]

  is_flexible_node_shape                  = contains(local.compute_flexible_shapes, var.oke_node_shape)
  is_arm_node_shape                       = contains(local.compute_arm_shapes, var.oke_node_shape)  
  
  http_port_number                        = "80"
  https_port_number                       = "443"
  oke_api_endpoint_port_number            = "6443"
  oke_nodes_to_control_plane_port_number  = "12250"
  ssh_port_number                         = "22"
  tcp_protocol_number                     = "6"
  icmp_protocol_number                    = "1"
  all_protocols                           = "all"

  # List with supported autoscaler images: https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengusingclusterautoscaler.htm
  autoscaler_image = {
    "v1.22.5" = "fra.ocir.io/oracle/oci-cluster-autoscaler:1.22.2-4",
    "v1.23.4" = "fra.ocir.io/oracle/oci-cluster-autoscaler:1.23.0-4",
    "v1.22.5" = "fra.ocir.io/oracle/oci-cluster-autoscaler:1.22.2-4",
    "v1.23.4" = "fra.ocir.io/oracle/oci-cluster-autoscaler:1.23.0-4",
    "v1.24.1" = "fra.ocir.io/oracle/oci-cluster-autoscaler:1.24.0-5"
  }

  all_sources                = data.oci_containerengine_node_pool_option.FoggyKitchenOKEClusterNodePoolOption.sources
  arm_node_shape             = local.is_arm_node_shape ? "aarch64-" : ""
  kubernetes_version         = substr(var.kubernetes_version,1,6)

  oracle_linux_images        = [
    for source in local.all_sources : source.image_id if length(regexall("Oracle-Linux-${var.oke_node_os_version}-${local.arm_node_shape}.+-OKE-${local.kubernetes_version}-[0-9]+", source.source_name)) > 0
  ]
  #oracle_linux_service_names = [
  #  for source in local.all_sources : source.source_name if length(regexall("Oracle-Linux-${var.oke_node_os_version}-${local.arm_node_shape}.+OKE-${local.kubernetes_version}-*", source.source_name)) > 0
  #]
}