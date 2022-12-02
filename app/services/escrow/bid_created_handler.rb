module Escrow
    class BidCreatedHandler < ApplicationService
        def initialize(event)
            @event = event
        end
        def get_input_types
            return ABI::DIMPL_ESCROW[:"BidCreated(uint256,address,uint256,uint256,uint128,uint128)"][:inputs].map{|inputs| inputs[:type]}
        end
        def call
            (bid_hash_id, address, deposit, listing_hash_id, created_block, id) = Eth::Abi.decode(get_input_types, @event[:data])
            bid = Escrow::BidCreateOrGetter.call(bid_hash_id)
            if bid
                bid.update!({status: Bid::Status::PAID, hash_id: bid_hash_id, deposit: deposit, created_block: created_block, listing_id: listing.id}) if bid.user_id == user.id && listing
            end
        end
    end
end