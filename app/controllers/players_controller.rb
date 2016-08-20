class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]

  # GET /players
  # GET /players.json
  def index
    @ranked_players = Player.where("wins>0 or losses>0").order(rating: :desc) 
    @unranked_players = Player.where("wins=0 and losses=0")
  end

  # GET /players/1
  # GET /players/1.json
  def show
    @game_logs = []
    @player = Player.find(params[:id])
    @games = @player.games
    @games.each do |game|
      game_data = game.winners_losers
      is_win = @player.determine_win(game_data)
      game_log = {id: game.id, game_date: game.game_date, result: is_win ? "W" : "L", 
                  rating_change: is_win ? "+#{game.rating_change}": "-#{game.rating_change}", 
                  matchup: "#{game_data[:winners].join(' / ')} - #{game_data[:losers].join(' / ')}",
                  score: "#{game_data[:winning_score]} - #{game_data[:losing_score]}" }
      @game_logs << game_log
      @game_logs = @game_logs.sort_by {|game_log| game_log[:game_date].to_time.to_i }.reverse!
    end
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players
  # POST /players.json
  def create
    @player = Player.new(player_params)
    @player.rating = 1500
    @player.wins = 0
    @player.losses = 0

    respond_to do |format|
      if @player.save
        @player.send_slack_notification()
        format.html { redirect_to @player, notice: 'Player was successfully created.' }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to players_url, notice: 'Player was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:name, :department, :email)
    end
end
