# frozen_string_literal: true
require "oj"

module DuskAPI
  module Actions
    module Users
      module Add
        class Index < DuskAPI::Action
          params do
            required(:list_name).value(:string)
            required(:id).value(:integer)
            required(:name).value(:string)
            required(:director).value(:string)
            required(:language).value(:string)
            required(:length).value(:integer)
            required(:year).value(:integer)
            required(:film_genres).array(:hash) do
              required(:id).filled(:integer)
              required(:name).filled(:string)
            end
            optional(:our_rating).value(:integer)
            optional(:their_rating).value(:integer)
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
            film_already_added = currently_edited_list && currently_edited_list.any? { |film|
              film["id"].to_i == request.params[:id].to_i
            }
            if film_already_added
              response.status = 409
              response.body = {error: "Film already in previously watched list"}.to_json
              return
            end

            updated_user = dynamodb_service.add_film(
              request.env["jwt_username"],
              request.params[:list_name], {
                "id" => request.params[:id],
                "name" => request.params[:name],
                "director" => request.params[:director],
                "language" => request.params[:language],
                "length" => request.params[:length],
                "year" => request.params[:year],
                "film_genres" => request.params[:film_genres],
                "our_rating" => request.params[:our_rating],
                "their_rating" => request.params[:their_rating],
              }
            )
            response.body = Oj.dump(updated_user["attributes"])
          end
        end
      end
    end
  end
end
