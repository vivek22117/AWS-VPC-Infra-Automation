{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "S3BucketLogicalName": {
      "Type": "AWS::S3::Bucket",
      "Properties": {
        "BucketName": "${s3_bucket_name}",
        "ReplicationConfiguration": {
          "Role": "${role_arn}",
          "Rules": [
            {
              "Id": "Backup",
              "Priority": 0,
              "Status": "Enabled",
              "Filter": {},
              "DeleteMarkerReplication": {
                "Status" : "Enabled"
              },
              "Destination": {
                "Bucket": {
                  "Fn::Join": [
                    "",
                    [
                      "arn:aws:s3:::",
                      {
                        "Fn::Join": [
                          "-",
                          [
                            "sandbox-lnfos-backup-imdb",
                            "${aws_region}"
                          ]
                        ]
                      }
                    ]
                  ]
                },
                "ReplicationTime": {
                  "Status" : "Enabled",
                  "Time": {
                    "Minutes": 15
                  }
                },
                "Metrics": {
                  "EventThreshold" : {
                    "Minutes": 15
                  },
                  "Status" : "Enabled"
                },
                "StorageClass": "STANDARD"
              }
            }
          ]
        },
        "VersioningConfiguration": {
          "Status": "Enabled"
        }
      }
    }
  },
  "Outputs": {
    "S3BucketName": {
      "Description": "Bucket name",
      "Value": {
        "Ref": "S3BucketLogicalName"
      }
    }
  }
}
