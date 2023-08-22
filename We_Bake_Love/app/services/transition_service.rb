class TransitionService
    class << self
      def createTransition(transition)
        TransitionRepository.createTransition(transition)
      end

      def getAmount(user_id)
        TransitionRepository.getAmount(user_id)
      end
    end
  end