class User < ApplicationRecord
    validates :klaytn_address, evm_address: true

    def profile_dto
      return {
        id: id,
        klaytn_address: klaytn_address,
        username: username,
        created_at: created_at,
        updated_at: updated_at
      }
    end
end
