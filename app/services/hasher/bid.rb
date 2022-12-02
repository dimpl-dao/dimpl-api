module Hasher
    class Bid < ApplicationService
        def initialize(bid)
            @bid = bid
            @listing = bid.listing
            @user = @bid.user
            @function_abi = ABI::DIMPL_ESCROW[:"getBid(address,uint256,uint256,uint128)"]
        end
        def call
            input_types = @function_abi[:inputs].map{|input| input[:type]}
            encoded_params = Eth::Abi.encode(input_types, ["0x#{@user.klaytn_address}", @bid.deposit, @listing.hash_id, UuidToIntConverter.call(@bid.id)])
            return Digest::Keccak.new(256).hexdigest(encoded_params).to_i(16)
        end
    end
end