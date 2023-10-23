# frozen_string_literal: true

module DuskAPI
  module Actions
    module Users
      module Authenticate
        class Logout < DuskAPI::Action
          def handle(request, response)
            response.format = :json
            if !request.env["HTTP_COOKIE"]
              response.status = 401
              response.body = {error: "Unauthorized"}.to_json
              return
            else
              response.headers["Set-Cookie"] = "account_token=; SameSite=None; Path=/dusk_api/users; Secure; HttpOnly; Partitioned"
              response.status = 200
              response.body = {message: "User logged out"}.to_json
            end
          end
        end
      end
    end
  end
end
