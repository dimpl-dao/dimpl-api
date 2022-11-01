class User < ApplicationRecord
    validates :account, account: true
    
    def self.from_jwt(jwt: )
        return nil if jwt.blank?
        begin
          payload = AuthHelper::Jwt.decode(jwt: jwt)
          return nil if payload[:exp] < Time.now.to_i
          return User.find_by("#{User.primary_key}": payload[:"#{User.primary_key}"])
        rescue => e
          return nil
        end
    end


    def create_jwt(primary_key: , exp: 1.month.since.to_i)
        payload = {
            "#{User.primary_key}": primary_key,
            exp: exp
        }
        return AuthHelper::Jwt.encode(payload)
    end

end
