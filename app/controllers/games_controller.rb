class GamesController < ApplicationController
  before_action :set_game, only: [:show, :destroy]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
    4.times do
      player = @game.players.build
      4.times { player.scores.build }
    end
    gon.player_names = Player.allNames
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new
    @game.game_date = params["game"]["game_date"]
    @players = params["game"]["players_attributes"]
    names = []
    @players.each do |key, value|
      if value["name"] != ''
        p = Player.find_by_name(value["name"])
        @game.players << p
        score_params = Score.new({id: nil, game_id: @game.id, player_id: p.id, score: value["score"]["score"].to_i})
        @game.scores << score_params
      end
    end
    # p1 = Player.find_by_name(params[:game][:player1_name])
    # p2 = Player.find_by_name(params[:game][:player2_name])
    # @game.player1_id = p1.id
    # @game.player2_id = p2.id
    
    # p1, p2 = @game.update_wins(p1, p2)
    # p1, p2, @game.rating_change = @game.update_rating(p1, p2)
    
    respond_to do |format|
      if @game.save
        # p1.save
        # p2.save 

        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    p1 = Player.find(@game.player1_id)
    p2 = Player.find(@game.player2_id)
    
    p1, p2 = @game.revert_wins(p1, p2)
    p1, p2 = @game.revert_ratings(p1, p2)

    p1.save
    p2.save

    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:game_date, 
                                    players_attributes: [:id, :name, :score])
    end
end
