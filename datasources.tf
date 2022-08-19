data "oci_identity_region_subscriptions" "home_region_subscriptions" {
  tenancy_id = var.tenancy_ocid

  filter {
    name   = "is_home_region"
    values = [true]
  }
}

data "oci_containerengine_cluster_option" "FoggyKitchenOKEClusterOption" {
  provider          = oci.targetregion
  cluster_option_id = "all"
}

data "oci_containerengine_node_pool_option" "FoggyKitchenOKEClusterNodePoolOption" {
  provider            = oci.targetregion
  node_pool_option_id = "all"
}

# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  provider       = oci.targetregion
  compartment_id = var.tenancy_ocid
}

data "oci_core_services" "FoggyKitchenAllOCIServices" {
  provider       = oci.targetregion

  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

data "template_file" "autoscaler_deployment" {

  template = "${file("${path.module}/templates/autoscaler.template.yaml")}"
  vars     = {
      autoscaler_image = "${lookup(local.autoscaler_image, var.kubernetes_version)}"
      min_nodes        = "${var.min_number_of_nodes}"
      max_nodes        = "${var.max_number_of_nodes}"
      node_pool_id     = "${oci_containerengine_node_pool.FoggyKitchenOKENodePool.id}"
  }
}
