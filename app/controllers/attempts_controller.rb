class AttemptsController < ApplicationController
  def create
    @game = Game.find(params[:game_id])
    @attempt = @game.attempts.create!(attempt_params)

    redirect_back_or_to @game
  end

  def attempt_params
    params[:attempt].permit(letters_attributes: [:value])
  end
end
