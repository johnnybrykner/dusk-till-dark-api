# frozen_string_literal: true
require "oj"

module DuskAPI
  module Actions
    module Users
      class Show < DuskAPI::Action
        params do
          required(:username).value(:string)
        end

        def handle(request, response)
          response.format = :json
          if request.env["jwt_username"] != request.params[:username]
            response.status = 401
            response.body = {error: "Unauthorized"}.to_json
            return
          end

          dynamodb_service = DuskAPI::DynamodbService.new
          user = dynamodb_service.get_user(request.params[:username])

          if user
            response.body = Oj.dump(user)
          else
            response.status = 404
            response.body = {error: "User not found"}.to_json
          end
        end
      end
    end
  end
end
