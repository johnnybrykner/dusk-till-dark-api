# frozen_string_literal: true

require "hanami/boot"
require "rack/cors"

use Rack::Cors do
  allow do
    origins "localhost:8080", "dusk-till-dark.netlify.app"
    resource "/dusk_api/*", headers: :any, methods: [:get, :post, :put, :delete], credentials: true
  end
end

run Hanami.app
