require 'rails_helper'

RSpec.describe "games/edit", type: :view do
  before(:each) do
    @game = assign(:game, Game.create!(
      :player1_id => 1,
      :player2_id => 1,
      :player1_score => 1,
      :player2_score => 1
    ))
  end

  it "renders the edit game form" do
    render

    assert_select "form[action=?][method=?]", game_path(@game), "post" do

      assert_select "input#game_player1_id[name=?]", "game[player1_id]"

      assert_select "input#game_player2_id[name=?]", "game[player2_id]"

      assert_select "input#game_player1_score[name=?]", "game[player1_score]"

      assert_select "input#game_player2_score[name=?]", "game[player2_score]"
    end
  end
end
