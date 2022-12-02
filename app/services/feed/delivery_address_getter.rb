module Feed
    class DeliveryAddressGetter < ApplicationService
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
            get_delivery_addresses
            encode_cursor
            return {
                cursor: @cursor,
                delivery_addresses: @delivery_addresses.as_json
            }
        end
        def get_cursor_predicate
            @cursor_predicate = Cursor::Decoder.call(@params[:cursor], {order_by: self.order_by, desc: self.desc})
        end
        def get_limit
            @limit = @params[:limit]
        end
        def get_delivery_addresses
            @delivery_addresses = (DeliveryAddress
                .where(@predicate)
                .where(@cursor_predicate)
                .order("#{self.order_by} #{self.desc ? "DESC" : "ASC"}")
                .limit(@limit))
        end
        def encode_cursor
            @cursor = nil
            return unless @delivery_addresses.last
            cursor = {
                last_value: @delivery_addresses.last.created_at.to_i,
                last_id: @delivery_addresses.last.id
            }
            @cursor = Cursor::Encoder.call(cursor)
        end
    end

end