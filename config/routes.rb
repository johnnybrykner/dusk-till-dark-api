# frozen_string_literal: true

module DuskAPI
  class Routes < Hanami::Routes
    root to: "home.show"
    get "/authenticate/:username", to: "users.authenticate"
    # get "/users", to: "users.index"
    scope "users" do
      use DuskAPI::JwtMiddleware

      get "/:username", to: "users.show"
      post "/:username/add/:list_name", list_name: /(to_watch|previously_watched)/, to: "users.add.index"
      delete "/:username/remove/:list_name/:film_id", to: "users.remove.index"
    end
  end
end
