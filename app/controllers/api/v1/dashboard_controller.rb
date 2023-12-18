# app/controllers/api/v1/dashboard_controller.rb

module Api
  module V1
    class DashboardController < ApplicationController
      def user_stats
        render json: { num_users: User.count }
      end

      def quote_stats
        render json: { num_quotes: Quote.count }
      end

      def processed_quotes_count
        render json: { processed_quotes_count: Quote.where(processed: true).count }
      end

      def unprocessed_quotes_count
        render json: { unprocessed_quotes_count: Quote.where(processed: false).count }
      end

      def order_stats
        render json: { num_orders: Order.count }
      end

      def item_stats
        render json: { num_items: Item.count }
      end

      def recent_orders
        orders = Order.where(created_at: (Time.now - 24.hours)..Time.now).order(created_at: :desc)
        render json: orders
      end

      def users
        render json: User.all
      end
    end
  end
end
