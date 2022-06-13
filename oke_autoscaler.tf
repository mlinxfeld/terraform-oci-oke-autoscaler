resource "oci_identity_tag_namespace" "FoggyKitchenClusterTagNamespace" {
    provider       = oci.homeregion
    compartment_id = var.compartment_ocid
    description    = "Tag namespace for OKE worker nodes"
    name           = "oke-${random_id.tag.hex}"

    provisioner "local-exec" {
      command = "sleep 10"
    }
}

resource "oci_identity_tag" "FoggyKitchenClusterTag" {
    provider         = oci.homeregion
    tag_namespace_id = oci_identity_tag_namespace.FoggyKitchenClusterTagNamespace.id
    description      = "Tag to identify worker nodes in the OKE cluster"
    name             = "autoscaler"

    provisioner "local-exec" {
      command = "sleep 120"
    }
}

resource "local_file" "autoscaler_deployment" {
  content  = data.template_file.autoscaler_deployment.rendered
  filename = "${path.module}/autoscaler.yaml"
}

resource "null_resource" "deploy_oke_autoscaler" {
  depends_on = [
  oci_containerengine_cluster.FoggyKitchenOKECluster, 
  oci_containerengine_node_pool.FoggyKitchenOKENodePool, 
  local_file.autoscaler_deployment]

  provisioner "local-exec" {
    command = "oci ce cluster create-kubeconfig --region ${var.region} --cluster-id ${oci_containerengine_cluster.FoggyKitchenOKECluster.id}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.autoscaler_deployment.filename}"
  }

  provisioner "local-exec" {
    command = "sleep 120"
  }

  provisioner "local-exec" {
    command = "kubectl -n kube-system get cm cluster-autoscaler-status -oyaml"
  }
}