namespace :initialize do
  desc "TODO"
  task streak: :environment do
  	Player.all.each do |player|
  		if player.winning_streak == nil
	  		player.winning_streak = 0
	  	end

	  	if player.losing_streak == nil
	  		player.losing_streak = 0
  		end

  		player.save
  	end
  end

  task calculate_streak: :environment do
    Player.all.each do |p|
      winning_streak = 0
      losing_streak = 0

      games = p.games.order(created_at: :desc)
      games.each do |game|
        game_data = game.box_score
        if game_data[:winners].include?(p.name)
          #current winning streak
          if (winning_streak > 0) || (winning_streak == 0 and losing_streak == 0)
            winning_streak += 1
            losing_streak = 0
          else
            break
          end
        else
          #current losing streak
          if (losing_streak > 0) || (winning_streak == 0 and losing_streak == 0)
            losing_streak += 1
            winning_streak = 0
          else
            break
          end
        end
      end

      p.winning_streak = winning_streak
      p.losing_streak = losing_streak
      p.save
    end
  end
end
