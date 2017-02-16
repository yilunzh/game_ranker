class Score < ActiveRecord::Base
	belongs_to :game
	belongs_to :player

	validates :score, presence: true, :numericality => { :greater_than_or_equal_to => 0 }

end
