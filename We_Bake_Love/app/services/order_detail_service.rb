class OrderDetailService
  class << self
    def createOrderDetail(order_detail)
      @is_order_create = OrderDetailRepository.createOrderDetail(order_detail)
    end
  end
end