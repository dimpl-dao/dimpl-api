module Jwt
    class Decoder < ApplicationService
        def initialize(jwt)
            @payload = JWT.decode(jwt, RSA_PRIVATE, true, {algorithm: 'RS256'})
        end
        def call
            return @payload[0].with_indifferent_access
        end
    end
end