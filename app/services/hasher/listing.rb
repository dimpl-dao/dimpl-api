module Hasher
    class Listing < ApplicationService
        def initialize(listing)
            @listing = listing
            @user = @listing.user
            @function_abi = ABI::DIMPL_ESCROW[:"getListing(address,uint256,uint256,uint128,uint128)"]
        end
        def call
            input_types = @function_abi[:inputs].map{|input| input[:type]}
            encoded_params = Eth::Abi.encode(input_types, ["0x#{@user.klaytn_address}", @listing.deposit, @listing.price, UuidToIntConverter.call(@listing.id), @listing.remonstrable_block_interval])
            return Digest::Keccak.new(256).hexdigest(encoded_params).to_i(16)
        end
    end
end