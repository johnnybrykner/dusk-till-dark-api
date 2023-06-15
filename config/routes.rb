# frozen_string_literal: true

module DuskAPI
  class Routes < Hanami::Routes
    root to: "home.show"
    get "/authenticate/:username", to: "users.authenticate"
    # get "/users", to: "users.index"
    scope "users" do
      use DuskAPI::JwtMiddleware

      get "/:username", to: "users.show"
      post "/:username/add_to/:list_name", list_name: /(to_watch|previously_watched)/, to: "users.add.index"
      delete "/:username/remove_from/:list_name/:film_id", list_name: /(to_watch|previously_watched)/, to: "users.remove.index"
      # put "/:username/move_to/:list_name/:film_id", list_name: /(to_watch|previously_watched)/, to: "users.move.index"
    end
  end
end
