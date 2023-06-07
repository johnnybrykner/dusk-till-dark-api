# frozen_string_literal: true

require "hanami"

module DuskAPI
  class App < Hanami::App
    config.middleware.use :body_parser, :json
    config.actions.cookies = {
      httponly: true,
    }
  end
end
