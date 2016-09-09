class StaticPagesController < ApplicationController
	def stats
		@top_players = Player.where("wins>0 or losses>0").order(rating: :desc).limit(3)
	end

	def faq
	end
end
