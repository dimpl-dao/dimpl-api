class NonceDecoderService

    attr_accessor :nonce

    def initialize(nonce = nil)
        @nonce = if nonce
            nonce
        else
            SecureRandom.hex(24)
        end
    end

    def call(signature)
        public_key = Eth::Signature.personal_recover(message_from_nonce, signature, Rails.env.production? ? Eth::Chain::ETHEREUM : Eth::Chain::GOERLI)
        return Eth::Util.public_key_to_address(public_key).to_s.downcase
    end

    def message_from_nonce
        return "Welcome to dBay. Please sign this message to verify your identity. The challenge is #{@nonce}"
    end

end