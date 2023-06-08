require "jwt"

module DuskAPI
  class JwtMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      # Get the request cookie
      cookie = env["HTTP_COOKIE"]
      
      if cookie.nil? || !cookie.include?("account_token=")
        return Rack::Response.new("Unauthorized", 401, { "Content-Type" => "application/json" }).finish
      end

      jwt_token = cookie.split("account_token=")[1].split(";")[0]
      jwt_service = DuskAPI::JwtService.new

      begin
        jwt_username = jwt_service.decode_jwt_token(jwt_token)[0]
      rescue JWT::DecodeError
        return Rack::Response.new("Unauthorized", 401, { "Content-Type" => "application/json" }).finish
      end

      # Pass the request down the middleware stack
      env["jwt_username"] = jwt_username
      @app.call(env)
    end
  end
end