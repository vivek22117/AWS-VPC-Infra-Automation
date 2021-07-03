#!/usr/bin/env bash


echo 'Applying Auth ConfigMap with kubectl...'

aws s3 cp s3://${artifactory_bucket_name}/deploy/eks/config-auth.yaml . --region ${default_region}

aws sts assume-role --role-arn ${eks_create_role_arn} --role-session-name Cluster-Config

aws eks update-kubeconfig --name=${cluster_name} --region=${default_region}

kubectl version

kubectl apply -f config-auth.yaml

echo 'Applied Auth ConfigMap with kubectl'