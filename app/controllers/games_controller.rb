class GamesController < ApplicationController
  def index
    @games = Game.all.order(created_at: :desc)
  end

  def show
    @game = Game.find(params[:id])
    @game.score!
  end

  def create
    @game = Game.create!(word: "hello")
    redirect_to @game
  end
end
