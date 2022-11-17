module Auth
    class Authenticator < ApplicationService
        def initialize(jwt)
          @jwt = jwt
        end
        def call
            return nil if @jwt.blank?
            begin
              payload = Jwt::Decoder.call(@jwt)
              return nil if payload[:exp] < Time.now.to_i
              return User.find_by(klaytn_address: payload[:klaytn_address])
            rescue => e
              return nil
            end
        end
    end
end