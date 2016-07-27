json.array!(@games) do |game|
  json.extract! game, :id, :player1_id, :player2_id, :player1_score, :player2_score, :date
  json.url game_url(game, format: :json)
end
