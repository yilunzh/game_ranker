class GamesController < ApplicationController
  require "http"
  before_action :set_game, only: [:show, :destroy]

  # GET /games
  # GET /games.json
  def index
    @games = Game.paginate(:page => params[:page], :per_page => 10)
                 .order(game_date: :desc, created_at: :desc)
  end

  # GET /games/1
  # GET /games/1.json
  def show
  end

  # GET /games/new
  def new
    gon.player_names = Player.find_all_player_names
    @game = Game.new(game_date: DateTime.now.to_date)
    
    4.times do
      player = @game.players.build
      4.times { player.scores.build }
    end 
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new
    @game.game_date = params["game"]["game_date"]
    @players = params["game"]["players_attributes"]
    player_count = 0

    team1, team2, winning_score = Game.build_game_data(params)

    #find winning and losing team and calculate rating change accordingly
    rating_change = @game.update_rating(team1, team2, winning_score)
    @game.rating_change = rating_change

    #calculate player wins, losses, ratings
    @players.each do |key, value|
      if value["name"] != ''
        p = Player.find_by_name(value["name"])
        player_count += 1
        @game.players << p
        score = value["score"]["score"].to_i
        score_params = Score.new({id: nil, game_id: @game.id, player_id: p.id, score: score})
        @game.scores << score_params
        
        if score == winning_score
          p.wins += 1
          p.rating += rating_change
          p.winning_streak += 1
          p.losing_streak = 0
          # if is_championship_belt_game
          #   if p.has_championship_belt == false
          #     p.has_championship_belt = true
          #   end
          # end
        else
          p.losses += 1
          p.rating -= rating_change
          p.losing_streak += 1
          p.winning_streak = 0
          # if is_championship_belt_game
          #   if p.has_championship_belt
          #     p.has_championship_belt = false
          #   end
          # end
        end
      end
    end

    #determine if it's a championship belt game
    if player_count == 2
      is_championship_belt_game = @game.is_championship_belt_game
    else
      is_championship_belt_game = false
    end

    if is_championship_belt_game
      winning_player_ids = @game.find_winning_player_ids

      @game.players.each do |p|
        #has belt and lost
        if (p.has_championship_belt) && (not winning_player_ids.include? p.id)
          p.has_championship_belt = false
        end
        #doesn't have belt and won
        if (p.has_championship_belt == false) && (winning_player_ids.include? p.id)
          p.has_championship_belt = true
        end 
      end
    end

    #save data
    respond_to do |format|
      if @game.save
        @game.players.each do |p|
          p.save
        end
        @game.scores.each do |s|
          s.save
        end

        #@game.send_slack_notification(team1, team2, winning_score)

        format.html { redirect_to games_path, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { 4.times do
                        player = @game.players.build
                        4.times { player.scores.build }
                      end 
                      render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    
    #find winning score
    winning_score = @game.find_winning_score

    #reverting score and ratings
    @game.scores.each do |score|
      p = Player.find(score.player_id)

      if score.score == winning_score
        p.wins -= 1
        p.rating -= @game.rating_change
      else
        p.losses -= 1
        p.rating += @game.rating_change
      end
      p.save
    end

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

    def destroy_scores
      self.scores.delete_all
    end
end
