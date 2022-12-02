module Escrow
    class ListingCreatedHandler < ApplicationService
        def initialize(event)
            @event = event
        end
        def get_input_types
            return ABI::DIMPL_ESCROW[:"ListingCreated(uint256,address,uint256,uint256,uint128,uint128)"][:inputs].map{|inputs| inputs[:type]}
        end
        def call
            (hash, address, deposit, price, remonstrable_block_interval, id) = Eth::Abi.decode(get_input_types, @event[:data])
            listing = Escrow::ListingCreateOrGetter.call(hash)
            if listing
                listing.update!({status: Listing::Status::PAID, hash_id: hash, deposit: deposit, remonstrable_block_interval: remonstrable_block_interval, price: price})
            end
        end
    end
end