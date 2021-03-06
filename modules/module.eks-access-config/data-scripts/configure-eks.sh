#!/usr/bin/env bash



sudo yum install jq -y


cd tmp/

echo 'Applying Auth ConfigMap with kubectl...'

aws s3 cp s3://${artifactory_bucket_name}/deploy/eks/config-auth.yaml . --region ${default_region}

TEMP=$(aws sts assume-role --role-arn ${eks_create_role_arn} --role-session-name Cluster-Config)
aws configure set profile.eks-creator.aws_access_key $(echo $TEMP | jq -r .Credentials.AccessKeyId)
aws configure set profile.eks-creator.aws_secret_access_key $(echo $TEMP | jq -r .Credentials.SecretAccessKey)
aws configure set profile.eks-creator.aws_session_token $(echo $TEMP | jq -r .Credentials.SessionToken)
aws configure set profile.eks-creator.region ${default_region}


aws eks update-kubeconfig --name=${cluster_name} --region=${default_region} --role-arn ${eks_create_role_arn}

kubectl apply -f config-auth.yaml

echo 'Applied Auth ConfigMap with kubectl'