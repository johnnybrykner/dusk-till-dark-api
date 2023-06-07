require "aws-sdk-dynamodb"
require_relative "../config/initializers/aws"

class DynamoDBService
  def initialize
    @client = Aws::DynamoDB::Client.new
    @table_name = "Users"
  end

  def get_users
    request_params = {
      table_name: @table_name
    }

    @client.scan(request_params).items
  end

  def get_user(username)
    key = { "username" => username }
    request_params = {
      table_name: @table_name,
      key: key
    }

    @client.get_item(request_params).item
  end

  # Other methods for CRUD operations on DynamoDB can be added here
end
