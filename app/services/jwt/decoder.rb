module Jwt
    class Decoder < ApplicationService
        def initialize(jwt, verify = true)
            @jwt = jwt
            @verify = verify
        end
        def call
            if @verify
                decode
            else
                decode_without_verification
            end
            return @payload[0].with_indifferent_access
        end
        private
        def decode_without_verification
            @payload = JWT.decode(@jwt, nil, false, {algorithm: 'RS256'})
        end
        private
        def decode
            @payload = JWT.decode(@jwt, RSA_PRIVATE, true, {algorithm: 'RS256'})
        end
    end
end