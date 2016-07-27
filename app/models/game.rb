class Game < ActiveRecord::Base
	belongs_to :player1, :class => :player
	belongs_to :player2, :class => :player
end
