module AuthHelper

    module Jwt
        extend self

        @@path = Rails.root.join("config", "keys", "private_key.pem")
        @@rsa_private = OpenSSL::PKey::RSA.new File.read(@@path)
        @@rsa_public = OpenSSL::PKey::RSA.new File.read(@@path)
    
        def decode(jwt: )
            payload = JWT.decode(jwt, @@rsa_public, true, {algorithm: 'RS256'})
            return payload[0].with_indifferent_access
        end
    
        def encode(payload: )
            return JWT.encode(payload, @@rsa_private, 'RS256')
        end
    
    end

    module Nonce
        extend self

        def verify(nonce:, signature:, account:)
            nonce_decoder = NonceDecoderService.new(nonce)
            decoded_account = nonce_decoder.call(signature)
            return decoded_account == account
        end
    end

end