require 'rails_helper'

RSpec.describe "games/show", type: :view do
  before(:each) do
    @game = assign(:game, Game.create!(
      :player1_id => 1,
      :player2_id => 2,
      :player1_score => 3,
      :player2_score => 4
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
  end
end
