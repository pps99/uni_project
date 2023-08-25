class TransitionRepository
    class << self
      def createTransition(transition)
        transition.save
      end

      def getAmount(user_id)
        Transition.find_by(user_id: user_id).try(:amount)
      end

      def updateAmount(order)
        transition = Transition.find_by(user_id: order.user_id)
        amount = transition.amount.to_i - order.total
        transition.update(amount: amount)
      end
    end
  end
  