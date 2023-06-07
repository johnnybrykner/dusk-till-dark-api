require "jwt"

module DuskAPI
  class JwtService
    def generate_jwt_token(jwt_payload)
      JWT.encode jwt_payload, Hanami.app["settings"].jwt_secret, "HS256"
    end

    def decode_jwt_token(jwt_token)
      JWT.decode jwt_token, Hanami.app["settings"].jwt_secret, true, { algorithm: "HS256" }
    end
  end
end
