require "jwt"

module DuskAPI
  class JwtMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      # Get the request cookie
      cookie = env["HTTP_COOKIE"]
      
      if cookie.nil? || !cookie.include?("account_token") || cookie.split("=")[1].split(";")[0].nil?
        return Rack::Response.new("Unauthorized", 401, { "Content-Type" => "application/json" }).finish
      end

      jwt_token = cookie.split("=")[1].split(";")[0]
      puts "jwt_token: #{jwt_token}"
      env["jwt_payload"] = DuskAPI::JwtService.new.decode_jwt_token(jwt_token)

      # Pass the request down the middleware stack
      @app.call(env)
    end
  end
end