class Game < ActiveRecord::Base
	belongs_to :player1, :class => :player
	belongs_to :player2, :class => :player

	def player1_name
			player1.try(:name)
	end

	def player_name=(name)
		self.player1 = Player.find_by_name(name) if name.present?
	end

	def player2_name
			player2.try(:name)
	end

	def player_name=(name)
		self.player2 = Player.find_by_name(name) if name.present?
	end
end
