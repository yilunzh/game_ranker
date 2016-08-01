json.array!(@players) do |player|
  json.extract! player, :id, :name, :department, :email, wins, losses, :rating
  json.url player_url(player, format: :json)
end
