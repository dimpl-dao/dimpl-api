module Jwt
    class Encoder < ApplicationService
        def initialize(payload)
            @jwt = JWT.encode(payload, RSA_PRIVATE, 'RS256')
        end
        def call
            return @jwt
        end
    end
end