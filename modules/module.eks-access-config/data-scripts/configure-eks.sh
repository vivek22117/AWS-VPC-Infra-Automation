#!/usr/bin/env bash


echo 'Applying Auth ConfigMap with kubectl...'

aws s3 cp s3://${artifactory_bucket_name}/deploy/eks/config-auth.yaml . --region ${default_region}

aws eks update-kubeconfig --name=${cluster_name} --region=${default_region} --kubeconfig=${kubeconfig_path}

kubectl version --kubeconfig ${kubeconfig_path}

kubectl apply -f ${configmap_auth_file} --kubeconfig ${kubeconfig_path}

echo 'Applied Auth ConfigMap with kubectl'