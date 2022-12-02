module Escrow
    class BidSelectedHandler < ApplicationService
        def initialize(event)
            @event = event
        end
        def get_input_types
            return ABI::DIMPL_ESCROW[:"BidSelected(uint256)"][:inputs].map{|inputs| inputs[:type]}
        end
        def call
            p @event
            p Eth::Abi.decode(get_input_types, @event[:data])
            bid_hash_id = Eth::Abi.decode(get_input_types, @event[:data]).first
            bid = Escrow::BidCreateOrGetter.call(bid_hash_id)
            p @event[:blockNumber]
            if bid
                listing = bid.listing
                if listing
                    bids = listing.bids.where.not(id: bid.id)
                    bids.destroy_all
                    listing.bid_id = bid.id
                    listing.bid_selected_block = @event[:blockNumber].to_i(16)
                    listing.save
                end
            end
        end
    end
end