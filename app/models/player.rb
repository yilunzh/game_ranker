class Player < ActiveRecord::Base
	has_many :game_players
	has_many :games, through: :game_players
	has_many :scores

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

	validates :email, presence: true, uniqueness: { case_sensitive: false }
	accepts_nested_attributes_for :scores

 	def game_logs
 		game_logs = []
    games = self.games
    games.each do |game|
      game_data = game.box_score
      is_win = is_win?(game_data)
      
      game_log = { id: game.id, 
      						 game_date: game.game_date, 
      						 result: is_win ? "W" : "L", 
                   rating_change: is_win ? "+#{game.rating_change}": "-#{game.rating_change}", 
                   matchup: "#{game_data[:winners].join(' / ')} - #{game_data[:losers].join(' / ')}",
                   score: "#{game_data[:winning_score]} - #{game_data[:losing_score]}" 
                	}
      
      game_logs << game_log
    end

    game_logs = game_logs.sort_by {|game_log| game_log[:game_date].to_time.to_i }.reverse!

    return game_logs
  end

  def send_slack_notification
	    HTTP.post("#{Rails.application.config.slack_carvana_ping_pong_url}", 
	            :json => { text: ":table_tennis_paddle_and_ball: #{self.name} just signed up for Carvana Ping Pong. :+1:" })
	end

  def invite_to_slack
      token = "#"
      email = self.email
      channels = "pingpong"
      HTTP.post("https://slack.com/api/users.admin.invite", 
                :json => {
                  token: token,
                  email: email,
                  channels: channels
                  })
  end

 	def self.find_all_player_names
 		names = []
 		Player.all.each do |player|
 			names << player.name
 		end
 		return names
 	end

 	def self.search(search)
 	  if search
      ranked_players = Player.where("LOWER(name) LIKE ? AND (wins>0 or losses>0)", "%#{search.downcase}%")
      unranked_players = Player.where("LOWER(name) LIKE ? AND (wins=0 AND losses=0)", "%#{search.downcase}%")
    else
      ranked_players = Player.where("wins>0 or losses>0").order(rating: :desc) 
      unranked_players = Player.where("wins=0 and losses=0")
    end

    return ranked_players, unranked_players
  end

  def self.longest_winning_streak
    return self.all.max_by(&:winning_streak)
  end

  def self.longest_losing_streak
    return self.all.max_by(&:losing_streak)
  end

  def self.has_championship_belt
    return self.where("has_championship_belt = true")[0]
  end

  def title_defense
    return self.games()
  end

	private

		def is_win?(game_data)
	 		if game_data[:winners].include?(self.name)
	 			return true
	 		else
	 			return false
	 		end
	 	end
end
