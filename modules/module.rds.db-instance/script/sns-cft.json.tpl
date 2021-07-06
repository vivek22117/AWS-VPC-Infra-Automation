{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources" : {
    "EmailSNSTopicForReminder": {
      "Type" : "AWS::SNS::Topic",
      "Properties" : {
        "TopicName": "${sns_topic_name}",
        "DisplayName" : "${display_name}",
        "Subscription": [
          ${subscriptions}
        ]
      }
    }
  },
  "Outputs" : {
    "SNSARN" : {
      "Description" : "Email SNS Topic ARN",
      "Value" : { "Ref" : "EmailSNSTopicForReminder" }
    }
  }
}