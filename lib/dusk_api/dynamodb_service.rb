require "aws-sdk-dynamodb"
require_relative "../../config/initializers/aws"

module DuskAPI
  class DynamodbService
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

    def add_film(username, list_name, film_to_add)
      puts "Adding #{film_to_add} to #{list_name} for #{username}"
      key = { "username" => username }
      request_params = {
        table_name: @table_name,
        key: key,
        return_values: "ALL_NEW",
        update_expression: "SET #watch_list = list_append(if_not_exists(#watch_list, :empty_list), :to_add)",
        expression_attribute_names: {
          "#watch_list": list_name,
        },
        expression_attribute_values: {
          ":to_add": [film_to_add],
          ":empty_list": [],
        },
      }

      @client.update_item(request_params)
    end

    def remove_film(username, list_name, position_to_remove)
      puts "Removing [#{position_to_remove}] from #{list_name} for #{username}"
      key = { "username" => username }
      request_params = {
        table_name: @table_name,
        key: key,
        return_values: "ALL_NEW",
        update_expression: "REMOVE #watch_list[#{position_to_remove}]",
        expression_attribute_names: {
          "#watch_list": list_name,
        },
      }

      @client.update_item(request_params)
    end
  end
end
