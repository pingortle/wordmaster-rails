class GamesController < ApplicationController
  def index
    @games = Game.all.order(created_at: :desc)
  end

  def show
    @game = Game.find(params[:id])
    @game.score!
  end

  def create
    @game = Game.with_random_word.create!(game_params)
    redirect_to @game
  end

  def game_params
    params.fetch(:game) { ActionController::Parameters.new }.permit(:word, :attempt_limit)
  end
end
