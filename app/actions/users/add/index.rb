# frozen_string_literal: true
require "oj"

module DuskAPI
  module Actions
    module Users
      module Add
        class Index < DuskAPI::Action
          params do
            required(:username).value(:string)
            required(:list_name).value(:string)
            required(:film_to_add).filled(DuskAPI::Types::FilmType)
          end

          def handle(request, response)
            response.format = :json
            if request.env["jwt_username"] != request.params[:username]
              response.status = 401
              response.body = {error: "Unauthorized"}.to_json
              return
            end
            halt 422, {error: request.params.errors.to_s}.to_json unless request.params.valid?

            dynamodb_service = DuskAPI::DynamodbService.new
            current_user = dynamodb_service.get_user(request.params[:username])
            halt 404, {error: "User not found"}.to_json unless current_user

            currently_edited_list = current_user[request.params[:list_name]]
            film_already_added = currently_edited_list && currently_edited_list.any? { |film|
              film["id"].to_i == request.params[:film_to_add][:id].to_i
            }
            if film_already_added
              response.status = 409
              response.body = {error: "Film already in previously watched list"}.to_json
              return
            end

            response.body = Oj.dump(dynamodb_service.add_film(request.params[:username], request.params[:list_name], request.params[:film_to_add])["attributes"])
          end
        end
      end
    end
  end
end
