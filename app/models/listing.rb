class Listing < ApplicationRecord
    belongs_to :user
    has_many :bids, dependent: :destroy
    belongs_to :bid, required: false
    has_many_attached :images

    module Status
        CREATED = 0
        PAID = 1
        TRANSACTING = 2
        COMPLETED = 3
        LOCKED = 4
    end

    def hash_id_string
        hash_id.to_s
    end

    def paid_bids
        bids.where(status: Bid::Status::PAID).as_json({
            methods: [:user, :hash_id_string]
        })
    end

    def image_uris
        if images.attached?
            return images.map do |image|
                CDN_HOST+image.blob.key
            end
        end
        return []
    end
    def image_uri
        if images.attached?
            return CDN_HOST+images.first.blob.key
        end
        return nil
    end

end
