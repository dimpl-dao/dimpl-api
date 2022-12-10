class IntToHexAddressConverter < ApplicationService
    def initialize(int, **options)
        @int = int
        @byte_length = options[:byte_length] || 40
    end
    def call
        string = @int.to_s(16)
        return "0" * (@byte_length - string.length) + string
    end
end
