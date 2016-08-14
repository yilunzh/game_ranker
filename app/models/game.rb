class Game < ActiveRecord::Base
	has_many :game_players
	has_many :players, through: :game_players
	has_many :scores, dependent: :destroy
	accepts_nested_attributes_for :players
	# def player1_name
	# 	Player.find(self.player1_id).name if self.player1_id
	# end

	# def player1_name=(name)
	# 	self.player1_name = Player.find_by_name(name) if name.present?
	# end

	# def player2_name
	# 		Player.find(self.player2_id).name if self.player1_id
	# end

	# def player2_name=(name)
	# 	self.player2_name = Player.find_by_name(name) if name.present?
	# end

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

  def rating_update(r1, r2)
    expected_score = 1.0 / (1 + 10 ** ((r1 - r2) / 400))
    rating_change = (32 * (1 - expected_score)).abs
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
end
