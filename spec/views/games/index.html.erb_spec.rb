require 'rails_helper'

RSpec.describe "games/index", type: :view do
  before(:each) do
    assign(:games, [
      Game.create!(
        :player1_id => 1,
        :player2_id => 2,
        :player1_score => 3,
        :player2_score => 4
      ),
      Game.create!(
        :player1_id => 1,
        :player2_id => 2,
        :player1_score => 3,
        :player2_score => 4
      )
    ])
  end

  it "renders a list of games" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
