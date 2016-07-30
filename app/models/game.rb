class Game < ActiveRecord::Base
	belongs_to :player1, :class => :player, foreign_key: 'player1_id'
	belongs_to :player2, :class => :player, foreign_key: 'player2_id'

	def player1_name
		Player.find(self.player1_id).name if self.player1_id
	end

	def player1_name=(name)
		self.player1_name = Player.find_by_name(name) if name.present?
	end

	def player2_name
			Player.find(self.player2_id).name if self.player1_id
	end

	def player2_name=(name)
		self.player2_name = Player.find_by_name(name) if name.present?
	end

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

	def update_ratings(p1, p2)
		if self.player1_score > self.player2_score
      p1_expected_score = 1.0 / (1 + 10 ** ((p2.rating - p1.rating) / 400))
      p2_expected_score = 1.0 / (1 + 10 ** ((p1.rating - p2.rating) / 400))
      p1.rating = p1.rating + 32 * (1 - p1_expected_score)
      p2.rating = p2.rating + 32 * (0 - p2_expected_score)
      rating_change = (32 * (1 - p1_expected_score)).abs
    else
      p1_expected_score = 1.0 / (1 + 10 ** ((p2.rating - p1.rating) / 400))
      p2_expected_score = 1.0 / (1 + 10 ** ((p1.rating - p2.rating) / 400))
      p1.rating = p1.rating + 32 * (0 - p1_expected_score)
      p2.rating = p2.rating + 32 * (1 - p2_expected_score)
      rating_change = (32 * (1 - p2_expected_score)).abs
    end

    return p1, p2, rating_change
	end

	def revert_wins(p1, p2)
    if self.player1_score > self.player2_score
      p1.wins -= 1
      p2.losses -= 1
      p1.rating -= self.rating_change
      p2.rating += self.rating_change
    else
      p2.wins -= 1
      p1.losses -= 1
      p2.rating -= self.rating_change
      p1.rating += self.rating_change
    end

    return p1, p2
	end

	def revert_ratings(p1, p2)
    if self.player1_score > self.player2_score
      p1.rating -= self.rating_change
      p2.rating += self.rating_change
    else
      p2.rating -= self.rating_change
      p1.rating += self.rating_change
    end

    return p1, p2
	end
end
