module V1
    class ListingApi < Grape::API
        resource :listing do

            params do
                requires :title, type: String
                requires :description, type: String
                requires :price, type: Integer
                requires :deposit, type: Integer
                requires :remonstrable_block_interval, type: Integer
                requires :images, type: Array, default: []
            end
            post do
                authenticate!
                error!('At least 1 image is required', 400) if params[:images].length == 0
                error!('Only up to 10 images can be uploaded', 400) if params[:images].length > 10
                listing = Listing.create!(
                    title: params[:title], 
                    description: params[:description], 
                    price: params[:price], 
                    deposit: params[:deposit],
                    remonstrable_block_interval: params[:remonstrable_block_interval],
                    user_id: current_user.id,
                    status: Listing::Status::CREATED
                )
                params[:images].each do |image|
                    listing.images.attach(image)
                end
                return {
                    success: true,
                    listing: listing.as_json({
                        methods: [
                            :user,
                            :image_uris
                        ]
                    }),
                }
            end

            params do
                requires :id, type: String
                optional :status, type: Integer, values: [1]
                optional :bid_id, type: String
            end
            patch do
                authenticate!
                listing = Listing.find(params[:id])
                error!('Not owner of listing', 400) unless current_user.id == listing.user_id
                (locked, address, deposit, price, bid_hash_id, bid_selected_block, remonstrable_block_interval) = Escrow::ListingChecker.call(listing)
                if params[:status]
                    error!('Not paid yet', 404) unless address.to_i(16) > 0
                    listing.status = params[:status]
                    listing.save
                end
                return {
                    success: true,
                    listing: listing.as_json({
                        methods: [
                            :user,
                            :image_uris,
                            :hash_id_string,
                            :paid_bids
                        ]
                    }),
                }
            end

            params do
                requires :id, type: String
            end
            get do
                listing = Listing.find_by(params)
                unless listing 
                    return {
                        success: false,
                    }
                end
                return {
                    success: true,
                    listing: listing.as_json({
                        include: [
                            :user
                        ],
                        methods: [
                            :user,
                            :image_uris,
                            :hash_id_string,
                            :paid_bids
                        ]
                    }),
                }
            end

            get :abi do
                return {
                    success: true,
                    contract_address: Escrow::CONTRACT_ADDRESS,
                    create: ABI::DIMPL_ESCROW[:"list(uint256,uint128,uint128)"],
                }
            end

            params do
                optional :limit, type: Integer, values: { proc: ->(v) { v.positive? && v <= 30 } }, default: 20
                optional :cursor, type: String
                optional :keyword, type: String
            end
            get :search do
                feed = Feed::ListingGetter.call("title LIKE '%#{params[:keyword] || ""}%'", {limit: params[:limit], cursor: params[:cursor]})
                return {
                    success: true,
                    listings: feed[:listings],
                    cursor: feed[:cursor],
                }
            end

            params do
                optional :limit, type: Integer, values: { proc: ->(v) { v.positive? && v <= 30 } }, default: 20
                optional :cursor, type: String
            end
            get :feed do
                feed = Feed::ListingGetter.call({status: Listing::Status::PAID}, {limit: params[:limit], cursor: params[:cursor]})
                return {
                    success: true,
                    listings: feed[:listings],
                    cursor: feed[:cursor],
                }
            end

            params do
                requires :status, type: Integer, values: [Listing::Status::CREATED, Listing::Status::PAID, Listing::Status::LOCKED, Listing::Status::COMPLETED]
                optional :limit, type: Integer, values: { proc: ->(v) { v.positive? && v <= 30 } }, default: 15
                optional :cursor, type: String
                optional :klaytn_address, type: String, regexp: /^[a-f0-9]{40}$/
            end
            get :list do
                user = if params[:klaytn_address] 
                    User.find_by(klaytn_address: params[:klaytn_address] )
                else 
                    current_user
                end
                return {
                    success: false
                } unless user
                feed = Feed::ListingGetter.call({status: params[:status], user_id: user.id}, {limit: params[:limit], cursor: params[:cursor]})
                return {
                    success: true,
                    listings: feed[:listings],
                    cursor: feed[:cursor],
                }
            end

        end
    end
end