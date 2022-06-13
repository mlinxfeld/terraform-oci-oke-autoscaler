
output "cluster_instruction" {
value = <<EOT
1.  Open OCI Cloud Shell.

2.  Execute below command to setup OKE cluster access:

$ oci ce cluster create-kubeconfig --region ${var.region} --cluster-id ${oci_containerengine_cluster.FoggyKitchenOKECluster.id}

3.  Obtain a high-level view of the Kubernetes Cluster Autoscaler's state from the configmap in the kube-system namespace, by entering:

$ kubectl -n kube-system get cm cluster-autoscaler-status -oyaml

4.  Identify which one of the three Kubernetes Cluster Autoscaler pods defined in the cluster-autoscaler.yaml file is currently performing actions, by:

$ kubectl -n kube-system get lease

5.  View the Kubernetes Cluster Autoscaler logs to confirm that it was successfully deployed and is currently monitoring the workload of node pools in the cluster, by:

$ kubectl -n kube-system logs -f deployment.apps/cluster-autoscaler
EOT
}