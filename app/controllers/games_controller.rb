class GamesController < ApplicationController
  rescue_from "RawgApi::V2::Client::GameNotFound", with: :game_not_found

  def index
    client = RawgApi::V2::Client.new
    @games = client.games
  end

  def show
    client = RawgApi::V2::Client.new
    @game = client.game(params[:id])
  end

  private

  def game_not_found
    render plain: 'game not found'
  end
end
