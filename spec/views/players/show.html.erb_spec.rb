require 'rails_helper'

RSpec.describe "players/show", type: :view do
  before(:each) do
    @player = assign(:player, Player.create!(
      :name => "Name",
      :taunt => "Taunt",
      :ranking => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Taunt/)
    expect(rendered).to match(/1.5/)
  end
end
