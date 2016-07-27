class Player < ActiveRecord::Base
	has_many :player1s, :foreign_key => :player1_id, :class_name => :games
	has_many :player2s, :foreign_key => :player2_id, :class_name => :games
end
