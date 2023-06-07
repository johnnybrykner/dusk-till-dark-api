# frozen_string_literal: true
require "oj"

module DuskAPI
  module Actions
    module Users
      class Index < DuskAPI::Action
        def handle(*, response)
          dynamodb_service = DynamoDBService.new
          users = dynamodb_service.get_users

          response.format = :json
          response.body = Oj.dump(users)
        end
      end
    end
  end
end
