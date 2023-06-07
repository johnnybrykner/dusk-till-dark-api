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
          puts "jwt_payload: #{request.env['jwt_payload']}"
          dynamodb_service = DuskAPI::DynamodbService.new
          user = dynamodb_service.get_user(request.params[:username])

          response.format = :json
        
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
