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
    end
  end