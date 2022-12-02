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
            address = address.downcase[2..-1]
            bid_id = IntToUuidConverter.call(id)
            bid = Bid.find_by(id: bid_id)
            listing = Listing.find_by(hash_id: listing_hash_id)
            user = User.find_by(klaytn_address: address)
            unless user
                user = User.create!({klaytn_address: address})
            end
            if bid
                bid.update!({status: Bid::Status::PAID, hash_id: bid_hash_id, deposit: deposit, created_block: created_block, listing_id: listing.id}) if bid.user_id == user.id && listing
            elsif listing
                bid = Listing.new({status: Bid::Status::PAID, hash_id: bid_hash_id, user_id: user.id, deposit: deposit, created_block: created_block, listing_id: listing.id})
                bid.id = bid_id
                bid.save
            end
        end
    end
end