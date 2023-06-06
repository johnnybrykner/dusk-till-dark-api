# frozen_string_literal: true

module DuskAPI
  module Actions
    module Home
      class Show < DuskAPI::Action
        def handle(*, response)
          response.body = "Welcome to DuskAPI!"
        end
      end
    end
  end
end
