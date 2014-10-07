(function() {
	// initialize angular module
	var app = angular.module('CIC', [])
		.controller('MenuController', function() {

		})
		.controller('MainController', function() {
			// -------------- Social Buttons -----------------
			// TODO almost functional - unable to get c.social.showing to toggle 
			/*this.social = {
				showing: false,
				toggle: function() {				
					// first build twitter link relative to indicator displayed on map
					var twitterContentIntro = "http://twitter.com/home?status=See%20";
					var twitterContentEnd = "%20data%20for%20your%20county%20by%20@NACoTweets%20%23NACoCIC%20www.naco.org%2FCIC";
					var i = currentDI.indexOf(' - ');
					var twitterContentDataset = encodeURIComponent(currentDI.substring(0, i));
					
					// show or hide
					if (socialButtons.showing) {
						d3.select('#rrssbContainer').transition().duration(500)
							.style('right', '-200px')
							.each('end', function() {
								socialButtons.showing = false;
							});
					} else {
						socialButtons.showing = true;
						d3.select('#twitterContent').attr('href', twitterContentIntro + twitterContentDataset + twitterContentEnd);
						d3.select('#rrssbContainer').transition().duration(500).style('right', '80px');
					}
				}
			};
			var socialButtons = this.social;
			
			// bind click on links
			$('.share-toggle').on('click', function(e) {
				e.stopPropagation();
				socialButtons.toggle();
			});	*/
		})
		.directive('indicatorList', function() {		
			return {
				restrict: 'A',
				templateUrl: 'assets/indicatorList.html',
				link: function(scope, elem) {
					// initialize smartmenus
					var menu = $(elem).closest('.nav');
					menu.smartmenus({
						subMenusSubOffsetX: 1,
						subMenusSubOffsetY: -8
					});
					menu.find('.sub-arrow').first().hide();
				}
			};
		})
		.directive('stateList', function() {
			return {restrict: 'A', templateUrl: 'assets/stateList.html'};
		})
		.directive('socialButtons', function() {
			return {restrict: 'A', templateUrl: 'assets/socialButtons.html'};
		});	
})();
