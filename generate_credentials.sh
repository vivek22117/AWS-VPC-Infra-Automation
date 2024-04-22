#!/bin/bash

profile_name='eks-admin'
token_duration="28800"
role_arn='arn:aws:iam::308201090432:role/eks-creator'

STS=$(aws sts assume-role --role-arn $role_arn --role-session-name TF-Session --duration-seconds $token_duration --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' --output text --profile eks)

AWS_KEY=$(echo $STS | awk '{print $1}')
AWS_SECRET=$(echo $STS | awk '{print $2}')
AWS_TOKEN=$(echo $STS | awk '{print $3}')

aws configure set profile.eks-admin.aws_access_key_id $AWS_KEY
aws configure set profile.eks-admin.aws_secret_access_key $AWS_SECRET
aws configure set profile.eks-admin.aws_session_token $AWS_TOKEN
aws configure set profile.eks-admin.region us-east-1