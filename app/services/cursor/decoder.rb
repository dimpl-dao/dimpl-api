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
            where = "WHERE #{@order_by} #{@desc ? "<" : ">"} #{@decoded_cursor[:last_value]}
            OR (#{@order_by} = #{@decoded_cursor[:last_value]} AND id #{@desc ? "<" : ">"} #{@decoded_cursor[:last_id]})"
            order = "ORDER BY #{@order_by} #{@desc ? "DESC" : "ASC"}, id #{@desc ? "DESC" : "ASC"}"
            return {
                where: where,
                order: order
            }
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