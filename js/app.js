(function() {
	// initialize angular module
	var app = angular.module('CIC', [])
		.factory('spanel', function() {
			return {};
		})
		.controller('MenuController', ['spanel', function(spanel) {
			this.accessMoreData = function() {
				spanel.toggleShowing('accessMoreData');
			};
		}])
		.controller('PanelController', ['$scope', 'spanel', function($scope, spanel) {
			var panel = $scope.panel;
			panel.NUM_HELP_TABS = 6;
			panel.visible = true;
			panel.showOnMapVisible = false;
			panel.printVisible = false;
			panel.currentText = 'update';
			panel.currentHelpTab = 1;
			
			panel.setVisible = function(vis) {
				panel.visible = vis;
			};
			panel.isShowing = function(textId) {
				return panel.currentText === textId;
			};
			panel.toggleShowing = function(newTextId) {				
				if (panel.currentText === newTextId) panel.setVisible(!panel.visible);
				else {
					panel.setVisible(true);
					panel.currentText = newTextId;
				}
			};
			
			panel.selectHelpTab = function(newTab) {
				if (newTab > 0 && newTab <= panel.NUM_HELP_TABS) panel.currentHelpTab = newTab;
			};
			panel.incrementHelpTab = function(incr) {
				var newTabNum = panel.currentHelpTab + incr;
				if (newTabNum > 0 && newTabNum <= panel.NUM_HELP_TABS) {
					panel.currentHelpTab += incr;
				}				
			};
			panel.isHelpSelected = function(tab) {
				return panel.currentHelpTab === tab;
			};
			
			panel.goToIndicator = function(dataset, indicator) {
				indicator = indicator.replace("’", "'"); // replace apostrophes with single quotes
				
				panel.setVisible(false);
				CIC.update(dataset, indicator);
				
				// send to google analytics
				ga('send', 'event', 'map a new indicator', 'click', dataset + indicator);

			};
			
			// attach to service to use outside this controller
			spanel.toggleShowing = panel.toggleShowing;
		}])
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
		.directive('overlay', function() {
			return {restrict: 'E', templateUrl: 'assets/overlay.html'};
		})
		.directive('mailingForm', function() {
			return {restrict: 'E', templateUrl: 'assets/mailingForm.html'};
		})
		.directive('stateList', function() {
			return {restrict: 'A', templateUrl: 'assets/stateList.html'};
		})
		.directive('socialButtons', function() {
			return {restrict: 'A', templateUrl: 'assets/socialButtons.html'};
		});	
})();
