class CreatePlayersAndGames < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :department
      t.string :email
      t.integer :wins
      t.integer :losses
      t.float :rating

      t.timestamps null: false
    end

    create_table :games do |t|
      t.date :game_date
      t.integer :rating_change

      t.timestamps null: false
    end

    create_table :game_players do |t|
      t.belongs_to :player, index: true
      t.belongs_to :game, index: true

      t.timestamps null: false
    end
  end
end
