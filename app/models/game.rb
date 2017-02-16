class Game < ActiveRecord::Base
	has_many :game_players
	has_many :players, through: :game_players
	has_many :scores, dependent: :destroy

  validates :game_date, presence: true

	accepts_nested_attributes_for :players

  def self.build_game_data(params)
    players = params["game"]["players_attributes"]
    team1 = { members: [], rating: 0, score: nil }
    team2 = { members: [], rating: 0, score: nil }
    winning_score = 0

    players.each do |key, value|
      score = value["score"]["score"].to_i
      name = value["name"]

      #assign winning teams and scores
      if not name.blank? 
        if team1[:members].empty? and team2[:members].empty?
          team1[:members] << name
          team1[:score] = score
        else
          if team1[:score] == score
            team1[:members] << name
          else
            team2[:members] << name
            team2[:score] = score
          end
        end

        if winning_score < score
          winning_score = score
        end
      end
    end

    #assign rating and find the rating change
    team1[:members].each do |member|
      team1[:rating] += Player.find_by_name(member).rating
    end

    team2[:members].each do |member|
      team2[:rating] += Player.find_by_name(member).rating
    end

    return team1, team2, winning_score
  end

  def update_rating(team1, team2, winning_score)
    if team1[:score] == winning_score
      winning_team = team1
      losing_team = team2
      win_percentage = team1[:score].to_f / (team1[:score] + team2[:score])
      rating_change = self.calc_rating_change(team1[:rating], team2[:rating], win_percentage)
    else
      winning_team = team2
      losing_team = team1
      win_percentage = team2[:score].to_f / (team1[:score] + team2[:score])
      rating_change = self.calc_rating_change(team2[:rating], team1[:rating], win_percentage) 
    end

    return rating_change
  end

  def calc_rating_change(winner_rating, loser_rating, win_percentage)
    expected_score = 1.0 / (1 + 10 ** ((loser_rating - winner_rating) / 400))
    rating_change = (32 * (1 - expected_score)).abs * (1.0 + (win_percentage-0.5))
    
    return rating_change
  end

  def find_winning_score
    winning_score = 0
    self.scores.each do |score|
      if score.score > winning_score
        winning_score = score.score
      end
    end

    return winning_score
  end

  def find_winning_player_ids
    winning_player_ids = []
    winning_score = self.find_winning_score
    self.scores.each do |score|
      if score.score == winning_score
        winning_player_ids << score.player_id
      end
    end

    return winning_player_ids
  end

  def box_score
    box_score = { winners: [], losers: [], winning_score: nil, losing_score: nil}
    winner_score = find_winning_score

    self.scores.each do |score|
      player_name = Player.find(score.player_id).name
      if score.score == winner_score
        box_score[:winners] << player_name
        box_score[:winning_score] = winner_score if box_score[:winning_score] == nil
      else
        box_score[:losers] << player_name
        box_score[:losing_score] = score.score if box_score[:losing_score] == nil
      end
    end

    return box_score
  end

  def is_championship_belt_game
    return self.players.any? {|p| p[:has_championship_belt] == true }
  end

  def send_slack_notification(team1, team2, winning_score)
    if team1[:score] == winning_score
      winning_team = team1
      losing_team = team2
    else
      winning_team = team2
      losing_team = team1
    end

    winning_team_name = winning_team[:members].join('/')
    winning_team_score = winning_team[:score]
    losing_team_name = losing_team[:members].join('/')
    losing_team_score = losing_team[:score]

    if losing_team_score == 0
      HTTP.post("#{Rails.application.config.slack_carvana_ping_pong_url}", 
              :json => { text: ":table_tennis_paddle_and_ball: #{winning_team_name} just DOMINATED #{losing_team_name} #{winning_team_score} - #{losing_team_score} :clap: :muscle: :rocket:" })
    else
      HTTP.post("#{Rails.application.config.slack_carvana_ping_pong_url}", 
              :json => { text: ":table_tennis_paddle_and_ball: #{winning_team_name} just won against #{losing_team_name} #{winning_team_score} - #{losing_team_score} :raised_hands:" })
    end
  end
end
