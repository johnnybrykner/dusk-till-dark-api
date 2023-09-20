# frozen_string_literal: true
require "jwt"

module DuskAPI
  module Actions
    module Users
      class Authenticate < DuskAPI::Action
        params do
          required(:username).value(:string)
        end

        def handle(request, response)
          dynamodb_service = DuskAPI::DynamodbService.new
          does_user_exist = dynamodb_service.get_user(request.params[:username])

          response.format = :json

          if does_user_exist
            jwt_service = DuskAPI::JwtService.new
            token = jwt_service.generate_jwt_token(request.params[:username])
            response.headers["Set-Cookie"] = "account_token=#{token}; SameSite=None; Secure; HttpOnly; Partitioned"
            response.status = 200
            response.body = {message: "Successfully authenticated"}.to_json
          else
            response.status = 404
            response.body = {error: "User not found"}.to_json
          end
        end
      end
    end
  end
end
