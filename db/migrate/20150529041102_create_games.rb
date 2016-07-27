class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :player1_id
      t.integer :player2_id
      t.integer :player1_score
      t.integer :player2_score

      t.timestamps null: false
    end
  end
end
