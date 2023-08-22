class TransitionRepository
    class << self
      def createTransition(transition)
        transition.save
      end

      def getAmount(user_id)
        Transition.find_by(user_id: user_id).try(:amount)
      end
    end
  end
  