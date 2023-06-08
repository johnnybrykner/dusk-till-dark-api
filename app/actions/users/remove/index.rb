# frozen_string_literal: true

module DuskAPI
  module Actions
    module Users
      module Remove
        class Index < DuskAPI::Action
          def handle(*, response)
            response.body = self.class.name
          end
        end
      end
    end
  end
end
