class Bid < ApplicationRecord
    belongs_to :listing
    belongs_to :user
    belongs_to :delivery_address
    module Status
        CREATED = 0
        PAID = 1
    end
    def hash_id_string
        hash_id.to_s
    end
end
