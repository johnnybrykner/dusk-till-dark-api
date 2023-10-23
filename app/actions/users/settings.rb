# frozen_string_literal: true
require "oj"

module DuskAPI
  module Actions
    module Users
      class Settings < DuskAPI::Action
        params do
          required(:streaming_countries).array(:hash) do
            required(:country_code).filled(:string)
            required(:country_name).filled(:string)
          end
          required(:streaming_providers).array(:hash) do
            required(:provider_id).filled(:integer)
            required(:provider_name).filled(:string)
            optional(:logo_path).value(:string)
          end
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
          current_user = dynamodb_service.get_user(request.env["jwt_username"])
          halt 404, {error: "User not found"}.to_json unless current_user

          updated_user = dynamodb_service.update_settings(
            request.env["jwt_username"], {
              "streaming_countries" => request.params[:streaming_countries],
              "streaming_providers" => request.params[:streaming_providers],
            }
          )
          response.body = Oj.dump(updated_user["attributes"])
        end
      end
    end
  end
end
