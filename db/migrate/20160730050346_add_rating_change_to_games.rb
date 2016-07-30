class AddRatingChangeToGames < ActiveRecord::Migration
  def up
  	add_column :games, :rating_change, :float
  end

  def down
  	remove_column :games, :rating_change, :float
  end
end
