class TransitionService
    class << self
      def createTransition(transition)
        TransitionRepository.createTransition(transition)
      end

      def getAmount(user_id)
        TransitionRepository.getAmount(user_id)
      end

      def updateAmount(order)
        TransitionRepository.updateAmount(order)
      end
      
      def updateAccountAmount(transition_id)
        TransitionRepository.updateAccountAmount(transition_id)
      end

      def cancelAccountAmount(transition_id)
        TransitionRepository.cancelAccountAmount(transition_id)
      end
      
      def savetransition_no(params)
        TransitionRepository.savetransition_no(params)
      end

    end
  end