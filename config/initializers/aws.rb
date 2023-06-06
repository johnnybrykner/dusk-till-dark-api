require "aws-sdk-dynamodb"

Aws.config.update({
  region: "eu-north-1",
  credentials: Aws::Credentials.new("AKIAS6PSICKY6MTS42PS", Hanami.app["settings"].dynamo_db_secret)
})
