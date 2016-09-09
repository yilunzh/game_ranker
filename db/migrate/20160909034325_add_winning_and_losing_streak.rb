class AddWinningAndLosingStreak < ActiveRecord::Migration
  def change
  	add_column :players, :winning_streak, :integer
  	add_column :players, :losing_streak, :integer
  end
end
