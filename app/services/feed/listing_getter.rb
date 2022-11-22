module Feed
    class ListingGetter < ApplicationService
        class_attribute :order_by
        class_attribute :desc
        self.order_by = 'created_at'
        self.desc = true

        def initialize(predicate, **options)
            @predicate = predicate
            @params = ActionController::Parameters.new(options).permit([:cursor, :limit])
        end
        def call
            get_cursor_predicate
            get_limit
            get_listings
            encode_cursor
            return {
                cursor: @cursor,
                listings: @listings.as_json({
                    methods: [
                        :image_uri
                    ]
                })
            }
        end
        def get_cursor_predicate
            @cursor_predicate = Cursor::Decoder.call(@params[:cursor], {order_by: self.order_by, desc: self.desc})
        end
        def get_limit
            @limit = @params[:limit]
        end
        def get_listings
            @listings = (Listing
                .where(@predicate)
                .where(@cursor_predicate[:where])
                .order("#{self.order_by} #{self.desc ? "DESC" : "ASC"}")
                .limit(@limit)
                .with_attached_images)
        end
        def encode_cursor
            cursor = {
                last_value: @listings.last&.created_at.to_i,
                last_id: @listings.last&.id
            }
            @cursor = Cursor::Encoder.call(cursor)
        end
    end

end