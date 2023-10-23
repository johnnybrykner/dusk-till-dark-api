# frozen_string_literal: true
require "jwt"
require "oj"

module DuskAPI
  module Actions
    module Users
      module Authenticate
        class Index < DuskAPI::Action
          params do
            required(:username).value(:string)
          end

          def handle(request, response)
            dynamodb_service = DuskAPI::DynamodbService.new
            authenticated_user = dynamodb_service.get_user(request.params[:username])

            response.format = :json

            if authenticated_user
              jwt_service = DuskAPI::JwtService.new
              token = jwt_service.generate_jwt_token(request.params[:username])
              response.headers["Set-Cookie"] = "account_token=#{token}; SameSite=None; Path=/dusk_api/users; Secure; HttpOnly; Partitioned"
              response.status = 200
              response.body = Oj.dump(authenticated_user)
            else
              response.status = 404
              response.body = {error: "User not found"}.to_json
            end
          end
        end
      end
    end
  end
end
