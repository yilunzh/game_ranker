class Player < ActiveRecord::Base
	has_many :game_players
	has_many :games, through: :game_players
	has_many :scores
	accepts_nested_attributes_for :scores
	

	def self.allNames()
			list = []

			for player in self.all 
				list.append(player.name)
			end

			return list
	end
end
