eks_asg_name := `terraform output -json | jq -r '.eks_node_group_asg_name.value'`

eks-scale-to capacity:
  aws autoscaling set-desired-capacity --auto-scaling-group-name "{{eks_asg_name}}" --desired-capacity={{capacity}}
