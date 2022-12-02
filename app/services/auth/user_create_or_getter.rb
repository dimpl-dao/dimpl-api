module Auth
    class UserCreateOrGetter < ApplicationService
        def initialize(address)
            @address = address[2..-1].downcase
        end
        def call
            return nil if @address.to_i(16) == 0
            user = User.find_by(klaytn_address: @address)
            unless user
                user = User.create!({klaytn_address: @address})
            end
            return user
        end
    end
end