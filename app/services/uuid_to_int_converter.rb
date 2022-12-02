class UuidToIntConverter < ApplicationService
    def initialize(uuid)
        @uuid = uuid
    end
    def call
        return @uuid.gsub("-", "").to_i(16)
    end
end
