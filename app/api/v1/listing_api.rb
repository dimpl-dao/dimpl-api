module V1
    class ListingApi < Grape::API
        resource :listing do

            params do
                optional :page, type: Integer, default: nil
                optional :keyword, type: String, default: nil
            end
            get :feed do
                listings = Listing.feed(page: params[:page], keyword: params[:keyword])
                return {
                    success: true,
                    listings: listings,
                }
            end

        end
    end
end