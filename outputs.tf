output "cluster_id" {
  description = "ID of created cluster"
  value       = "${aws_ecs_cluster.this.id}"
}

output "sg_id" {
  description = "Security group ID for the cluster's instances"
  value       = "${aws_security_group.this.id}"
}
