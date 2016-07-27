require 'rails_helper'

RSpec.describe "players/edit", type: :view do
  before(:each) do
    @player = assign(:player, Player.create!(
      :name => "MyString",
      :taunt => "MyString",
      :ranking => 1.5
    ))
  end

  it "renders the edit player form" do
    render

    assert_select "form[action=?][method=?]", player_path(@player), "post" do

      assert_select "input#player_name[name=?]", "player[name]"

      assert_select "input#player_taunt[name=?]", "player[taunt]"

      assert_select "input#player_ranking[name=?]", "player[ranking]"
    end
  end
end
