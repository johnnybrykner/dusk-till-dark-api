# frozen_string_literal: true
require "oj"

module DuskAPI
  module Actions
    module Users
      module Move
        class Index < DuskAPI::Action
          params do
            required(:username).value(:string)
            required(:film_id).value(:integer)
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

            current_to_watch = current_user["to_watch"]
            index_of_film_to_move = current_to_watch&.find_index { |film|
              film["id"].to_i == request.params[:film_id].to_i
            }

            if index_of_film_to_move.nil?
              response.status = 404
              response.body = {error: "Film not found"}.to_json
              return
            end

            film_to_move = current_to_watch[index_of_film_to_move]

            dynamodb_service.remove_film(request.params[:username], "to_watch", index_of_film_to_move)
            updated_user = dynamodb_service.add_film(request.params[:username], "previously_watched", film_to_move)
            response.body = Oj.dump(updated_user["attributes"])
          end
        end
      end
    end
  end
end
