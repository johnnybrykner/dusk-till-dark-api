# frozen_string_literal: true
require "oj"

module DuskAPI
  module Actions
    module Users
      class Settings < DuskAPI::Action
        params do
          required(:username).value(:string)
          required(:user_settings).filled(DuskAPI::Types::SettingsType)
        end

        def handle(request, response)
          response.format = :json
          if !request.env["jwt_username"]
            response.status = 401
            response.body = {error: "Unauthorized"}.to_json
            return
          end
          halt 422, {error: request.params.errors.to_s}.to_json unless request.params.valid?

          dynamodb_service = DuskAPI::DynamodbService.new
          current_user = dynamodb_service.get_user(request.params[:username])
          halt 404, {error: "User not found"}.to_json unless current_user

          updated_user = dynamodb_service.update_settings(request.params[:username], request.params[:user_settings])
          response.body = Oj.dump(updated_user["attributes"])
        end
      end
    end
  end
end
