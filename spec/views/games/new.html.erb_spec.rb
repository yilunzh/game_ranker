require 'rails_helper'

RSpec.describe "games/new", type: :view do
  before(:each) do
    assign(:game, Game.new(
      :player1_id => 1,
      :player2_id => 1,
      :player1_score => 1,
      :player2_score => 1
    ))
  end

  it "renders new game form" do
    render

    assert_select "form[action=?][method=?]", games_path, "post" do

      assert_select "input#game_player1_id[name=?]", "game[player1_id]"

      assert_select "input#game_player2_id[name=?]", "game[player2_id]"

      assert_select "input#game_player1_score[name=?]", "game[player1_score]"

      assert_select "input#game_player2_score[name=?]", "game[player2_score]"
    end
  end
end
