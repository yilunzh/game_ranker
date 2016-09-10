class AddAvatarsToPlayers < ActiveRecord::Migration
  def self.up
    change_table :players do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :players, :avatar
  end
end
