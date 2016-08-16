$(document).ready(function() {
	playerLookup();	
}); 

function playerLookup() {
  // var availableTags = gon.player_names
  $( ".name" ).autocomplete({
  	//source: ["Yilun Zhang","Chase Barth","Suhail Bayot","Jason Cohen"]
    source: gon.player_names
  });
};