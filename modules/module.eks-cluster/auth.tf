
locals {
  certificate_authority_data_list          = coalescelist(aws_eks_cluster.doubledigit_eks.certificate_authority, [[{ data : "" }]])
  certificate_authority_data_list_internal = local.certificate_authority_data_list[0]
  certificate_authority_data_map           = local.certificate_authority_data_list_internal
  certificate_authority_data               = local.certificate_authority_data_map["data"]

  configmap_auth_template_file = var.configmap_auth_template_file == "" ? join("/", [path.module, "data-script/configmap-auth.yaml.tpl"]) : var.configmap_auth_template_file
  configmap_auth_file          = var.configmap_auth_file == "" ? join("/", [path.module, "data-script/configmap-auth.yaml"]) : var.configmap_auth_file

  cluster_name = aws_eks_cluster.doubledigit_eks.id


  # Add worker nodes role ARNs (could be from many worker groups) to the ConfigMap
  map_worker_roles = [
    for role_arn in tolist([aws_iam_role.dd_eks_nodes_role.arn]) : {
      rolearn : role_arn
      username : "system:node:{{EC2PrivateDNSName}}"
      groups : [
        "system:bootstrappers",
        "system:nodes"
      ]
    }
  ]

  additional_iam_roles = tomap({
    read_only_user : aws_iam_role.eks_read_role.arn
    full_access_user : aws_iam_role.eks_full_access_role.arn
  })

  map_additional_iam_roles = [
    for key, value in local.additional_iam_roles : {
      rolearn : value
      username : key
      groups : [
        "system:master"
      ]
    }
  ]


  map_worker_roles_yaml         = trimspace(yamlencode(local.map_worker_roles))
  map_additional_iam_roles_yaml = trimspace(yamlencode(local.map_additional_iam_roles))
}

data "template_file" "configmap_auth" {
  count    = var.apply_config_map_aws_auth ? 1 : 0
  template = file(local.configmap_auth_template_file)

  vars = {
    map_worker_roles_yaml         = local.map_worker_roles_yaml
    map_additional_iam_roles_yaml = local.map_additional_iam_roles_yaml
  }
}

resource "local_file" "configmap_auth" {
  count = var.apply_config_map_aws_auth ? 1 : 0

  content  = join("", data.template_file.configmap_auth.*.rendered)
  filename = local.configmap_auth_file
}

resource "aws_s3_bucket_object" "artifactory_bucket_object" {
  key                    = "deploy/eks/config-auth.yaml"
  bucket                 = data.terraform_remote_state.vpc.outputs.artifactory_s3_name
  content                = join("", data.template_file.configmap_auth.*.rendered)
  server_side_encryption = "AES256"
}

resource "null_resource" "apply_configmap_auth" {
  count = var.apply_config_map_aws_auth ? 1 : 0

  triggers = {
    cluster_updated                     = join("", aws_eks_cluster.doubledigit_eks.id)
    worker_roles_updated                = local.map_worker_roles_yaml
    additional_roles_updated            = local.map_additional_iam_roles_yaml
    configmap_auth_file_content_changed = join("", local_file.configmap_auth.*.content)
    configmap_auth_file_id_changed      = join("", local_file.configmap_auth.*.id)
  }

  depends_on = [local_file.configmap_auth]

  provisioner "local-exec" {
    interpreter = [var.local_exec_interpreter, "-c"]

    command = <<EOT
      set -e

      echo 'Applying Auth ConfigMap with kubectl...'
      aws eks update-kubeconfig --name=${local.cluster_name} --region=${var.default_region} --kubeconfig=${var.kubeconfig_path} ${var.aws_eks_update_kubeconfig_additional_arguments}
      kubectl version --kubeconfig ${var.kubeconfig_path}
      kubectl apply -f ${local.configmap_auth_file} --kubeconfig ${var.kubeconfig_path}
      echo 'Applied Auth ConfigMap with kubectl'
    EOT
  }
}
