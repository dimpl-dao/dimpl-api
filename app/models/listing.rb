class Listing < ApplicationRecord

    def self.feed(page:, keyword:)
        where("title LIKE '%#{keyword || ""}%'").page(page)
    end

end
