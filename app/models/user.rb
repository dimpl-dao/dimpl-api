class User < ApplicationRecord
    validates :account, account: true

    def profile_dto
      return {
        account: "0x" + account,
        username: username,
        created_at: created_at,
        updated_at: updated_at
      }
    end
end
