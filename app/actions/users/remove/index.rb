# frozen_string_literal: true
require "oj"

module DuskAPI
  module Actions
    module Users
      module Remove
        class Index < DuskAPI::Action
          params do
            required(:list_name).value(:string)
            required(:film_id).value(:integer)
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

            currently_edited_list = current_user[request.params[:list_name]]
            index_of_film_to_remove = currently_edited_list&.find_index { |film|
              film["id"].to_i == request.params[:film_id].to_i
            }

            if index_of_film_to_remove.nil?
              response.status = 404
              response.body = {error: "Film not found"}.to_json
              return
            end

            updated_user = dynamodb_service.remove_film(request.env["jwt_username"], request.params[:list_name], index_of_film_to_remove)
            response.body = Oj.dump(updated_user["attributes"])
          end
        end
      end
    end
  end
end
