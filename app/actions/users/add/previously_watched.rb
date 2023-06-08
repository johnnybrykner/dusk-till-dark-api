# frozen_string_literal: true
require "oj"

module DuskAPI
  module Actions
    module Users
      module Add
        class PreviouslyWatched < DuskAPI::Action
          params do
            required(:username).value(:string)
            required(:film_previously_watched).filled(DuskAPI::Types::FilmPreviouslyWatched)
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

            film_already_added = current_user["previously_watched"].any? { |film|
              film["id"].to_i == request.params[:film_previously_watched][:id].to_i
            }
            if film_already_added
              response.status = 409
              response.body = {error: "Film already in previously watched list"}.to_json
              return
            end

            response.body = Oj.dump(dynamodb_service.add_film(request.params[:username], "previously_watched", request.params[:film_previously_watched])["attributes"])
          end
        end
      end
    end
  end
end
