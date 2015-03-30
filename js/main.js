// default for noty alert system
$.noty.defaults.layout = 'center';
$.noty.defaults.killer = true;
$.noty.defaults.timeout = 3000;
$.noty.defaults.closeWith = ['click', 'button'];
$.noty.defaults.template = '<div class="noty_message"><div class="noty_text"></div><div class="noty_close"></div></div>';

var na_color = 'rgb(204,204,204)', // color for counties with no data
	highlight_color = 'rgb(225,0,0)', // highlight color for counties
	percent_colors = ['rgb(255,204,102)', 'rgb(255,153,51)', 'rgb(49,130,189)', 'rgb(7,81,156)', 'rgb(28,53,99)'],
	binary_colors = ['rgb(28,53,99)', 'rgb(255,153,51)'],
	categorical_colors = ['rgb(255,204,102)', 'rgb(255,153,51)', 'rgb(49,130,189)', 'rgb(7,81,156)', 'rgb(28,53,99)'],
	level_colors = ['rgb(255,204,102)', 'rgb(255,153,51)', 'rgb(49,130,189)', 'rgb(7,81,156)', 'rgb(28,53,99)'],
	neighbor_colors = d3.scale.category10();
	//percent_colors = ['rgb(189, 215, 231)','rgb(107, 174, 214)','rgb(49, 130, 189)','rgb(7, 81, 156)','rgb(28, 53, 99)']
	//categorical_colors = ['rgb(253,156,2)', 'rgb(0,153,209)', 'rgb(70,200,245)', 'rgb(254,207,47)', 'rgb(102,204,204)', 'rgb(69,178,157)']
	//level_colors = ['rgb(189, 215, 231)','rgb(107, 174, 214)','rgb(49, 130, 189)','rgb(7, 81, 156)','rgb(28, 53, 99)'];

CIC = {}; // main namespace containing functions, to avoid global namespace clutter

