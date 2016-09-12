class AddHasChampionshipBeltToPlayer < ActiveRecord::Migration
  def change
  	add_column :players, :has_championship_belt, :boolean
  end
end