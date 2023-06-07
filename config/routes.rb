# frozen_string_literal: true

module DuskAPI
  class Routes < Hanami::Routes
    root to: "home.show"
    get "/users", to: "users.index"
    get "/users/:username", to: "users.show"
  end
end
