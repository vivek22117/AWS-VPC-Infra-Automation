#!/usr/bin/env bash


echo "Deleting EC2....."

aws ec2 terminate-instances --instance-ids <INSTANCE_ID> --region us-east-1 --profile admin