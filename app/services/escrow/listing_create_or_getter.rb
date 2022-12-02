module Escrow
    class ListingCreateOrGetter < ApplicationService
        def initialize(listing_hash)
            @listing_hash = listing_hash
        end
        def call
            return nil if @listing_hash == 0
            listing = Listing.find_by(hash_id: @listing_hash)
            unless listing
                (locked, address, deposit, price, bid_hash_id, bid_selected_block, remonstrable_block_interval) = KAS::ContractCaller.call(
                    ABI::DIMPL_ESCROW[:"listings(uint256)"], 
                    {
                        inputs: [@listing_hash], 
                        contract: Escrow::CONTRACT_ADDRESS
                    }
                )
                user = Auth::UserCreateOrGetter.call(address)
                if user
                    listing = Listing.create!({status: Listing::Status::PAID, hash_id: @listing_hash, user_id: user.id, deposit: deposit, remonstrable_block_interval: remonstrable_block_interval, price: price})
                    bid = Escrow::BidCreateOrGetter.call(bid_hash_id)
                    if bid
                        listing.bid_id = bid.id
                        listing.save
                    end
                end
            end
            return listing
        end
    end
end