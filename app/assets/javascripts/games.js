window.onload = function() {
	playerLookup();
}

function playerLookup() {
  // var availableTags = gon.player_names
  $( ".name" ).autocomplete({
    source: gon.player_names
  });
};