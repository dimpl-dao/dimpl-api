class Bid < ApplicationRecord
    belongs_to :listing
    belongs_to :user
    belongs_to :delivery_address

    after_create do |bid|
        unless bid.hash_id
            bid.hash_id = Hasher::Bid.call(bid)
            bid.save
        end
    end

    module Status
        CREATED = 0
        PAID = 1
    end
    def hash_id_string
        hash_id.to_s
    end
end
