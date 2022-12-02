class IntToUuidConverter < ApplicationService
    def initialize(int)
        @int = int
    end
    def call
        string = @int.to_s(16)
        string = "0" * (32 - string.length) + string
        return string[0..7] + "-" + string[8..11] + "-" + string[12..15] + "-" + string[16..19] + "-" + string[20..31]
    end
end
