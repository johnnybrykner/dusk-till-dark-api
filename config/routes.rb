# frozen_string_literal: true

module DuskAPI
  class Routes < Hanami::Routes
    root to: "home.show"
    get "/authenticate/:username", to: "users.authenticate"
    # get "/users", to: "users.index"
    scope "users" do
      use DuskAPI::JwtMiddleware

      get "/:username", to: "users.show"
      post "/:username/add/to_watch", to: "users.add.to_watch"
      post "/:username/add/previously_watched", to: "users.add.previously_watched"
      delete "/:username/remove/previously_watched", to: "users.remove.previously_watched"
      delete "/:username/remove/to_watch", to: "users.remove.to_watch"
    end
  end
end
