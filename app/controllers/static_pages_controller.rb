class StaticPagesController < ApplicationController
	def stats
		@top_players = Player.where("wins>0 or losses>0").order(rating: :desc).limit(3)
		@player_longest_winning_streak = Player.longest_winning_streak
		@player_longest_losing_streak = Player.longest_losing_streak
	end

	def faq
	end
end
