module Escrow
    class BidCreateOrGetter < ApplicationService
        def initialize(bid_hash)
            @bid_hash = bid_hash
        end
        def call
            return nil if @bid_hash == 0
            bid = Bid.find_by(hash_id: @bid_hash)
            unless bid
                (address, created_block, deposit, listing_hash_id) = KAS::ContractCaller.call(
                    ABI::DIMPL_ESCROW[:"bid(uint256)"], 
                    {
                        inputs: [@bid_hash], 
                        contract: Escrow::CONTRACT_ADDRESS
                    }
                )
                user = Auth::UserCreateOrGetter.call(address)
                if user
                    bid = Bid.create!({status: Bid::Status::PAID, hash_id: @bid_hash, user_id: user.id, deposit: deposit, created_block: created_block})
                    listing = Escrow::ListingCreateOrGetter.call(listing_hash_id)
                    if listing
                        bid.listing_id = listing.id
                        bid.save
                    end
                end
            end
            return bid
        end
    end
end