class Game < ActiveRecord::Base
	has_many :game_players
	has_many :players, through: :game_players
	has_many :scores, dependent: :destroy
  validates :game_date, presence: true
	accepts_nested_attributes_for :players

	def update_wins(p1, p2)
		if self.player1_score > self.player2_score
      p1.wins += 1
      p2.losses += 1
    else
      p2.wins += 1
      p1.losses += 1
    end

    return p1, p2
	end

  def rating_update(winner_rating, loser_rating, win_percentage)
    expected_score = 1.0 / (1 + 10 ** ((loser_rating - winner_rating) / 400))
    rating_change = (32 * (1 - expected_score)).abs * (1.0 + (win_percentage-0.5))
    
    return rating_change
  end

  def winning_score
    winning_score = 0
    self.scores.each do |score|
      if score.score > winning_score
        winning_score = score.score
      end
    end

    return winning_score
  end

  def winners_losers
    players = { winners: [], losers: [], winning_score: nil, losing_score: nil}
    winner_score = winning_score

    self.scores.each do |score|
      player_name = Player.find(score.player_id).name
      if score.score == winner_score
        players[:winners] << player_name
        players[:winning_score] = winner_score if players[:winning_score] == nil
      else
        players[:losers] << player_name
        players[:losing_score] = score.score if players[:losing_score] == nil
      end
    end

    return players
  end

  def all_player_names
    names = []
    winner_score = self.winning_score

    self.players.each do |player|
      names << player.name
    end

    return names
  end

  def send_slack_notification(winning_team, losing_team)
    winning_team_name = winning_team[:members].join('/')
    winning_team_score = winning_team[:score]
    losing_team_name = losing_team[:members].join('/')
    losing_team_score = losing_team[:score]

    if losing_team_score == 0
      HTTP.post("https://hooks.slack.com/services/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", 
              :json => { text: ":table_tennis_paddle_and_ball: #{winning_team_name} just DOMINATED #{losing_team_name} #{winning_team_score} - #{losing_team_score} :clap: :muscle: :rocket:" })
    else
      HTTP.post("https://hooks.slack.com/services/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", 
              :json => { text: ":table_tennis_paddle_and_ball: #{winning_team_name} just won against #{losing_team_name} #{winning_team_score} - #{losing_team_score} :raised_hands:" })
    end
  end
end