(function() {
	
	// -------------------------- Variable Definitions ---------------------------
	var localVersion = false;
	
	var default_dset = 'Population Levels and Trends';
	var default_ind = 'Population Level';
	
	var zoom = d3.behavior.zoom()
	    .scaleExtent([1, 10]);
	    	
	var width = document.getElementById('container').offsetWidth-90,
		height = width / 2,
		windowWidth = $(window).width(),
		windowHeight = $(window).height(),
		containerOffset = $('#container').offset(); // position of container relative to document.body
	
	var topo, stateMesh, path, svg, g;
	
	var tooltip = d3.select('#tt');
	var tipContainer = d3.select('#tipContainer');
	
	var CICstructure,
		data, // all county data
		legend, // the color legend
		selected, // county path that has been selected
		currentDataType = '', // current datatype showing
		currentDI = '', // current dataset/indicator showing
		currentSecondDI = '', // current secondary dataset/indicator showing; empty string if not showing,
		isPerCapita = false,
		pop_db = {}, // object to store population numbers for "per capita" data
		searchType = 'countySearch',
		searchState = 'State',
		measureType = 'quintile';
			
	var corrDomain = [], // only used for categorical data; a crosswalk for the range between text and numbers
		range = [], // array of colors used for coloring the map
		quantByIds = [], s_quantByIds = [], // for primary and secondary indicators, array of 2-4 objects (primary and companions) with data values indexed by FIPS 
		indObjects = [], s_indObjects = [], // for primary and secondary indicators, array of 2-4 objects (primary and companions) with indicator properties (category, dataset, definition, year, etc.)
		idByName = {}, // object of FIPS values indexed by "County, State"
		countyObjectById = {}, // object of data values and name indexed by FIPS
		countyPathById = {}; // svg of county on the map indexed by FIPS
	
	var frmrS, frmrT; // keep track of current translate and scale values
	var inTransition = false; // boolean to show whether in the middle of zooming in to county
	
	var small_large_array = []; // for threshold measuring types, need to store the smallest and largest value for the legend

	
	var setup = function(width, height) {
		var projection = d3.geo.albersUsa().translate([0, 0]).scale(width * 1.0);	    
		path = d3.geo.path().projection(projection);
		svg = d3.select("#map").insert("svg", "div")
	    	.attr("width", width)
	    	.attr("height", height)
	    	.attr("id", "map-svg")
	    	.append("g")
	    		.attr("transform", "translate(" + width / 2 + "," + height / 2 + ")")
	    		.call(zoom)
	    		.on("dblclick.zoom", null);		
		g = svg.append("g").attr("class", "counties");
		
		// adjust undermap width
		$('#undermap').width(width);
		
		// reset scale and translate values
	    frmrS = 1;
	    frmrT = [0, 0];	
		zoom.scale(frmrS);
		zoom.translate(frmrT);
		zoom.on('zoom', function() {
			inTransition = false;
		  	tooltip.classed("hidden", true); // hides on zoom or pan
		  	unhighlight();
			
		  	var t = d3.event.translate;
		  	var s = d3.event.scale;
		  	var h = height / 2;
		
		  	t[0] = Math.min(width / 2 * (s - 1), Math.max(width / 2 * (1 - s), t[0]));
		  	t[1] = Math.min(height / 2 * (s - 1), Math.max(height / 2 * (1 - s), t[1]));
			
		  	var zoomSmoothly = !(s === frmrS); // dont do smoothly if panning
			zoomMap(t, s, zoomSmoothly);			
		});
	
		if (windowWidth <= 768) {
			$('#secondIndLi').hide();
			resetSecondInd();
		} else {
			$('#secondIndLi').show();
		}
		
		positionZoomIcons();	
		positionInstruction();
	};
		
	var draw = function(topo, stateMesh) {
		var county = g.selectAll(".county").data(topo);	
		county.enter().insert("path")
			.attr("class", "county")
			.attr("d", path)
			.attr("id", function(d) { return d.id; });
	
		g.append("path").datum(stateMesh)
			.attr("id", "state-borders")
			.attr("d", path);
	
	
		// for click and double-click events; for touch devices, use click and double-tap 
		var mdownTime = -1;
		county.on('mousedown', function(d, i) {
			mdownTime = $.now();
		});
	
		var clicked = function(d, event) {
			highlight(d);
			hideInstructions();
			if (d3.select('.county.active').empty() !== true) {
				inTransition = true;
				var transition = CIC.executeSearchMatch(event.target.id);
				if (transition === false) inTransition = false;
				else transition.each('end.bool', function() { inTransition = false; });
			}		
		};
				
		if ($('html').hasClass('no-touch')) {
			// for non-touch screens
			county.each(function(d, i) {
				d.clickCount = 0;
			});
					
			county.on('click', function(d, i) {
				if ($.now() - mdownTime < 300) {
					d3.event.stopPropagation();
					var event = d3.event;
				
					d.clickCount++;
					if (d.clickCount === 1) {
						singleClickTimer = setTimeout(function() {
							d.clickCount = 0;
							if (!inTransition) clicked(d, event);
						}, 300);
					} else if (d.clickCount === 2) {
						clearTimeout(singleClickTimer);
						d.clickCount = 0;
						highlight(d);
						doubleClicked(d.id);
					}
				}
			});
		} else {
			// for touch screens; use double-tap instead of double-click
			county.on('click', function(d, i) {
				if ($.now() - mdownTime < 300) {
					d3.event.stopPropagation();
					if (!inTransition) clicked(d, d3.event);
				}
			});
			
			$('.county').addSwipeEvents().bind('doubletap', function(event, touch) {
				event.stopPropagation();
				inTransition = false;
				doubleClicked(event.target.id);
			});
		}
	};
	
	var setBehaviors = function() { 		
		d3.select('#map').on('click', unhighlight);
		d3.select('#showOnMap').on('click', function() {
	  		hideInstructions();
	  		if (d3.select('.county.active').empty() !== true) {
	  			var active_county = document.getElementsByClassName('county active')[0];
	  			var zoomTransition = zoomTo(active_county.id);
	  			populateTooltip(active_county);
	  			zoomTransition.each('end', function() {
					positionTooltip(active_county);  				
		  			tooltip.classed('hidden', false);
	  			});
	  		}
		});
		d3.select('#print').on('click', function() {
			var window_title = '';
			if (selected !== null) {
				window_title = countyObjectById[selected.id].geography.split(',')[0];
				window_title += ' Information, NACo Research';
			} else {
				window_title = 'County Information, NACo Research'; 
			}
			var specWindow = window.open('', window_title, 'left=0,top=0,toolbar=0,scrollbars=0,status=0');
			specWindow.document.write(document.getElementById('instruction-content').innerHTML);
			specWindow.document.write('<link rel="stylesheet" media="print" href="css/main.css">');
			specWindow.document.close();
			specWindow.focus();
			specWindow.print();
			specWindow.close(); // bug: doesn't reach this point if print dialog is closed by user
		});
	
		setDisabled();
		setDropdownBehavior();
		setSearchBehavior();
		setIconBehavior();
		setZoomIconBehavior();
		setDataButtonBehavior();
	};

	//Functions for Icons
	var setIconBehavior = function() {		
		$('#backToMapIcon, #backToMapIconText').on('click', function(e) {
			e.stopPropagation();
			tooltip.classed('hidden', true);
			unhighlight();
			zoomMap([0, 0], 1);
		});
		
		$('#resetAllIcon, #resetAllIconText').on('click', function(e) {
			e.stopPropagation();
			resetSecondInd();
		});
	
		$('.share-toggle').on('click', function(e) {
			e.stopPropagation();
			var twitterContentIntro = "http://twitter.com/home?status=See%20";
			var twitterContentEnd = "%20data%20for%20your%20county%20by%20@NACoTweets%20%23NACoCIC%20www.naco.org%2FCIC";
			var i=currentDI.indexOf(' - ');
			var twitterContentDataset = encodeURIComponent(currentDI.substring(0,i));
			if ($('.rrssb-buttons').is(':visible')) {
				var moveTransition = d3.select('#rrssbContainer').transition().duration(500).style('right', '-200px');
				moveTransition.each('end', function() {
					$('.rrssb-buttons').hide();
				});		
			} else {
				$('.rrssb-buttons').show();
				d3.select('#twitterContent').attr('href', twitterContentIntro + twitterContentDataset + twitterContentEnd);
				//console.log(twitterContentIntro + twitterContentDataset + twitterContentEnd);
				d3.select('#rrssbContainer').transition().duration(500).style('right', '80px');
			}		
		});	
	};
	var setDataButtonBehavior = function() {	
		$('#perCapitaButton').on('click', function() {
			NProgress.start();
			$(this).button('toggle');
			if ($(this).hasClass('active')) {
				// currently only does it for the primary indicator not the companions (would have to poll multiple years)
				isPerCapita = true;
				var year = indObjects[0].year;			
				var updateQuants = function() {
					for (var i = 0; i < quantByIds[0].length; i++) {
						if (quantByIds[0][i]) quantByIds[0][i] /= pop_db[year][i];
					}
				};
				
				if (!pop_db.hasOwnProperty(year)) {
					pop_db[year] = {};
					if (localVersion) {
				 		d3.tsv("data/local_data.tsv", function(error, countyData) {
				 			for (var i = 0; i < countyData.length; i++) {
				 				pop_db[year][countyData[i].id] = +countyData[i]['Population Levels and Trends - Population Level'];
				 			}
			 				updateQuants();
							updateView();
						});
					} else {
						var query_str = 'db_set=Demographics&db_ind=Pop_LT_Population&db_year=' + year;
						d3.xhr('/ciccfm/indicators.cfm?'+ query_str, function(error, request) {
							var responseObj = jQuery.parseJSON(request.responseText);
							var population = responseObj.DATA.POP_LT_POPULATION;
							for (var i = 0; i < population.length; i++) {
								pop_db[year][+responseObj.DATA.FIPS[i]] = +population[i];
								
							}
			 				updateQuants();
							updateView();
						});					
					}
				} else {
					updateQuants();
					updateView();
				}
			} else {
				isPerCapita = false;
				this.blur();
				for (var i = 0; i < quantByIds[0].length; i++) {
					if (quantByIds[0][i]) quantByIds[0][i] *= pop_db[indObjects[0].year][i];
				}
				updateView();
			}
			NProgress.done();
		});
		
		$('#quantileButton').on('click', function() {
			if ($('#thresholdButton').hasClass('active')) {
				NProgress.start();
				$(this).button('toggle');
				$('#thresholdButton').button('toggle');
				$('#thresholdInputContainer').hide();
				
				updateView();			
				NProgress.done();
			}		
		});
		
		$('#thresholdButton').on('click', function() {
			if ($('#quantileButton').hasClass('active')) {
				NProgress.start();
				$('#quantileButton').button('toggle');
				$(this).button('toggle');
				
				small_large_array = switchToThreshold(color.domain(), color.range());
				fillMapColors();
				legend = createLegend('threshold', null, small_large_array);
				showThresholdInputs();
				NProgress.done();
			}
		});
		
		$('#thresholdSubmit').on('click', function() {
			NProgress.start();
			var tvs = [];
			for (var i = 1; i <= 4; i++) {
				tvs.push(+$('#thresholdInput'+i).val());
			}
			
			// check to see if threshold values are valid
			for (var i = 1; i < tvs.length; i++) {
				if (tvs[i] <= tvs[i-1]) {
					noty({text: 'Invalid threshold values. Please try again.'});
					return;
				}
			}
			if (tvs[0] <= small_large_array[0] || tvs[3] >= small_large_array[1]) {
				noty({text: 'Invalid threshold values. Please try again.'});
				return;
			}
	
			color.domain(tvs);
			legend = createLegend('threshold', null, small_large_array);
			fillMapColors();
			NProgress.done();
		});
	};
	var resetSecondInd = function() {
		if (currentSecondDI !== '') {
			currentSecondDI = '';
			if (d3.select('.county.active').empty() !== true) {
				populateTooltip(selected);
				positionTooltip(d3.select('.county.active')[0][0]);
			}
			//d3.select('#secondIndText').html('Secondary Indicator' + '<span class="sub-arrow"></span>');
		}
	};
	
	var disableIndicators = function(type, name, indicator) {
		// type is either category, dataset, or indicator (e.g. disableIndicators('category', 'Administration') or disableIndicators('dataset', 'County Profile') or disableIndicators('indicator', 'County Profile', 'Census Region'))
		if (type === 'category') {
			$('.category[name="'+name+'"]').addClass('disabled')
				.find('.dataset').addClass('disabled')
				.find('.indicator').parent().addClass('disabled');
		} else if (type === 'dataset') {
			$('.dataset[name="'+name+'"]').addClass('disabled')
				.find('.indicator').parent().addClass('disabled');
		} else if (type === 'indicator') {
			$('.dataset[name="'+name+'"] .indicator[name="'+indicator+'"]').parent().addClass('disabled');
		}
	};
	var setDisabled = function() {
		// extends disabled to children
		$('.dataset.disabled').find('.indicator').parent().addClass('disabled');
		$('.category.disabled').find('.dataset').addClass('disabled');
		$('.category.disabled').find('.indicator').parent().addClass('disabled');
	};
	
	var setDropdownBehavior = function() {		
		var pickedIndicator = function(dataset, indicator, html) {
			$.SmartMenus.hideAll();		
			hideInstructions();			
			if (currentDI === dataset + ' - ' + indicator) {
			//	noty({text: 'Already showing "' + indicator + '"'});
			} else {
				CIC.update(dataset, indicator);
				//d3.select('#primeIndText').html(html + '<span class="sub-arrow"></span>');
				
				// send event tracking to google analytics
				ga('send', 'event', 'map an indicator', dataset, indicator);
			}
		};
		var pickedSecondaryIndicator = function(dataset, indicator, html) {
			$.SmartMenus.hideAll();
			hideInstructions();
			if (currentSecondDI === dataset + ' - ' + indicator) {
			//	noty({text: 'Already showing "' + indicator + '" as a secondary indicator'});
			} else {
				appendSecondInd(dataset, indicator);
				//d3.select('#secondIndText').html(html + '<span class="sub-arrow"></span>');

				// send event tracking to google analytics
				ga('send', 'event', 'compare an indicator', dataset, indicator);
			}
		};
				
		var setDropdownClick = function(menuId, endFunction) {
			d3.select(menuId).selectAll('.dataset').each(function() {
				var dataset = d3.select(this);		
				var datasetName = dataset.attr('name');
				
				// when clicking on dataset, update to first companion; but only for non-touch screens
				if ($('html').hasClass('no-touch')) {
					dataset.selectAll('a:not(.indicator)').on('click', function() {
						var DI = CIC.getInfo(datasetName).companions[0];
						var indHtml = dataset.select('.indicator[name="' + DI[1] + '"]').html();
						endFunction(DI[0], DI[1], indHtml);
					});
				}
		
				dataset.selectAll('li').on('click', function() {
					if (!d3.select(this).classed('disabled')) {
						var indicatorName = d3.select(this).select('.indicator').attr('name');
						endFunction(datasetName, indicatorName, this.innerHTML);
					} else {
						d3.event.stopPropagation();
						$.SmartMenus.hideAll();
					}
				});
			});
		};
	
		setDropdownClick('#primeInd', pickedIndicator);
		setDropdownClick('#secondInd', pickedSecondaryIndicator);
		
		// set a pointer cursor for all menu items
		d3.selectAll('.dataset a').style('cursor', 'pointer');
		d3.selectAll('.dataset.disabled a:first-child').style('cursor', 'default');
		d3.selectAll('.dataset').selectAll('li .disabled').selectAll('.indicator').style('cursor', 'default');
	};
	
	var setSearchBehavior = function() {
		var searchField = d3.select('#search-field');
		var stateDrop = d3.select('#state-drop-container');	
		d3.select('#search-submit').on('click', submitSearch);
		
		// set search type buttons to toggle
		$('#searchTypes .btn').on('click', function() {
			$('#' + searchType).button('toggle');
			searchType = $(this).attr('id');
			$(this).button('toggle');
			
			if (searchType === 'stateSearch') {
				stateDrop.classed('hidden', false);
				searchField.classed('hidden', true);
			} else {
				stateDrop.classed('hidden', true);
				searchField.classed('hidden', false);
				searchField.attr('placeholder', $(this).attr('name'));
			}
		});
	
		d3.select('#stateDrop').selectAll('a').on('click', function() {
			if (searchState !== this.name) {
				searchState = this.name;		
				d3.select('#stateDropText').html(searchState  + '<span class="sub-arrow"></span>');			
			}
			if (searchType === 'stateSearch' && searchState !== 'State') submitSearch();	
		});
	};
	
	var submitSearch = function() {
		d3.event.preventDefault();
			
		var search_str = d3.select('#search-field').property('value');
		var results_container = d3.select('#container');
	
		if (searchType === 'stateSearch') {
			// only state; return results of all counties within state
			if (searchState === 'MA' || searchState === 'RI' || searchState === 'CT') {
				noty({text: 'No county data available for this state.'});
			} else {
				state_search_str = 'state.cfm?statecode=' + searchState;
				displayResults(state_search_str);
			}
								
		} else if (searchType === 'countySearch') {
			if (search_str === '') {
				noty({text: 'Enter a county name to search.'});
				return;
			}
			
			// strip out state if there is one
			var countyName = search_str, stateName = '';
			if (search_str.indexOf(',') !== -1) {
				var csArray = search_str.split(',');
				stateName = csArray[1].trim().toUpperCase();
				countyName = csArray[0].trim();
			}
			
			// trim out the fat; takes out anything in geoDesc
			var fats = ['county', 'city', 'borough', 'parish'];
			for (var i = 0; i < fats.length; i++) {
				if (countyName.indexOf(fats[i]) !== -1) {
					countyName.replace(fats[i], '');
					countyName.trim();
				}
			}
				
			// check for entire phrase matches; only works if state was provided
			var geoDesc = [' County', ' City', ' Borough', ' Parish'];
			if (stateName !== '') {
				for (var j = 0; j < geoDesc.length; j++) {
					var search_comb = toTitleCase(countyName) + geoDesc[j] + ', ' + stateName;
					if (idByName[search_comb]) {
						CIC.executeSearchMatch(parseInt(idByName[search_comb]));
						return;
					}
				}
				
				// special case
				if (countyName.toLowerCase() === 'washington' && stateName === 'DC') { CIC.executeSearchMatch(11001); return; }
			}
			
			// check for partial word matches
			var pMatchArray = [];
			for (var ind in idByName) {
				var cs_array = ind.split(', ');
				if (stateName === cs_array[1] || stateName === '') {
					if (cs_array[0].toLowerCase().indexOf(countyName.toLowerCase()) != -1) {
						var pObj = {fips: parseInt(idByName[ind]), cs_array: cs_array};
						
						// check if exact match for county name (e.g. arlington -> arlington vs. darlington)
						for (var j = 0; j < geoDesc.length; j++) {
							pObj.fullCountyMatch = (toTitleCase(countyName + ' ' + geoDesc[j]) === cs_array[0]);
							if (pObj.fullCountyMatch === true) break;
						}
						
						pMatchArray.push(pObj);
					}
				}
			}				
	
			if (pMatchArray.length > 1) {
				// if one exact match, match that
				var numExactCountyMatch = 0, cMatchFIPS = -1;
				for (var i = 0; i < pMatchArray.length; i++) {
					if (pMatchArray[i].fullCountyMatch) {
						numExactCountyMatch++;
						cMatchFIPS = pMatchArray[i].fips;
					}
				}
				if (numExactCountyMatch === 1) {
					CIC.executeSearchMatch(cMatchFIPS);
					return;
				}
							
				// display all matches if more than one match
				showResults();
				var searchResults = d3.select('#results-container').append('div').attr('class', 'temp');
				searchResults.append('p')
					.style('text-align', 'center')
					.text('Your search returned ' + pMatchArray.length + ' results');
					
				var rTable = searchResults.append('div').attr('id', 'multiCountyResult').attr('class', 'container-fluid').append('table')
					.attr('class', 'table table-striped table-condensed table-hover').append('tbody');
				var rTitleRow = rTable.append('tr');
				var rTitleFIPS = rTitleRow.append('th').text('FIPS');
				var rTitleCounty = rTitleRow.append('th').text('County Name');
				var rTitleState = rTitleRow.append('th').text('State');
					
				for (var i = 0; i < pMatchArray.length; i++) {
					var countyObj = countyObjectById[pMatchArray[i].fips];
					var nameArr = countyObj.geography.split(', ');
					
					var countyRow = rTable.append('tr');
					var FIPS_cell = countyRow.append('td')
						.text(countyObj.id);
					var name_cell = countyRow.append('td')
						.classed('link', true)
						.text(nameArr[0]); 
					var state_cell = countyRow.append('td')
						.text(nameArr[1]);
	
					(function(cell, fips) {
						cell.on('click', function() { CIC.executeSearchMatch(fips); });
					})(name_cell, pMatchArray[i].fips);
				}
				
				showInstructions();
									
			} else if (pMatchArray.length == 1) {
				CIC.executeSearchMatch(pMatchArray[0].fips); // if only one match, display county
			} else {
				noty({text: 'Your search did not match any counties.'});
				document.getElementById('search_form').reset();	
			}
			
		} else if (searchType === 'citySearch') {
			// city search: use city-county lookup
			// first strip out city or anything after commas
			var city_str_index = search_str.toLowerCase().indexOf('city');
			var comma_index = search_str.toLowerCase().indexOf(',');
			if (city_str_index !== -1) search_str = search_str.substr(0, city_str_index);
			if (comma_index !== -1 && comma_index <= search_str.length) search_str = search_str.substr(0, comma_index);
			
			displayResults('city_res.cfm?city=' + search_str);
		}
	};
	
	CIC.executeSearchMatch = function(FIPS) {
		hideInstructions();
		$('#search-field').val('');
		
		var county = countyObjectById[+FIPS];
	    if (county) {
	    	$.noty.closeAll();
			highlight(county);
			var zoomTransition = zoomTo(+FIPS);
		    populateTooltip(county);
			zoomTransition.each('end', function() { 
				positionTooltip($('.county.active')[0]);
				
				if (indObjects[0].has_profile) {
					if (currentDI === 'County Economic Tracker - County Economic Profile') {
						var countyName = parseCountyName(+FIPS, county.geography);
						countyName = countyName.replace(/\s/g, '');
						window.open('http://explorer.naco.org/profiles/countytracker/' + countyName + '.pdf');
					} else if (currentDI === 'Municipal Bonds - County Muni Bonds Profiles') {
						if (isNaN(quantByIds[0][+FIPS])) {
							noty({text: '<strong>No Profile Available</strong>'});
						} else {
							var countyName = parseCountyName(+FIPS, county.geography);
							window.open('http://explorer.naco.org/profiles/county_muniBonds/muni_bonds_profile_' + countyName + '.pdf');
						}
					} else if (currentDI === 'Municipal Bonds - Statewide Muni Bonds Profiles') {
						var state = countyObjectById[+FIPS].STATE;
						window.open('http://explorer.naco.org/profiles/state_muniBonds/state_bonds_profiles' + state + '.pdf', '_blank');
					} else if (currentDI === 'Payment in Lieu of Taxes (PILT) - PILT Profiles') {
						if (quantByIds[0][+FIPS] === 0) {
							noty({text: '<strong>No Profile Available</strong></br>This county did not receive PILT in 2014!'});
						} else {
							window.open('http://explorer.naco.org/profiles/PILT/' + county.geography + '.pdf', '_blank');
						}
					} else if (currentDI === 'MFA Profiles - MFA Profiles') {
						var state = countyObjectById[+FIPS].STATE;
						if(state=="MT" | state=="OR" | state=="NH" | state=="DE"){
							noty({text: '<strong>No Profile Available</strong></br>This state does not have a sales tax.'});
						} else {
							window.open('http://explorer.naco.org/profiles/MFA/MITFA_' + state + '.pdf', '_blank');
						}
					}  else if (currentDI === 'Transportation Funding Profiles - Transportation Funding Profiles') {
						if (quantByIds[0][+FIPS] === NaN) {
							noty({text: '<strong>No Profile Available</strong>'});
						} else {
							var state = countyObjectById[+FIPS].STATE;
							window.open('http://explorer.naco.org/profiles/stateTransportation/state_summary_' + state + '.pdf', '_blank');
						}
					}  else if (currentDI === 'Transportation Funding Profiles - MAP-21 Profiles') {
						if (quantByIds[0][+FIPS] === NaN) {
							noty({text: '<strong>No Profile Available</strong>'});
						} else {
							var state = countyObjectById[+FIPS].STATE;
							window.open('http://explorer.naco.org/profiles/MAP-21/' + state + '.pdf', '_blank');
						}
					}  else if (currentDI === "U.S. Ex-Im Bank Financing - U.S. Ex-Im Bank County Profiles") {
						if (quantByIds[0][+FIPS] === 0) {
							noty({text: '<strong>No Profile Available</strong></br>This county did not receive direct Ex-Im Support.'});
						} else {
							var countyName = parseCountyName(+FIPS, county.geography);
							countyName = countyName.replace(/\s/g, '');
							window.open('http://explorer.naco.org/profiles/exim/' + countyName + '.pdf');
						}
					} else if (currentDI === "Secure Rural Schools (SRS) - SRS Profiles") {
						if (quantByIds[0][+FIPS] === 0) {
							window.open('http://explorer.naco.org/profiles/SRSProfiles/National.pdf');
						} else {
							var countyName = parseCountyName(+FIPS, county.geography);
							countyName = countyName.replace(/\s/g, '');
							window.open('http://explorer.naco.org/profiles/SRSProfiles/' + countyName + '.pdf');
						}
					}
					
				}
			});		
			return zoomTransition;
		} else {
			tooltip.classed('hidden', true);
			noty({text: 'Data not available for this county'});
			return false;
		}    
	};
	
	var displayResults = function(url) {
		showResults();
		$('#print').css('display', 'inline');
		
		d3.xhr('/ciccfm/'+ url, function(error, request){
			if (!error) {
				var response = request.responseText;
				if (response.indexOf('An error occurred') !== -1) {
					noty({text: 'Information for this county is not currently available.'});
					return;
				}
				
				var frame = d3.select("#results-container").append('div')
					.attr('class', 'container-fluid temp');
					
				frame.html(response);
				
				(url.indexOf('county') != -1) ? $('#showOnMap').show() : $('#showOnMap').hide();
				showInstructions();
			} else {
				console.log('Error retrieving data from : ' + '/ciccfm/' + url);
				console.log(error);
			}
		});
	};
	
	CIC.update = function(dataset, indicator) {
		NProgress.start();
		currentDI = dataset + ' - ' + indicator; 
		//tooltip.classed("hidden", true);
		$(document.body).scrollTop(0);
		
		// update global variables
		indObjects = allInfo(dataset, indicator);
		currentDataType = indObjects[0].dataType;
		
		// reset per capita button
		$('#perCapitaButton').removeClass('active');
		if (isNumFun(currentDataType)) $('#perCapitaButton').removeClass('disabled');
		else $('#perCapitaButton').addClass('disabled');
		
		$(document.body).off('dataReceived'); // shady, should only be setting event observe once, instead of re-defining it every time
		$(document.body).on('dataReceived', function(event, qbis, data) {
			NProgress.set(0.5);
			quantByIds = qbis;
			quantByIds = manipulateData(quantByIds, indObjects);
			for (var fips in data) {
				idByName[data[fips].geography] = fips;
				countyObjectById[fips] = data[fips];
			}
	
			updateView();
			updateDefinitions();
			NProgress.done(true);
		});
		
		getData(indObjects); // when data is received, it will fire an event on document.body
	};
	
	var appendSecondInd = function(dataset, indicator) {
		NProgress.start();
		currentSecondDI = dataset + ' - ' + indicator;
		s_indObjects = allInfo(dataset, indicator);
		
		$(document.body).off('dataReceived'); // shady, should only be setting event observe once, instead of re-defining it every time
		$(document.body).on('dataReceived', function(event, qbis) {
			NProgress.set(0.8);
			s_quantByIds = qbis;
			s_quantByIds = manipulateData(s_quantByIds, s_indObjects);
			if (d3.select('.county.active').empty() !== true) {
				populateTooltip(d3.select('.county.active')[0][0]);
				positionTooltip(d3.select('.county.active')[0][0]);
			}
			
			updateDefinitions();
			NProgress.done(true);
		});
		
		getData(s_indObjects);
	};
	
	var getData = function(indObjs) {
	 	// grab data and set up quantByIds and other objects
	 	if (localVersion) {
	 		d3.tsv("data/local_data.tsv", function(error, countyData) {
		 		var qbis = [];
				for (var i = 0; i < indObjs.length; i++) qbis.push([]);
		
				countyData.forEach(function(d) {			
					for (var i = 0; i < indObjs.length; i++) {
						qbis[i][d.id] = isNumFun(indObjs[i].dataType) ? parseFloat(d[indObjs[i].DI]) : d[indObjs[i].DI];
						if (indObjs[i].hasOwnProperty('unit') && indObjs[i].unit.indexOf('thousand') !== -1) qbis[i][d.id] *= 1000; // will remove this eventually
						if (indObjs[i].hasOwnProperty('unit') && indObjs[i].unit.indexOf('million') !== -1) qbis[i][d.id] *= 1000000; // will remove this eventually
					}
		
					idByName[d.geography] = d.id;
					countyObjectById[d.id] = d;
				});
				attachCountyTitles();
				
				$(document.body).trigger('dataReceived', [qbis]);
	 		});
	 	} else {
	 		// need to sort by dataset because we want to send one query per dataset needed
		  	var indicatorList = {}; // list of indicators indexed by dataset then indexed by year
		  	for (var i = 0; i < indObjs.length; i++) {		  		
			  	var DI = indObjs[i].dataset+' - '+indObjs[i].name;
			  	
			  	// for debugging
		  		if (!indObjs[i].hasOwnProperty('name')) console.log('Indicator #' + i + ' not matched in CIC structure');
			  	if (!crosswalk.hasOwnProperty(DI)) console.log('Indicator #' + i + ' not matched in crosswalk');
			  	
			  	var crossObject = crosswalk[DI];
			  	var year = indObjs[i].year;
		
		  		if (!indicatorList.hasOwnProperty(crossObject.db_dataset)) indicatorList[crossObject.db_dataset] = {};
				var dataset_obj = indicatorList[crossObject.db_dataset];
				if (!dataset_obj.hasOwnProperty(year)) dataset_obj[year] = [];
				dataset_obj[year].push(crossObject.db_indicator);
				
				// if an indicator has a "comapnion" year indicator, query that indicator as well
				if (indObjs[i].hasOwnProperty('year_ind')) {
					var year_ind_obj = crosswalk[indObjs[i].dataset+' - '+indObjs[i].year_ind];
					dataset_obj[year].push(year_ind_obj.db_indicator);
				}
		  	}
	
			// configure query string for each dataset
			var qsa = []; // array of query strings
		  	for (var ds_name in indicatorList) {
		  		for (var year in indicatorList[ds_name]) {
		  			var ind_list = indicatorList[ds_name][year];
			  		var query_str = 'db_set=' + ds_name + '&db_year=' + year + '&db_ind='; // append dataset name and year		  		
			  		for (var j = 0; j < ind_list.length; j++) {
			  			query_str += ind_list[j]; // append each indicator
			  			if (j != ind_list.length - 1) query_str += ',';
			  		}
			  		qsa.push(query_str);
			  	}
		  	}
			    	
	    	var getRequest = function(query_str, queryIndex) {
			  	d3.xhr('/ciccfm/indicators.cfm?'+ query_str, function(error, request){
			    	try {
			    		var responseObj = jQuery.parseJSON(request.responseText);
			    	}
			    	catch(error) {
			    		noty({text: 'Error retrieving information from database.'});
			    		NProgress.done(true);
			    	}
			    	if (responseObj.ROWCOUNT === 0) noty({text: 'Database error: ROWCOUNT = 0'});
			    	
			    	// restructure response object to object indexed by fips, and add it to "data"	
			    	for (var i = 0; i < responseObj.DATA.FIPS.length; i++) {
			    		var fips = parseInt(responseObj.DATA.FIPS[i]);
			    		if (!data.hasOwnProperty(fips)) data[fips] = {id: fips};
			    		for (var j = 1; j < responseObj.COLUMNS.length; j++) {
			    			var property = responseObj.COLUMNS[j]; // does not avoid duplicate property names (e.g. primary: "Total County", companion1: "Total County")
			    			if (!data[fips].hasOwnProperty(property)) data[fips][property] = responseObj.DATA[property][i];
			    		}
			    		if (!data[fips].hasOwnProperty('geography')) data[fips].geography = data[fips].COUNTY_NAME + ', ' + data[fips].STATE;
			    	}
	
			    	$(document.body).trigger('requestReceived');		    	
				});
			};
			
	    	var data = {};
			var requestsReceived = 0;
			$(document.body).off('requestReceived'); // shady, should only be setting event observe once, instead of re-defining it every time
			$(document.body).on('requestReceived', function() {
				requestsReceived++;
				
				// all requests have been received; send back event trigger after formatting
				if (requestsReceived === qsa.length) {
					
					// write data to "quantById" format
					var qbis = [];
					for (var i = 0; i < indObjs.length; i++) qbis.push([]);				
					for (var fips in data) {
						for (var i = 0; i < indObjs.length; i++) {
							var value = data[fips][indObjs[i].db_indicator.toUpperCase()];
							qbis[i][fips] = isNumFun(indObjs[i].dataType) ? parseFloat(value) : value;
							if (indObjs[i].hasOwnProperty('unit') && indObjs[i].unit.indexOf('thousand') !== -1) qbis[i][fips] *= 1000; // will remove this eventually
							if (indObjs[i].hasOwnProperty('unit') && indObjs[i].unit.indexOf('million') !== -1) qbis[i][fips] *= 1000000; // will remove this eventually
						}
			
						idByName[data[fips].geography] = fips;
						countyObjectById[fips] = data[fips];						
					}
					attachCountyTitles();
	
					$(document.body).trigger('dataReceived', [qbis, data]);
				}
			});
			
			for (var i = 0; i < qsa.length; i++) getRequest(qsa[i], i);
		}	
	};
	
	var updateView = function() {
		var isNumeric = isNumFun(currentDataType);
		var quantById = quantByIds[0];	
	
		// define domain based on dataType
		if (isNumeric) {
			var domain = [];
			for (var ind in quantById) domain[ind] = quantById[ind];
		} else if (currentDataType === 'binary') {
			corrDomain = [];
			for (var ind in quantById) {
				if (quantById[ind] === 0 || quantById[ind] === 1) corrDomain[ind] = quantById[ind];
			}
			var vals = {'Yes': 1, 'No': 0};
		} else if (currentDataType === 'categorical') {
			corrDomain = [];
			// translating string values to numeric values
			var numCorrVals = 0, vals = {}, corrVal = 0;
			
			if (indObjects[0].hasOwnProperty('order')) {
				vals = indObjects[0].order;
				for (var ind in quantById) corrDomain[ind] = vals[quantById[ind]];
			} else {
				for (var ind in quantById) {		
					if (quantById[ind] !== '.' && quantById[ind] !== '' && quantById[ind] !== null) {
						if (!vals.hasOwnProperty(quantById[ind])) {
							// create corresponding value array (e.g. vals = {"Gulf of Mexico": 0, "Pacific Ocean": 1})
							vals[quantById[ind]] = corrVal;
							corrVal++;
						}
						// change domain value to numeric representation (corrDomain[0] goes from "Gulf of Mexico" to 0)
						corrDomain[ind] = vals[quantById[ind]];
					}
				}
			}
		
			for (var ind in vals) numCorrVals++; // keep track of number of categories
		}
	
		// define range i.e. color output
		switch(currentDataType) {
			case "percent":
				range = percent_colors;
				break;
			case "binary":
				range = binary_colors;
				break;
			case "categorical":
				// max is 5 categories
				if (numCorrVals === 2) range = binary_colors;
				else {
					range = [];
					var availColors = categorical_colors;
					for (var i = 0; i < numCorrVals; i++) range.push(availColors[i]);
				}
				break;
			default:
				range = level_colors;
		}
	
		// set domain and range
		if (currentDataType !== 'none') {
			color = d3.scale.quantile();
			if (isNumeric) color.domain(domain).range(range);
			else color.domain(corrDomain).range(range);
		}
		
		// define measureType
		// if 0 spans more than one quintile, then switch to quartiles
		// check if a value spans more than one quantile; if so, switch to threshold
		// threshold trumps quartile trumps quintile
		measureType = 'quintile';
		if (isNumeric) {
			if (indObjects[0].hasOwnProperty('thresholds')) {
				measureType = 'threshold';
			} else {
				var quantiles = color.quantiles();
				
				// if more than one fifth of counties are zeros, switch to quartile
				if (quantiles[0] === 0) {
					measureType = 'quartile';
					
					// we do not want "zero" to be considered during the quartile categorization
					var q_domain = [];			
					for (var ind in domain) {
						if (+domain[ind] !== 0) q_domain[ind] = domain[ind];
					}
		
					var q_range = [];
					for (var i = 1; i < level_colors.length; i++) q_range.push(level_colors[i]);
					color.domain(q_domain).range(q_range);
					
					quantiles = color.quantiles();
				}
				
				// check if any quantile thresholds are the same value, if so switch to threshold 
				for (var i = 0; i < quantiles.length - 1; i++) {
					if (quantiles[i] === quantiles[i+1]) {
						measureType = 'threshold';
						break;
					}
				}
				var d = color.domain();
				if (measureType === 'quartile' && quantiles[0] <= 1) measureType = 'threshold';
				if (quantiles[0] === d[0] || quantiles[quantiles.length - 1] === d[d.length - 1]) measureType = 'threshold';
			}
			
			if (measureType === 'threshold') {
				small_large_array = switchToThreshold(domain, range);
			} else if (measureType === 'quartile') {
				domain = q_domain;
				range = q_range;
			}
		}
		
		// update quantile/threshold buttons based on dataType and measureType
		if (isNumeric) {
			if (measureType === 'threshold') {
				$('#quantileButton').addClass('disabled');
				$('#quantileButton').removeClass('active');
				$('#thresholdButton').addClass('active');
				showThresholdInputs();
			} else {
				$('#quantileButton').removeClass('disabled');
				$('#quantileButton').addClass('active');
				$('#thresholdButton').removeClass('disabled active');		
				$('#thresholdInputContainer').hide();
			}
		} else {
			$('#quantileButton, #thresholdButton').addClass('disabled');
			$('#quantileButton, #thresholdButton').removeClass('active');
			$('#thresholdInputContainer').hide();
		}
		
		// if county is active and tooltip is not showing, unhighlight selected county
		if (d3.select('.county.active').empty() !== true && $('#tt').hasClass('hidden') === true) unhighlight();
		
		fillMapColors(); // fill in map colors
		
		// create the legend
		if (currentDataType === 'none') {
			changeLegendTitle();
			$('#quantileLegend').css('visibility', 'hidden');
		} else {
			$('#quantileLegend').css('visibility', 'visible');
			if (isNumeric) {
				legend = createLegend(measureType, null, small_large_array); // note: small and large are included for "threshold" types to place in legend
			} else {
				legend = createLegend(measureType, vals); // note: vals is a correspondence array linking strings with numbers for categorical dataTypes
			}
		}
		
		if (d3.select('.county.active').empty() !== true && $('#tt').hasClass('hidden') === false) {
			// if county is active and tooltip is showing, re-populate tooltip
			var active_county = d3.select('.county.active')[0][0];
			populateTooltip(active_county);
			positionTooltip(active_county);
		}
		
		// list source
		d3.select("#sourceContainer").selectAll("p").remove();
		d3.select('#sourceContainer').append('p').attr("id", "sourceText")
			.html('<span style="font-weight:400;">Source:</span>' + indObjects[0].source + ((indObjects[0].supressYear) ? '.' : ', ' + indObjects[0].year));
		
				
		// if showing a "county profile" indicator, show a mini help dialog
		if (indObjects[0].has_profile) {
			var text = 'Click once on a county to see their county profile.';
			if (indObjects[0].name === 'MFA Profiles' || indObjects[0].name === 'Transportation Funding Profiles' || indObjects[0].name === 'Statewide Muni Bonds Profiles' || indObjects[0].name === 'MAP-21 Profiles') text = 'Click once on a county to see their state profile.';
			noty({
				type: 'alert',
				text: '<strong>' + text + '</strong></br></br>Please make sure to enable popups.',
				timeout: false
			});
		}
	};
	
	var switchToThreshold = function(domain, range) {
		color = d3.scale.threshold(); // quantize scale, threshold based
		
		// collect all values in array and sort in ascending order
		var new_domain = [];
		for (var i = 0; i < domain.length; i++) {
			if (!isNaN(domain[i])) new_domain.push(domain[i]);
		}
		new_domain.sort(function(a, b) { return (a - b); });
		large = new_domain[new_domain.length - 1];
		small = (currentDataType === 'level') ? 0 : new_domain[0]; 
	
		
		if (indObjects[0].hasOwnProperty('thresholds')) {
			domain = indObjects[0].thresholds;
		} else {
			if (currentDataType !== 'percent' && large <= 5) {
				domain = [1, 2, 3, 4]; // really only works for natural numbers; need a better fix
			} else {
				domain = [];
				
				if (currentDataType === 'percent') {
					// linear scale
					for (var i = 1; i < 5; i++) domain.push(small + (i * (large - small) / 5));
				} else {				
					// logarithmic scale based 10
					for (var i = 1; i < 5; i++) domain.push(large * Math.pow(10, i - 5));
					for (var i = 0; i < domain.length; i++) { 
						if (indObjects[0].format_type) {
							if (indObjects[0].format_type === 'dec1') domain[i] = domain[i].toFixed(1);
							else if (indObjects[0].format_type === 'dec2') domain[i] = domain[i].toFixed(2);
						} else domain[i] = Math.round(domain[i]);
					}	
					
					// check to make sure no threshold values are the same
					if (domain[0] <= 0) domain[0] = 1;
					for (var i = 1; i < domain.length; i++) {
						if (domain[i] <= domain[i-1]) domain[i] = domain[i-1] + 1;
					}
				}
			}
		}
		color.domain(domain).range(range);			
			
		return [small, large];
	};
	var showThresholdInputs = function() {
		$('#thresholdInputContainer').show();
		var domain = color.domain();
		for (var i = 0; i < 4; i++) {
			$('#thresholdInput'+(i+1)).val(domain[i]);
		}
	};
	
	var manipulateData = function(qbis, indObjs) {
		// MANUAL DATA MODIFICATIONS; this whole function should disappear...better to change database values
		for (var i = 0; i < qbis.length; i++) {
			for (var ind in qbis[i]) {
				// if part of exception counties (connecticut, massachusetts, some of alaska, va independent cities), make it not available
				if (exceptionCounties.hasOwnProperty(+ind)) {
					qbis[i][ind] = '.';
				} else {
					if (indObjs[i].dataType === 'binary') {
						// modify binary values
						if (qbis[i][ind] == true || qbis[i][ind] === 'Yes') qbis[i][ind] = 1;
						else if (qbis[i][ind] == false || qbis[i][ind] === 'No') qbis[i][ind] = 0;
						else if (qbis[i][ind] === 2) qbis[i][ind] = 1;
						
						if (indObjs[i].name === 'Consolidation') {
							if (qbis[i][ind] === null) qbis[i][ind] = 0;
						}
					} else if (indObjs[i].dataType === 'categorical') {
						if (qbis[i][ind] === 0) qbis[i][ind] = 'None';

						if (indObjs[i].name === 'Level of CBSA') {
							if (qbis[i][ind] === 1) qbis[i][ind] = 'Metropolitan';
							else if (qbis[i][ind] === 2) qbis[i][ind] = 'Micropolitan';
						}
					} else if (indObjs[i].dataType === 'level') {
						if (indObjs[i].category === 'Federal Funding') {
							if (isNaN(qbis[i][ind])) qbis[i][ind] = 0; // assume if county is unavailable in database, the county gets 0 funding 
							
							// for pilt, change land areas from square miles to acres
							if (indObjs[i].DI === 'Payment in Lieu of Taxes (PILT) - PILT per Acre') {
								qbis[i][ind] /= 640;
							} else if (indObjs[i].DI === 'Payment in Lieu of Taxes (PILT) - Total Federal Land Area' || indObjs[i].DI === 'Payment in Lieu of Taxes (PILT) - Total County Area') {
								qbis[i][ind] *= 640;
							}
						} else if (indObjs[i].name === 'Fixed Internet Connections') {
							if (qbis[i][ind] === 5) qbis[i][ind] = 1000;
							else if (qbis[i][ind] >= 1) qbis[i][ind] = qbis[i][ind] * 200 - 100;
						} else if (indObjs[i].name === 'Supported Exporters' | indObjs[i].name === 'U.S. Ex-Im Bank County Profiles') {
							if (qbis[i][ind] === 5) qbis[i][ind] = 4;
						}
					} else if (indObjs[i].dataType === 'percent') {
						if (indObjs[i].dataset === 'Educational Attainment') qbis[i][ind] /= 100;	
					} else if (indObjs[i].name === 'CSA Code') {
						if (qbis[i][ind] === 0) qbis[i][ind] = null;
					}				
				}
			}
		}
		return qbis;
	};
	
	var allInfo = function(dataset, indicator){
		var firstObj = CIC.getInfo(dataset, indicator);
		var objArray = [firstObj];
		for (var i = 0; i < firstObj.companions.length; i++) {
			if (objArray.length < firstObj.companions.length) {
				var obj = CIC.getInfo(firstObj.companions[i][0], firstObj.companions[i][1]);
				var isDisabled = $('.dataset[name="'+obj.dataset+'"] .indicator[name="'+obj.name+'"]').parent().hasClass('disabled'); // checks if companion is disabled or not
				if (obj.name !== firstObj.name && !isDisabled) objArray.push(obj);			
			}
		}	
		return objArray;
	};
	
	CIC.getInfo = function(dataset, indicator){
		var selectedInd = {};
		var structure = CICstructure.children;
		for (var i = 0; i < structure.length; i++) {				
			for (var j = 0; j < structure[i].children.length; j++) {
				if (structure[i].children[j].name === dataset) {
					var Jdataset = structure[i].children[j];
					
					// dataset properties
					selectedInd.category = structure[i].name;
					selectedInd.dataset = Jdataset.name;
					selectedInd.year = d3.max(Jdataset.years);
					selectedInd.source = Jdataset.source;
					selectedInd.companions = Jdataset.companions;
					if (Jdataset.hasOwnProperty('yearSpan')) selectedInd.yearSpan = Jdataset.yearSpan;
					if (Jdataset.hasOwnProperty('vintage')) selectedInd.vintage = Jdataset.vintage;
					if (Jdataset.hasOwnProperty('legend_title_footer')) selectedInd.legend_title_footer = Jdataset.legend_title_footer;
					if (Jdataset.hasOwnProperty('supressYear')) selectedInd.supressYear = Jdataset.supressYear;
					
					if (typeof indicator !== 'undefined') {
						for (var h = 0; h < Jdataset.children.length; h++) {
							if (indicator === Jdataset.children[h].name) {
								// indicator properties
								for (var ind in Jdataset.children[h]) {
									//if (ind === 'dataType' && Jdataset.children[h][ind] === 'binary') Jdataset.children[h][ind] = 'categorical'; // convert binary to categorical
									selectedInd[ind] = Jdataset.children[h][ind];
								}
								selectedInd.DI = selectedInd.dataset + ' - ' + selectedInd.name;
								if (localVersion === false) {
									for (var prop in crosswalk[selectedInd.DI]) {
										if (!selectedInd.hasOwnProperty(prop)) selectedInd[prop] = crosswalk[selectedInd.DI][prop];
									}
								}
								break;
							}
						}
					}
					break;
				}
			}
		}
		return selectedInd;
	};
	
	var fillMapColors = function() {
		var getColor = function(type, d, i) {
			switch(type) {
				case 'binary':
					return (corrDomain.hasOwnProperty(d.id)) ? range[corrDomain[d.id]] : na_color;
				case 'categorical':
					return isNaN(corrDomain[d.id]) ? na_color : range[corrDomain[d.id]];
				case 'level':
				case 'level_np':
				case 'percent':
					if (measureType === 'quartile' && +quantByIds[0][d.id] === 0) {
						return level_colors[0];
					} else {
						return isNaN(quantByIds[0][d.id]) ? na_color : color(quantByIds[0][d.id]);
					}
				default:
					// for datatype: "none", colors it with category10 and neighbors with same value are same color
					var val = quantByIds[0][d.id];
					if (typeof val === 'undefined' || val === null || val === 0) return na_color;
					else {	
						if (!colorKeyArray.hasOwnProperty(val)) {
							d.color = d3.max(neighbors[i], function(n) { return topo[n].color; }) + 1 | 0;
							colorKeyArray[val] = d.color;
						} else {
							d.color = colorKeyArray[val];
						}
						return neighbor_colors(d.color);	
					}
			}
		};
		
		var colorKeyArray = {}; // used for datatype: "none"
		
		g.selectAll('.counties .county:not(.active)').transition().duration(750).style('fill', function(d, i) {
			return getColor(currentDataType, d, i);
		});
		
		// for selected county, keep highlighted color but still find map color and store it
		g.selectAll('.counties .county.active').transition().duration(750).style('fill', function(d, i) {
			frmrFill = getColor(currentDataType, d, i);
			return highlight_color;
		});
	};
	
	var updateDefinitions = function() {
		d3.select("#definitionsContainer").selectAll("p").remove();
		var defContainer = d3.select("#definitionsContainer").append("p").attr("id", "definitionsText");
		defContainer.append('div').html('<i>Definitions</i>:');
		for (var i = 0; i < indObjects.length; i++) {
			defContainer.append('div').html('<b>' + indObjects[i].name + '</b>: ' + indObjects[i].definition);
		}
		if (currentSecondDI !== '') {
			for (var i = 0; i < s_indObjects.length; i++) {
				defContainer.append('div').html('<b>' + s_indObjects[i].name + '</b>: ' + s_indObjects[i].definition);
			}	 
		}	
	};
	
	var createLegend = function(measure_type, keyArray, dataVals) {
		d3.selectAll(".legend svg").remove();
	
		var primeIndObj = indObjects[0];
		if (primeIndObj.dataType !== 'none') {	
			var options = {
				boxHeight : 18,
				boxWidth : 58,
				dataType : primeIndObj.dataType,
				unit	 : primeIndObj.unit,
				measure_type: measure_type,
				formatFnArr: format
			};
			if (keyArray) options.keyArray = keyArray;
			if (dataVals) options.small_large = dataVals;
			if (primeIndObj.name === 'Body of Water' || primeIndObj.name === 'County Supported Local Health Departments (LHDs)') options.boxWidth = 68;
			if (primeIndObj.hasOwnProperty('format_type')) options.format_type = primeIndObj.format_type;
			if (primeIndObj.hasOwnProperty('supressMinMax')) options.supressMinMax = primeIndObj.supressMinMax;
			if (primeIndObj.hasOwnProperty('longLegendNames')) options.longLegendNames = primeIndObj.longLegendNames;
	
			changeLegendTitle();
			return colorlegend("#quantileLegend", color, "quantile", options);
		} else return false;
	};
	var changeLegendTitle = function() {
		var primeIndObj = indObjects[0];
		var subtitle = primeIndObj.name;
		if (primeIndObj.hasOwnProperty('unit') && primeIndObj.unit.indexOf('per ') !== -1 && subtitle.indexOf('per ') === -1) {
			subtitle += ' (' + primeIndObj.unit + ')';
		}
		//shouldn't be if and else, these properties should be able to be stacked
		if (primeIndObj.hasOwnProperty('legend_title_footer')) {
			var legendTitle = primeIndObj.dataset + primeIndObj.legend_title_footer;
		} else if(primeIndObj.hasOwnProperty('yearSpan')){
			var legendTitle = primeIndObj.yearSpan + ' ' + primeIndObj.dataset;
		} else {
			var legendTitle = primeIndObj.year + ' ' + primeIndObj.dataset;		
		}
		if (primeIndObj.name === 'MFA Profiles') legendTitle = 'Sales Tax' + primeIndObj.legend_title_footer;
		
		// special titles for profiles
		if (primeIndObj.has_profile === true) subtitle = primeIndObj.companions[0][1];
		
		d3.select('#legendTitle').text(legendTitle);
		d3.select('#legendSubtitle').text(subtitle);
	};
	
	var populateTooltip = function(d) {
		var getAttributes = function(objs) {
			// find out if all indicators are in same dataset
			var sameDataset = true;
			for (var i = 1; i < objs.length; i++){
				if (objs[i].dataset !== objs[0].dataset) {
					sameDataset = false;
					break;
				}
			}
	
			// find out if all indicators are from same year
			var allSameYear = true;
			for (var i = 1; i < objs.length; i++) {
				if (objs[i].year !== objs[0].year) {
					allSameYear = false;
					break;
				}
			}
			return {sameDataset: sameDataset, allSameYear: allSameYear};				
		};		
		var writeHeader = function(objs, attr) {
			// title for group of indicators; either name of dataset or category; includes year if all from same year
			row.append('td').attr({'class': 'datasetName', 'colspan': '2'}).text(function() {
				var titleText = (attr.sameDataset) ? objs[0].dataset : objs[0].category;
				if(objs[0].hasOwnProperty('yearSpan')){
					return (attr.allSameYear) ? titleText + ', ' + objs[0].yearSpan : titleText;
				}else return (attr.allSameYear) ? titleText + ', ' + objs[0].year : titleText;
			});			
		};
		var writeIndicators = function(row, obj, quant, attr, isSecondary) {
			// set up unit and formatted value
			var unit = (obj.hasOwnProperty('unit')) ? obj.unit : '';		
			if (obj.hasOwnProperty('format_type')) {
				var value = format_tt[obj.format_type](quant[d.id], unit);
			}  else {
				var value = format_tt[obj.dataType](quant[d.id], unit);
			}
						
			// adjust unit and value for display
			if (value === '$NaN' || value === 'NaN' || value === 'NaN%' || value === null || value === '.' || (isNumFun(obj.dataType) && isNaN(quant[d.id])) ) {
				value = 'Not Available';
				unit = '';
			} else {
				if (typeof value === 'string') value = value.charAt(0).toUpperCase() + value.substr(1);
	
				if (unit.indexOf('dollar') !== -1 || unit.indexOf('year') !== -1) unit = '';
				else if (unit !== '') {				
					// change unit from plural to singular if necessary
					if (parseFloat(value.toString().replace(/[^\d\.\-]/g, '')) === 1) {
						if (unit.charAt(unit.length - 1) === 's') {
							unit = unit.substr(0, unit.length - 1); // "1 employee"
						} else if (unit.indexOf('s per') !== -1) {
							var index = unit.indexOf('s per');
							unit = unit.substr(0, index) + unit.substr(index + 1);
						}
					}
				}
			}
			
			// manual manipulation of tooltip values shown T_T
			//CETNulls finds coded values of 999 and -999 that indicate "No Recession" and "No REcoverey", respectively
			if (obj.name === 'Fixed Internet Connections') {
				if (value === '1,000') value = '800-1000';
				else value = (parseInt(value) - 100) + '-' + (parseInt(value) + 100);
			} else if (obj.name === 'Fixed Internet Providers' || obj.name === 'Mobile Internet Providers') {
				if (value === '1') {
					value = '1-3';
					unit = unit + 's';
				}
			} else if (obj.hasOwnProperty('CETNulls')){
					if (value === '99900.0%' || value === '1000'){
						value = 'No Recession';
						unit = (unit==='PPT') ? unit = '' : unit = unit;
					}
					else if (value ==='-99900.0%' || value === '-1000'){
						value = 'No Recovery';
						unit = (unit==='PPT') ? unit = '' : unit = unit;
					}
			} else if (obj.name === 'Supported Exporters') {
				if (value === '4') {
					value = '1-5';
				}
			}
			
			// define name variable and cut off before parenthesis if there is one
			var name = (obj.name.indexOf('(') != -1) ? obj.name.substring(0, obj.name.indexOf('(')) : obj.name;
			
			// if all indicators displayed in tooltip are not from same year, add year before name
			if (!attr.allSameYear && !obj.hasOwnProperty('year_ind')) name = obj.year + ' ' + name;
			
			row.append('td').attr('class', 'dataName').classed('leftborder', isSecondary).text(name + ':');
			row.append('td').attr('class', 'dataNum').html(value + " " + unit);
		};
		
		var includeSecondary = (currentSecondDI !== '');
		var attrib = getAttributes(indObjects);
		if (includeSecondary) var s_attrib = getAttributes(s_indObjects);


		// empty out tooltip
		$('#tipContainer').empty();
		
		// county name on top of tooltip
	    tipContainer.append('div')
	    	.attr('id', 'tipLocation')
	    	.text(countyObjectById[d.id].geography);
			
		// main content table
		var tipInfo = tipContainer.append('div').attr('id', 'tipInfo');	
		var tipTable = tipInfo.append('table')
			.attr('class', 'table')
			.style({'margin-bottom': '5px', 'margin-top': '0px'}); // bootstrap defaults margin-bottom at 20px
		var none_avail = true;
		
		// write header			
		var row = tipTable.append('tr').attr('class', 'tipKey');
		writeHeader(indObjects, attrib);
		if (includeSecondary) writeHeader(s_indObjects, s_attrib);		

		// write each indicator row
		for (var i = 0; i < indObjects.length; i++) {
			if (indObjects[i].has_profile === true) continue;
			var row = tipTable.append('tr').attr('class', 'tipKey');	
			writeIndicators(row, indObjects[i], quantByIds[i], attrib, false);
			if (includeSecondary && i < s_indObjects.length) writeIndicators(row, s_indObjects[i], s_quantByIds[i], s_attrib, true);
		}			
	};
	
	var positionTooltip = function(county) {
		if (county) {
			tooltip.classed('hidden', false);
			var ttWidth = $('#tt').width(); // tooltip width and height
			var ttHeight = $('#tt').height();
			
			var scroll_top = (document.documentElement && document.documentElement.scrollTop) || document.body.scrollTop;
			var scroll_left = (document.documentElement && document.documentElement.scrollLeft) || document.body.scrollLeft;
	
			var countyCoord = county.getBoundingClientRect(); // county position relative to document.body
			var top = countyCoord.top - ttHeight - containerOffset.top + scroll_top - 10; // top relative to map
			
			if (currentSecondDI === '') {
				var left = countyCoord.left + countyCoord.width - ttWidth - containerOffset.left + scroll_left + 20; // left relative to map
				var arrow_left = -20 + countyCoord.width/2;
			} else {
				var left = countyCoord.left + countyCoord.width/2 - ttWidth/2 - containerOffset.left + scroll_left + 5;
				var arrow_left = -35 + ttWidth/2;
			}
			
			// checks if tooltip goes past window and adjust if it does
			var dx = windowWidth - (left + ttWidth); // amount to tweak
			var dy = windowHeight - (top + ttHeight);
	
			if (left < 0) {
				arrow_left -= left;
				left = 0;
			} else if (dx < 0) {
				arrow_left += (dx < -20) ? -20 : dx;
				left += dx;
			}
			
			if (top < 0) top = 0;
			else if (dy < 0) top += dy;
			
			tooltip.transition()
			  	.style("left", (left) + "px")
			  	.style("top", (top) + "px");
			d3.select('.arrow-box').transition().style('right', arrow_left + 'px');
		}
	};
	
	
	var doubleClicked = function(fips) {
		tooltip.classed("hidden", true);
		
		zoomTo(parseInt(fips));
		var countyID = fips.toString();
		if (countyID.length == 4) countyID = "0" + countyID;
		displayResults('county.cfm?id=' + countyID);
	};
	
	var zoomTo = function(fips) {
		var t = path.centroid(countyPathById[fips]);
		var s = 4.5;
		var coordAdjust = 1.215; // adjust to center on county on zoom
		var transAdjust = 20; // adjust so county appears towards the bottom to provide room for tooltip
		var area = path.area(countyPathById[fips]); // zoom based on area
		// smallest counties (area=5) get more zoom; medium counties (area=100) get medium zoom; large counties (area=1000) get small zoom
		if (area < 10) s = 7;
		else if (area < 50) s = 6;
		else if (area < 200) s = 5.5;
		else if (area < 400) s = 5;
		else if (area < 700) s = 4.5;
		else if (area < 1000) s = 4;
		else s = 3.5;
	
	  	t[0] = -t[0] * (s - 1) * coordAdjust;
	  	t[1] = (transAdjust - t[1]) * (s - 1) * coordAdjust;
	  	
	 	var transition = zoomMap(t, s);
		return transition;
	};
	
	var frmrFill, frmrActive;
	
	var highlight = function(d) {
		if (selected === d) tooltip.classed('hidden', true);
		
		if (d && selected !== d) {
			selected = (d.type === 'Feature') ? d : countyPathById[d.id];
		  } else {
		    selected = null;
		  }
		
		g.selectAll('path')
	      .classed('active', selected && function(d) { return d === selected; });
		
		if (frmrActive) frmrActive.style("fill", frmrFill);	
		frmrActive = d3.select('.county.active');
		if (frmrActive.empty() !== true) {
			frmrFill = frmrActive.style('fill');
			frmrActive.style('fill', null);
		}
	};
	var unhighlight = function() {
		if (selected !== null) highlight(selected);
		$('.county.active').removeClass('active');
	};
	
	var redraw = function() {
		tooltip.classed("hidden", true);
	  
		windowWidth = $(window).width();
		width = document.getElementById('container').offsetWidth-90;
		height = width / 2;
		containerOffset = $('#container').offset();
			
		d3.select('svg').remove();
		setup(width, height);
		draw(topo, stateMesh);
		
		if (typeof legend !== 'undefined' && legend !== false) legend.reposition();
		fillMapColors();
	};
		
	var zoomMap = function(t, s, smooth) {
		if (typeof smooth === 'undefined') var smooth = true;
		zoom.translate(t);
		zoom.scale(s);
		frmrS = s;
		frmrT = t;
		if (smooth) {
			var transition = g.transition().attr('transform', 'translate(' + t + ')scale(' + s + ')');
			return transition;
		} else {
			g.attr('transform', 'translate(' + t + ')scale(' + s + ')');
			return false;		
		}	
	};
	
	var positionInstruction = function() {
		var instructionLeft = (windowWidth * .2) / 2;
		if (windowWidth > 1125) instructionLeft = (windowWidth - 900) / 2;
		d3.select('#instructions').style({
			"left": instructionLeft - containerOffset.left + "px",
			"height": height + "px"
		});
	};
	var positionZoomIcons = function() {
		var coords = map.offsetWidth;
		d3.select("#side-icon-container").style('left', (coords + 20) + 'px');
		d3.selectAll('.side-icon-text').style('display', function() {
			return ((windowWidth - coords) / 2 < 150) ? 'none' : 'table-cell';
		});	
	};
	var setZoomIconBehavior = function() {
		d3.select('#zoomPlusIcon').on('click', function() {
			// zoom in
			var s = (frmrS > 9) ? 10 : frmrS + 1;
			var t = [0, 0];
			for (var i = 0; i < frmrT.length; i++) t[i] = frmrT[i] * (s / frmrS);
			zoomMap(t, s);
			tooltip.classed('hidden', true);
		});
		d3.select('#zoomMinusIcon').on('click', function() {
			// zoom out
			var s = (frmrS < 2) ? 1 : frmrS - 1;
			var t = [0, 0];
			if (s !== 1) {
				for (var i = 0; i < frmrT.length; i++) t[i] = frmrT[i] * (s / frmrS);
			}		
			zoomMap(t, s);
			tooltip.classed('hidden', true);
		});
	};
	var attachCountyTitles = function() {
		d3.selectAll('.county').append('title').html(function(d) {
			if (countyObjectById.hasOwnProperty(d.id) && countyObjectById[d.id].hasOwnProperty('geography')) return countyObjectById[d.id].geography;
			else return false;
		});		
	};
	
	//---------------  Easter-Eggs, and other back-end functions -----------------------------------
	var exportSVG = function(){
		d3.selectAll('path').attr({'stroke': '#fff', 'stroke-width': '.2px'});
		d3.select('#state-borders').attr({'fill': 'none', 'stroke': '#fff', 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '1.5px'});
		svgenie.save('map-svg', {name: 'test.png'});
	};
	
	// ctrl + shift + E to exportSVG() function
	d3.select(document.body).on('keyup', function() {
		if (d3.event.ctrlKey && d3.event.shiftKey && d3.event.keyCode === 69) exportSVG();
	});
	
	// ctrl + shift + L to change colors to blues
	d3.select(document.body).on('keyup',function() {
		if (d3.event.ctrlKey && d3.event.shiftKey && d3.event.keyCode === 76) {
			level_colors = ['rgb(189,215,231)','rgb(107,174,214)','rgb(49,130,189)','rgb(7,81,156)','rgb(28,53,99)'];
			var i = currentDI.lastIndexOf(' - ');
			CIC.update(currentDI.substring(0, i), currentDI.substring(i+3, currentDI.length));
		}
	});
	// ---------------- End Easter Eggs and Backend Section --------------------------------------
	
		
	setup(width, height);

	d3.json("data/us.json", function(error, us) {
	  	var counties = topojson.feature(us, us.objects.counties).features;
	  	var states = topojson.mesh(us, us.objects.states, function(a, b) { return a !== b; });
		
	  	counties.forEach(function(d) { countyPathById[d.id] = d; });
	
	  	topo = counties;
	  	neighbors = topojson.neighbors(us.objects.counties.geometries);
	  	stateMesh = states;
		  
	  	draw(topo, stateMesh); 
		  
	  	// load cic structure
	  	d3.json("data/CICstructure.json", function(error, CICStructure){
		    CICstructure = CICStructure;
			setBehaviors();
	
	
		    // check url for parameters; if there, decode into object
		    var match,
		    	urlParams = {}, 
		    	pl = /\+/g, 
		    	search = /([^&=]+)=?([^&]*)/g, 
		    	decode = function(s) { return decodeURIComponent(s.replace(pl, ' ')); },
		    	query = window.location.search.substring(1);
		    while (match = search.exec(query)) urlParams[decode(match[1])] = decode(match[2]);

		    // check to see if need to default to certain indicator
		    var custom_dset = '',
		    	custom_ind = '';
		    if (urlParams.hasOwnProperty('dset') && urlParams.hasOwnProperty('ind')) {
		    	// need to check crosswalk to make sure it exists
		    	custom_dset = urlParams.dset;
		    	custom_ind = urlParams.ind;
		    }


		    if (localVersion) {
		    	CIC.update(default_dset, default_ind); // fill in map colors for default indicator now that everything is loaded 	
		    } else {  
		    	// load crosswalk
		    	d3.tsv('data/database_crosswalk.tsv', function(error, data_array) {
		    		// set up crosswalk object; indexed by front-end "Dataset - Indicator" field names, filled with database names
			      	crosswalk = {};
		      		for (var i = 0; i < data_array.length; i++) {
				        if (data_array[i].indicator !== '') {
		          			var di = data_array[i].dataset + ' - ' + data_array[i].indicator;
		          			crosswalk[di] = data_array[i];
		        		}
		      		}
		      		
		      		// fill in map colors now that everything is loaded
		      		if (custom_dset !== '' && crosswalk.hasOwnProperty(custom_dset + ' - ' + custom_ind)) {
		      			CIC.update(custom_dset, custom_ind);
		      		} else {
		      			CIC.update(default_dset, default_ind);
		      		}


					// for testing
					/*
					$.getScript('js/util.js', function(){
						//countIndicators();
						//areAllIndicatorsInDatabase();
						//areAllCompanionsValid();
						//checkDropdownNames();
						//testDatabaseResponses(); // will only work if on nacocic.naco.org and localVersion disabled (note: 700+ requests being sent! will take more than a minute!)
					}); */
		    	});
		    }
		    	    
		    
		    // check to toggle certain overlay popup on page load
		    if (custom_dset !== '') {
		    	// close overlay if there is a custom indicator
	    		var scope = angular.element($('#container')).scope();
	    		scope.$apply(function() {
	    			scope.panel.setVisible(false);
	    		});		    	
		    } else {
			    if (urlParams.hasOwnProperty('signup')) {
		    		var scope = angular.element($('#container')).scope();
		    		scope.$apply(function() {
		    			scope.panel.toggleShowing('mailingList');
		    		});
			    } else if (urlParams.hasOwnProperty('showhelp')) {
		    		var scope = angular.element($('#container')).scope();
		    		scope.$apply(function() {
		    			scope.panel.toggleShowing('help');
		    			scope.panel.selectHelpTab(parseInt(urlParams.showhelp));
		    		});    		
			    }
			}
	  	});
	});


	// Resize Handler
	var throttleTimer;
	d3.select(window).on('resize', function() {
		window.clearTimeout(throttleTimer);
		throttleTimer = window.setTimeout(redraw, 200);
	});


	// ----------------------------------- App Helper Functions -------------------------------------

	var showInstructions = function() {
		var scope = angular.element($('#container')).scope();
		scope.$apply(function() {
			scope.panel.setVisible(true);
		});
	};
	var hideInstructions = function() {
		var scope = angular.element($('#container')).scope();
		scope.$apply(function() {
			scope.panel.setVisible(false);
		});
	};
	var showResults = function() {
		$('#results-container').empty();
		var scope = angular.element($('#container')).scope();
		scope.$apply(function() {
			scope.panel.toggleShowing('results');
		});		
	};
	

	// ---------------------------- Miscellaneous Helper Functions ----------------------------------
	
	var exceptionList = [9001, 9003, 9005, 9007, 9009, 9011, 9013, 9015, 25003, 25009, 25011, 25013, 25015, 25017, 25027, 44001, 44003, 44005, 44007, 44009, 51510, 51520, 51530, 51540, 51550, 51570, 51580, 51590, 51595, 51600, 51610, 51620, 51630, 51640, 51650, 51660, 51670, 51678, 51680, 51683, 51685, 51690, 51700, 51710, 51720, 51730, 51735, 51740, 51750, 51760, 51770, 51775, 51790, 51800, 51810, 51820, 51830, 51840];
	var exceptionCounties = {};	// converting array of exception counties to object for faster lookup
	for (var i = 0; i < exceptionList.length; i++) exceptionCounties[exceptionList[i]] = true;

	// for matching county name with county name used in url for profiles
	var parseCountyName = function(fips, name) {
		var countyName = name.replace(/,| /g, ''); // rmeove commas and spaces
		if (fips === 6075) countyName = 'SanFranciscoCountyCA';
		else if (fips === 21111) countyName = 'JeffersonCountyKY';
		else if (fips === 24033) countyName = 'PrinceGeorgesCountyMD';
		else if (fips === 25025) countyName = 'SuffolkCountyMA';
		else if (fips === 2020) countyName = 'AnchorageBoroughAK';
		return countyName;		
	};
	
	var toTitleCase = function(str) {
		return str.replace(/\w\S*/g, function(txt){
			return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
		});
	};
	var isNumFun = function(data_type) {
		return (data_type === 'level' || data_type === 'level_np' || data_type === 'percent');
	};
	var determineType = function(unit) {
		var type = '';
		if (unit && unit !== '') {
			if (unit.indexOf("dollar") != -1) type = 'currency';
			else if (unit.indexOf('year') != -1 && unit!="years of potential life lost before age 75 per 100,000 people") type = 'year';
			else if (unit.indexOf('person') != -1 || unit.indexOf('employee') != -1) type = 'person';
		}
		return type;
	};
	var format = {
		// legend formatting
		"percent": d3.format('.1%'),
		"binary": function (num) { return num; },
		"categorical": function (num) { return num; },
		"level": function (num, unit) {
			var type = determineType(unit);
			if (type === 'year') return num.toFixed(0);
			else if (unit === 'PPT') return d3.format('.1r')(num) + " PPT";
	    	else if (Math.abs(num) >= 1000000000) {
	    		var formatted = String((num/1000000000).toFixed(1)) + "bil";
	    	} else if (Math.abs(num) >= 1000000) {
	    		var formatted = String((num/1000000).toFixed(1)) + "mil";
	    	} else if (Math.abs(num) >= 10000) {
	    		var formatted = String((num/1000).toFixed(1)) + "k";
				if(formatted === "1000.0k")formatted = String((num/1000000).toFixed(1)) + " Mil";
	    	} else if (Math.abs(num) >= 100) {
	    		return (type === 'currency') ? d3.format('$,.0f')(num) : d3.format(',.0f')(num);
	    	} else if (num == 0) {
	    		return (type === 'currency') ? '$0' : 0;
	    	} else {
	    		if (type === 'currency') return d3.format('$0f')(num);
	    		else if (type === 'person') return d3.format('0f')(num);
	    		else if (isPerCapita) return d3.format('.2f')(num); // kind of a hack for right now
	    		else return d3.format('0f')(num);
	    	}
	    	
			return (type === 'currency') ? '$' + formatted : formatted;
	    },
	    "dec1": function(num, unit) {
			var type = determineType(unit);
	    	if (Math.abs(num) >= 1000) return (type === 'currency') ? d3.format('$,.0f')(num) : d3.format(',.0f')(num);
	    	else return (type === 'currency') ? d3.format('$.1f')(num) : d3.format('.1f')(num);
	    },
	    "dec2": function(num, unit) {
			var type = determineType(unit);
	    	if (Math.abs(num) >= 1000) return (type === 'currency') ? d3.format('$,.0f')(num) : d3.format(',.0f')(num);
	    	else return (type === 'currency') ? d3.format('$.2f')(num) : d3.format('.2f')(num);
	    },
	    'none': function(num) { return num; }
	};
	format['level_np'] = format['level'];
	
	
	var format_tt = {}; // formatting for the tooltip
	for (var ind in format) format_tt[ind] = format[ind]; // copy everything from format
	format_tt['binary'] = function(num) {
		return (+num === 1) ? "Yes" : "No";
	};
	format_tt['level'] = function (num, unit) {
		var type = determineType(unit);	
		if (type === 'year') return num.toFixed(0);
		else if (unit === 'PPT') return d3.format('.1r')(num);
		else if (Math.abs(num) >= 1000000000) {
			var formatted = String((num/1000000000).toFixed(1)) + " Bil";
		} else if (Math.abs(num) >= 1000000) {
			var formatted = String((num/1000000).toFixed(1)) + " Mil";
		} else if (Math.abs(num) >= 10000) {
			var formatted = String((num/1000).toFixed(1)) + "k";
			if(formatted === "1000.0k")formatted = String((num/1000000).toFixed(1)) + " Mil";
		} else if (Math.abs(num) >= 100) {
			return (type === 'currency') ? d3.format('$,.0f')(num) : d3.format(',.0f')(num);
		} else if (num == 0) {
			return (type === 'currency') ? '$0' : 0;
		} else {
			if (type === 'currency') return d3.format('$0f')(num);
			else if (type === 'person') return d3.format('0f')(num);
			else return d3.format('0f')(num);
		}
		return (type === 'currency') ? '$' + formatted : formatted;
	};
	format_tt['level_np'] = format_tt['level'];
})();
