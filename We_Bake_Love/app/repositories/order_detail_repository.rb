class OrderDetailRepository
    class << self
      def createOrderDetail(order_detail)
        @is_order_detail_create = order_detail.save
      end
    end
  end