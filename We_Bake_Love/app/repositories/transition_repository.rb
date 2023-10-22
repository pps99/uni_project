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
        amount = transition.amount - order.total
        transition.update(amount: amount)
      end
 
      def updateAccountAmount(transition_id)
        @transition = Transition.find_by(id: transition_id)
        @transition.update(amount: @transition.amount+@transition.recharge_amount,recharge_amount: 0,transition_no: 'nil')
      end
      
      def cancelAccountAmount(transition_id)
        @transition = Transition.find_by(transition_id)
        @transition.update(recharge_amount: 0,transition_no: 'nil')
      end

      def savetransition_no(params)        
        Transition.find_by(user_id: params[:user_id])
                  .update(transition_no: params[:transition_no],recharge_amount: params[:recharge_amount])
      end
    end
  end
  