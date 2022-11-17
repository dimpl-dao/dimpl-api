module Auth
    class JwtCreator < ApplicationService
        def initialize(user)
            @payload = {
                klaytn_address: user.klaytn_address,
                exp: 1.month.since.to_i
            }
        end
        def call
            return Jwt::Encoder.call(@payload)
        end
    end
end