apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    ${indent(4, map_worker_roles_yaml)}
%{if map_additional_iam_roles_yaml != "[]" }
    ${indent(4, map_additional_iam_roles_yaml)}
%{ endif }

