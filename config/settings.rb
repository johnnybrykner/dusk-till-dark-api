# frozen_string_literal: true

module DuskAPI
  class Settings < Hanami::Settings
    setting :dynamo_db_secret, constructor: Types::String
  end
end
