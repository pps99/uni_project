class TransitionsController < ApplicationController
    def getAmount
      @amount = TransitionService.getAmount(params[:user_id])
      render json: { amount: @amount }, status: :ok
    end
end
