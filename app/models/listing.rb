class Listing < ApplicationRecord
    has_many_attached :images

    module Status
        CREATED = 0
        PAID = 1
        LOCKED = 2
        COMPLETED = 3
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
