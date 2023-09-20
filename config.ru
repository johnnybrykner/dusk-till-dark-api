# frozen_string_literal: true

require "hanami/boot"
require "rack/cors"

use Rack::Cors do
  allow do
    origins "localhost:8080", "https://dusk-till-dark.netlify.app/"
    resource "/dusk_api/*", headers: :any, methods: [:get, :post, :put, :delete]
  end
end

run Hanami.app
