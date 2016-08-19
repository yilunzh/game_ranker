class Player < ActiveRecord::Base
	has_many :game_players
	has_many :games, through: :game_players
	has_many :scores

	validates :email, presence: true, uniqueness: { case_sensitive: false }
	accepts_nested_attributes_for :scores
	

	def self.allNames()
			list = []

			for player in self.all 
				list.append(player.name)
			end

			return list
	end

	def send_slack_notification()
      HTTP.post("https://hooks.slack.com/services/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", 
              :json => { text: ":table_tennis_paddle_and_ball: #{self.name} just signed up for Carvana Ping Pong. :+1:" })
  end
end
