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

end
