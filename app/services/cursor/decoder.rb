module Cursor
    class Decoder < ApplicationService
        def initialize(cursor, options)
            @order_by = options[:order_by]
            @desc = options[:desc]
            @cursor = cursor
        end
        def call
            return {} unless @cursor
            decode
            check_params
            where = "date_trunc('second', #{@order_by}) #{@desc ? "<" : ">"} to_timestamp(#{@decoded_cursor[:last_value]}) OR (date_trunc('second', #{@order_by}) = to_timestamp(#{@decoded_cursor[:last_value]}) AND id #{@desc ? "<" : ">"} '#{@decoded_cursor[:last_id]}')"
            return where
        end
        def decode
            @decoded_cursor = Jwt::Decoder.call("eyJhbGciOiJSUzI1NiJ9.#{@cursor}", false)
        end
        private
        def check_params
            ActionController::Parameters.new(@decoded_cursor).require([:last_value, :last_id])
        end
    end
end