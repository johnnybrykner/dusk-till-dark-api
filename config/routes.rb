# frozen_string_literal: true

module DuskAPI
  class Routes < Hanami::Routes
    scope "/dusk_api" do
      root to: "home.show"
      get "/authenticate/:username", to: "users.authenticate.index"
      # get "/users", to: "users.index"
      scope "users" do
        use DuskAPI::JwtMiddleware

        get "/account", to: "users.show"
        post "/add_to/:list_name", list_name: /(to_watch|previously_watched)/, to: "users.add.index"
        delete "/remove_from/:list_name/:film_id", list_name: /(to_watch|previously_watched)/, to: "users.remove.index"
        put "/move_to_watched/:film_id", to: "users.move.index"
        put "/settings", to: "users.settings"
        get "/logout", to: "users.authenticate.logout"
      end
    end
  end
end
