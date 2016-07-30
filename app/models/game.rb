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

	def calculate_rating
	end
end
