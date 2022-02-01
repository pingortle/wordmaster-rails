class GamesController < ApplicationController
  def index
    @games = Game.all.order(created_at: :desc)
  end

  def show
    @game = Game.find(params[:id]).scored
  end

  def create
    @game = Game.with_random_word(length: length_param).create!(game_params)
    redirect_to @game
  end

  def game_params
    params.fetch(:game, {}).permit(:word, :attempt_limit)
  end

  def global_params
    params.permit(:length)
  end

  def length_param
    global_params.fetch(:length, 5).to_i
  end
end
