module Feed
    class BidGetter < ApplicationService
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
            get_bids
            encode_cursor
            return {
                cursor: @cursor,
                bids: @bids.as_json({
                    include: [
                        :listing,
                        :user,
                        :delivery_address
                    ],
                })
            }
        end
        def get_cursor_predicate
            @cursor_predicate = Cursor::Decoder.call(@params[:cursor], {order_by: self.order_by, desc: self.desc})
        end
        def get_limit
            @limit = @params[:limit]
        end
        def get_bids
            @bids = (Bid
                .includes([:listing, :user, :delivery_address])
                .where(@predicate)
                .where(@cursor_predicate)
                .order("#{self.order_by} #{self.desc ? "DESC" : "ASC"}")
                .limit(@limit))
        end
        def encode_cursor
            @cursor = nil
            return unless @bids.last
            cursor = {
                last_value: @bids.last.created_at.to_i,
                last_id: @bids.last.id
            }
            @cursor = Cursor::Encoder.call(cursor)
        end
    end

end