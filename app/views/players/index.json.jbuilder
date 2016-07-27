json.array!(@players) do |player|
  json.extract! player, :id, :name, :taunt, :ranking
  json.url player_url(player, format: :json)
end
