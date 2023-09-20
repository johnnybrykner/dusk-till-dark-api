# frozen_string_literal: true

require "hanami"

module DuskAPI
  class App < Hanami::App
    config.middleware.use :body_parser, :json
    config.actions.cookies = {
      httponly: true,
      domain: "localhost:8080",
      secure: true,
    }
  end
end
