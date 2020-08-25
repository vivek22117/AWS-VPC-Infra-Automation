#!/usr/bin/env bash


echo "Install Java8"
sudo yum remove -y java
sudo yum install -y java-1.8.0-openjdk


echo "Install SSM-Agent"
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent


echo "Install AWS Cli & kubectl & eks & docker"
sudo yum update -y
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip  awscli-bundle.zip
sudo  ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws