# frozen_string_literal: true
require "oj"
require_relative "../../../lib/dynamodb_service"

module DuskAPI
  module Actions
    module Users
      class Show < DuskAPI::Action
        params do
          required(:username).value(:string)
        end

        def handle(request, response)
          dynamodb_service = DynamoDBService.new
          user = dynamodb_service.get_user(request.params[:username])

          puts "user: #{user}"

          response.format = :json
        
          if user
            response.body = Oj.dump(user)
          else
            response.status = 404
            response.body = {error: "not_found"}.to_json
          end
        end
      end
    end
  end
end
