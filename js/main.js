d3.select(window).on("resize", throttle);
//d3.select('.rrssb-buttons').style('display', 'none');

function toTitleCase(str){ return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();}); }
function isNumFun(data_type) { return (data_type === 'level' || data_type === 'level_np' || data_type === 'percent'); }
function positionInstruction(){var instructionLeft = (windowWidth * .2) / 2; if(windowWidth > 1125){instructionLeft = (windowWidth - 900)/2;}; d3.select('#instructions').style("left", instructionLeft - containerOffset.left + "px");}
var stateNameList = ['AK', 'AL', 'AR', 'AZ', 'CA', 'CO', 'CT', 'DC', 'DE', 'FL', 'GA', 'HI', 'IA', 'ID', 'IL', 'IN', 'KS', 'KY', 'LA', 'MA', 'MD', 'ME', 'MI', 'MN', 'MO', 'MS', 'MT', 'NC', 'ND', 'NE', 'NH', 'NJ', 'NM', 'NV', 'NY', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VA', 'VT', 'WA', 'WI', 'WV', 'WY'];

// default for noty alert system
$.noty.defaults.layout = 'center';
$.noty.defaults.killer = true;
$.noty.defaults.timeout = 3000;
$.noty.defaults.closeWith = ['click', 'button'];
$.noty.defaults.template = '<div class="noty_message"><div class="noty_text"></div><div class="noty_close"></div></div>';

// general formatting by data type
var format = {
	"percent": d3.format('.1%'),
	"binary": function (num) { return num; },
	"categorical": function (num) { return num; },
	"level": function (num, type) {
		if (type === 'year') return num;
    	else if (num >= 1000000000) {
    		var formatted = String((num/1000000000).toFixed(1)) + "bil";
    		return (type === 'currency') ? '$' + formatted : formatted;
    	} else if (num >= 1000000) {
    		var formatted = String((num/1000000).toFixed(1)) + "mil";
    		return (type === 'currency') ? '$' + formatted : formatted;
    	} else if (num >= 10000) {
    		var formatted = String((num/1000).toFixed(1)) + "k";
    		return (type === 'currency') ? '$' + formatted : formatted;
    	} else if (num >= 100) {
    		return (type === 'currency') ? d3.format('$,.0f')(num) : d3.format(',.0f')(num);
    	} else if (num == 0) {
    		return (type === 'currency') ? '$0' : 0;
    	} else {
    		if (type === 'currency') return d3.format('$.1f')(num);
    		else if (type === 'persons') return d3.format('0f')(num);
    		else return d3.format('.1f')(num);
    	}
    }
};
format['level_np'] = format['level'];

// formatting for the tooltip
var format_tt = {
	"percent": d3.format('.1%'),
	"binary": function (num) { return num; },
	"categorical": function (num) { return num; },
	"level": function (num, type) {
		if (type === 'year') return num;
    	else if (num >= 1000000000) {
    		var formatted = String((num/1000000000).toFixed(1)) + " Bil";
    		return (type === 'currency') ? '$' + formatted : formatted;
    	} else if (num >= 1000000) {
    		var formatted = String((num/1000000).toFixed(1)) + " Mil";
    		return (type === 'currency') ? '$' + formatted : formatted;
    	} else if (num >= 10000) {
    		var formatted = String((num/1000).toFixed(1)) + "k";
    		return (type === 'currency') ? '$' + formatted : formatted;
    	} else if (num >= 100) {
    		return (type === 'currency') ? d3.format('$,.0f')(num) : d3.format(',.0f')(num);
    	} else if (num == 0) {
    		return (type === 'currency') ? '$0' : 0;
    	} else {
    		if (type === 'currency') return d3.format('$.1f')(num);
    		else if (type === 'persons') return d3.format('0f')(num);
    		else return d3.format('.1f')(num);
    	}
    }
};
format_tt['level_np'] = format['level'];

var localVersion = true;

var zoom = d3.behavior.zoom()
    .scaleExtent([1, 10])
    .on("zoom", move);

var width = document.getElementById('container').offsetWidth-90,
	height = width / 2,
	windowWidth = $(window).width(),
	windowHeight = $(window).height(),
	containerOffset = $('#container').offset(); // position of container relative to document.body

var projection = d3.geo.albersUsa()
    .scale(width)
    .translate([width / 2, height / 2]);

var topo,stateMesh,projection,path,svg,g;

var tooltip = d3.select('#tt');
var tipContainer = d3.select('#tipContainer');

var CICstructure,
	data, // all county data
	legend, // the color legend
	selected, // county path that has been selected
	currentDataType = '', // current datatype showing
	currentDI = '', // current dataset/indicator showing
	currentSecondDI = '', // current secondary dataset/indicator showing; empty string if not showing
	searchType = 'countySearch',
	searchState = 'State';
		
var corrDomain = [], // only used for categorical data; a crosswalk for the range between text and numbers
	quantByIds = [], s_quantByIds = [], // for primary and secondary indicators, array of 2-4 objects (primary and companions) with data values indexed by FIPS 
	indObjects = [], s_indObjects = [], // for primary and secondary indicators, array of 2-4 objects (primary and companions) with indicator properties (category, dataset, definition, year, etc.)
	idByName = {}, // object of FIPS values indexed by "County, State"
	countyObjectById = {}, // object of data values and name indexed by FIPS
	countyPathById = {}; // svg of county on the map indexed by FIPS

var range = [], // array of colors used for coloring the map
	na_color = 'rgb(204,204,204)', // color for counties with no data
	percent_colors = ['rgb(522,204,102)', 'rgb(255,153,51)', 'rgb(49,130,189)', 'rgb(7,81,156)', 'rgb(28,53,99)'],
	binary_colors = ['rgb(28,53,99)', 'rgb(255,153,51)'],
	categorical_colors = ['rgb(522,204,102)', 'rgb(255,153,51)', 'rgb(49,130,189)', 'rgb(7,81,156)', 'rgb(28,53,99)'],
	level_colors = ['rgb(255,204,102)', 'rgb(255,153,51)', 'rgb(49,130,189)', 'rgb(7,81,156)', 'rgb(28,53,99)'];
	//percent_colors = ['rgb(189, 215, 231)','rgb(107, 174, 214)','rgb(49, 130, 189)','rgb(7, 81, 156)','rgb(28, 53, 99)']
	//categorical_colors = ['rgb(253,156,2)', 'rgb(0,153,209)', 'rgb(70,200,245)', 'rgb(254,207,47)', 'rgb(102,204,204)', 'rgb(69,178,157)']
	//level_colors = ['rgb(189, 215, 231)','rgb(107, 174, 214)','rgb(49, 130, 189)','rgb(7, 81, 156)','rgb(28, 53, 99)'];

var	color = d3.scale.quantile(); // quantile scale
var frmrS, frmrT; // keep track of current translate and scale values

function setup(width, height) {
	projection = d3.geo.albersUsa().translate([0, 0]).scale(width * 1.0);
    
	path = d3.geo.path().projection(projection);
	svg = d3.select("#map").insert("svg", "div")
    	.attr("width", width)
    	.attr("height", height)
    	.attr("id", "mapSvg")
    	.append("g")
    		.attr("transform", "translate(" + width / 2 + "," + height / 2 + ")")
    		.call(zoom);
	
	g = svg.append("g").attr("class", "counties");
	
	// reset scale and translate values
    frmrS = 1;
    frmrT = [0, 0];	
	zoom.scale(frmrS);
	zoom.translate(frmrT);
	
	setZoomIcons();	
	positionInstruction();
}

function setBehaviors() { 		
	d3.select('#map').on('click', function() { 
		if (selected !== null) highlight(selected);
	});
	d3.select('#close').on('click', function() { $('#instructions').hide(); });
	d3.select('#showOnMap').on('click', function() {
  		$('#instructions').hide();
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
		specWindow.document.write(document.getElementById('instructionText').innerHTML);
		specWindow.document.write('<link rel="stylesheet" href="css/main.css">');
		specWindow.document.close();
		specWindow.focus();
		specWindow.print();
		specWindow.close();		
	});

	setDropdownBehavior();
	setSearchBehavior();
}	

function draw(topo, stateMesh) {
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

	var inTransition = false;
	var clicked = function(d, event) {
		highlight(d);
		$('#instructions').hide();
		if (d3.select('.county.active').empty() !== true) {
			inTransition = true;
			var transition = executeSearchMatch(event.target.id);
			if (transition === false) inTransition = false;
			else transition.each('end.bool', function() { inTransition = false; });
		}		
	};
	
	
	if ($('html').hasClass('no-touch')) {
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
		county.on('click', function(d, i) {
			if ($.now() - mdownTime < 300) {
				d3.event.stopPropagation();
				if (!inTransition) clicked(d, d3.event);
			}
		});
		
		$('.county').addSwipeEvents().bind('doubletap', function(event, touch) {
			event.stopPropagation();
			doubleClicked(event.target.id);
		});
	}
}

function emptyInstructionText() {
	$('#instructionText .temp').remove();
	$('#instructionText .iText').hide();
}

//Functions for Icons
function showHelpText(){
	emptyInstructionText();
	$('#helpText').show();	
	$('#showOnMap').hide();
	$('#instructions').show();
}
function addToMailingList() {
	emptyInstructionText();
	$('#mailingText').show();	
	$('#showOnMap').hide();
	$('#instructions').show();
}
function resetAll() {
	currentSecondDI = '';
	if (d3.select('.county.active').empty() !== true) {
		populateTooltip(selected);
	}
	d3.select('#secondIndText').html('Secondary Indicator' + '<span class="sub-arrow"></span>');
}
function showHideRrssb() {
	if ($('.rrssb-buttons').is(':visible')) {
		var moveTransition = d3.select('#rrssbContainer').transition().duration(500).style('right', '-200px');
		moveTransition.each('end', function() {
			$('.rrssb-buttons').hide();
		});		
	} else {
		$('.rrssb-buttons').show();
		d3.select('#rrssbContainer').transition().duration(500).style('right', '50px');
	}
}
function moreDataShow(){
	if ($('#mdText').is(':visible')) {
		//$('#instructions').hide();
	} else {
		emptyInstructionText();
		$('#mdText').show();
		$('#showOnMap').hide();		
		$('#instructions').show();
	}
}
function incrementPage(dx) {
	var currPageNum = parseInt($('#instructionPagination .active').attr('name'));
	if (currPageNum === 1 && parseInt(dx) === -1) goToPage(1);
	else if (currPageNum === 3 && parseInt(dx) === 1) goToPage(3);
	else goToPage(currPageNum + parseInt(dx));
}
function goToPage(pageNum) {
	$('#instructionPagination .active').removeClass('active');
	$('#instructionPagination li[name='+pageNum+']').addClass('active');
}

function setDropdownBehavior() {
	var pickedIndicator = function(dataset, indicator, html) {
		$.SmartMenus.hideAll();
		if (currentDI === dataset + ' - ' + indicator) {
			noty({text: 'Already showing "' + indicator + '"'});
		} else {
			update(dataset, indicator);
			d3.select('#primeIndText').html(html + '<span class="sub-arrow"></span>');
		}
	};
			
	d3.select('#primeInd').selectAll('.dataset').each(function() {
		var dataset = d3.select(this);		
		var datasetName = dataset.attr('name');
		
		// when clicking on dataset, update to first companion
		dataset.selectAll('a:not(.indicator)').on('click', function() {
			var primeDI = getData(datasetName).companions[0];
			var indHtml = dataset.select('.indicator[name="' + primeDI[1] + '"]').html();
			pickedIndicator(primeDI[0], primeDI[1], indHtml);
		});

		dataset.selectAll('li').on('click', function() {
			if (!d3.select(this).classed('disabled')) {
				var indicatorName = d3.select(this).select('.indicator').attr('name');
				pickedIndicator(datasetName, indicatorName, this.innerHTML);
			} else d3.event.stopPropagation();
		});
	});

	
	var pickedSecondaryIndicator = function(dataset, indicator, html) {
		$.SmartMenus.hideAll();
		if (currentSecondDI === dataset + ' - ' + indicator) {
			noty({text: 'Already showing "' + indicator + '" as a secondary indicator'});
		} else {
			appendSecondInd(dataset, indicator);
			d3.select('#secondIndText').html(html + '<span class="sub-arrow"></span>');
		}
	};

	d3.select('#secondInd').selectAll('.dataset').each(function() {
		var dataset = d3.select(this);		
		var datasetName = dataset.attr('name');

		dataset.selectAll('a:not(.indicator)').on('click', function() {
			var secDI = getData(datasetName).companions[0];
			var indHtml = dataset.select('.indicator[name="' + secDI[1] + '"]').html();
			pickedSecondaryIndicator(secDI[0], secDI[1], indHtml);
		});

		dataset.selectAll('li').on('click', function() {
			if (!d3.select(this).classed('disabled')) {
				var indicatorName = d3.select(this).select('.indicator').attr('name');
				pickedSecondaryIndicator(datasetName, indicatorName, this.innerHTML);
			} else d3.event.stopPropagation();
		});
	});
	
	d3.selectAll('.dataset a').style('cursor', 'pointer');
	d3.selectAll('.dataset').selectAll('li .disabled').selectAll('.indicator').style('cursor', 'default');
}

function setSearchBehavior() {
	var searchField = d3.select('#search_field');
	var stateDrop = d3.select('#stateDropLi');
	
	// both of these are redundant and causing search to fire multiple times
	//d3.select('#search_form').on('submit', submitSearch);	
	//var searchField = d3.select('#search_field').on('keyup', function() { if (d3.event.keyCode === 13) submitSearch(); });
	d3.select('#search_submit').on('click', submitSearch);
	
	// set search type buttons to toggle
	$('.btn').on('click', function() {
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
}

function submitSearch() {
	d3.event.preventDefault();
		
	var search_str = d3.select('#search_field').property('value');
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
					executeSearchMatch(parseInt(idByName[search_comb]));
					return;
				}
			}
			
			// special case
			if (countyName.toLowerCase() === 'washington' && stateName === 'DC') { executeSearchMatch(11001); return; }
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
				executeSearchMatch(cMatchFIPS);
				return;
			}
						
			// display all matches if more than one match
			emptyInstructionText();
			var searchResults = d3.select('#instructionText').append('div').attr('class', 'temp');
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
					.classed('county_link', true)
					.text(nameArr[0]); 
				var state_cell = countyRow.append('td')
					.text(nameArr[1]);

				(function(cell, fips) {
					cell.on('click', function() { executeSearchMatch(fips); });
				})(name_cell, pMatchArray[i].fips);
			}
			
			$('#showOnMap').hide();
			$('#instructions').show();
						
		} else if (pMatchArray.length == 1) {
			executeSearchMatch(pMatchArray[0].fips); // if only one match, display county
		} else {
			noty({text: 'Your search did not match any counties.'});
			document.getElementById('search_form').reset();	
		}
		
	} else if (searchType === 'citySearch') {
		// city search: use city-county lookup
		var search_str_array = search_str.toLowerCase().split('city');
		var city_search_str = 'city_res.cfm?city=';
		for (var i = 0; i < search_str_array.length; i++) city_search_str += search_str_array[i];
		
		displayResults(city_search_str);
	}
}

function executeSearchMatch(FIPS) {
	$('#instructions').hide();
	$('#search_field').val('');
	
	var county = countyObjectById[parseInt(FIPS)];
    if (county) {
		highlight(county);
		var zoomTransition = zoomTo(FIPS);
	    populateTooltip(county);
		zoomTransition.each('end', function() { 
			positionTooltip($('.county.active')[0]); 
		});
		return zoomTransition;
	} else {
		tooltip.classed('hidden', true);
		//noty({text: 'No information availble for this county'});
		return false;
	}    
};

function displayResults(url) {
	$('#instructionText').empty();
	
	d3.xhr('http://nacocic.naco.org/ciccfm/'+ url, function(error, request){
		if (!error) {
			var response = request.responseText;
			//console.log(response);
			
			var frame = d3.select("#instructionText").append('div')
				.attr('class', 'container-fluid')
				.attr('id', 'resultsContainer');
				
				frame.html(response);
			
			(url.indexOf('county') != -1) ? $('#showOnMap').show() : $('#showOnMap').hide();
			$('#instructions').show();
		} else {
			console.log('Error retrieving data from : ' + 'http://nacocic.naco.org/ciccfm/' + url);
			console.log(error);
		}
	});
}

function update(dataset, indicator) {
	currentDI = dataset + ' - ' + indicator; 
	tooltip.classed("hidden", true);
	$(document.body).scrollTop(0);
	
	indObjects = allData(dataset, indicator); // pull data from JSON
	currentDataType = indObjects[0].dataType;


	var execUpdate = function() {
		var isNumeric = isNumFun(currentDataType);
		var quantById = quantByIds[0];	

		// define domain
		if (isNumeric) {
			var domain = [];
			for (var ind in quantById) {				
				if (currentDataType === 'level' && parseFloat(quantById[ind]) === 0) {
					//quantById[ind] = '.'; // for level datatypes, we do not want "zero" to be considered during the quantile categorization
				} else {
					domain[ind] = quantById[ind];
				}
			}
		} else {
			if (currentDataType === 'binary') {
				for (var ind in quantById) {
					if (quantById[ind] === 'Yes') corrDomain[ind] = 1;
					else if (quantById[ind] === 'No') corrDomain[ind] = 0;
				}
				var vals = {'Yes': 1, 'No': 0};
			} else {
				// translating string values to numeric values
				var numCorrVals = 0, vals = {}, corrVal = 0;
				for (var ind in quantById) {
					// case by case substitutions
					if (quantById[ind] === '0') quantById[ind] = 'None';
					
					// create corresponding value array (e.g. {"Gulf of Mexico": 0, "Pacific Ocean": 1})
					if (quantById[ind] !== '.' && quantById[ind] !== '' && quantById[ind] !== null) {
						if (!vals.hasOwnProperty(quantById[ind])) {
							vals[quantById[ind]] = corrVal;
							corrVal++;
						}
						corrDomain[ind] = vals[quantById[ind]];
					}
				}
				for (var ind in vals) numCorrVals++;
			}
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
		if (isNumeric) color.domain(domain).range(range);
		else color.domain(corrDomain).range(range);

		fillMapColors(); // fill in map colors
		legend = isNumeric ? createLegend() : createLegend(vals); // create the legend; note: vals is a correspondence array linking strings with numbers for categorical dataTypes
		
		// list source
		d3.select("#sourceContainer").selectAll("p").remove();
		d3.select('#sourceContainer').append('p').attr("id", "sourceText")
			.html('<i>Source</i>: ' + indObjects[0].source + ', ' + indObjects[0].year);
		
		// list definitions
		d3.select("#definitionsContainer").selectAll("p").remove();
		var defContainer = d3.select("#definitionsContainer").append("p").attr("id", "definitionsText");
		defContainer.append('div').html('<i>Definitions</i>:');
		for (var i = 0; i < indObjects.length; i++) {
			defContainer.append('div')
				.html('<b>' + indObjects[i].name + '</b>: ' + indObjects[i].definition);
		}		
	};
 	
 	// grab data and set up quantByIds and other objects
 	if (localVersion) {
 		d3.tsv("data/CData.tsv", function(error, countyData) {
 			data = countyData;
	 		quantByIds = [];
			for (var i = 0; i < indObjects.length; i++) quantByIds.push([]);
	
			countyData.forEach(function(d) {			
				for (var i = 0; i < indObjects.length; i++) {
					quantByIds[i][d.id] = isNumFun(indObjects[i].dataType) ? parseFloat(d[indObjects[i].DI]) : d[indObjects[i].DI];
					if (indObjects[i].hasOwnProperty('unit') && indObjects[i].unit.indexOf('thousand') !== -1) quantByIds[i][d.id] *= 1000;
				}
	
				idByName[d.geography] = d.id;
				countyObjectById[d.id] = d;
			});
			
			execUpdate();
 		});
 	} else {
 		// need to sort by dataset because we want to send one query per dataset needed
	  	var indicatorList = {}; // object of indicator values and latest year values indexed by dataset name
	  	for (var i = 0; i < indObjects.length; i++) {
		  	var crossObject = crosswalk[indObjects[i].dataset+' - '+indObjects[i].name];
	
	  		if (!indicatorList.hasOwnProperty(crossObject.db_dataset)) {
	  			indicatorList[crossObject.db_dataset] = {year: indObjects[i].year, indicators: []};
	  		}
	  		indicatorList[crossObject.db_dataset].indicators.push(crossObject.db_indicator);	  		
	  	}

		// configure query string for each dataset
		var qsa = []; // array of query strings
	  	for (var ind in indicatorList) {
	  		var query_str = 'db_set=' + ind + '&db_year=' + indicatorList[ind].year + '&db_ind='; // append dataset name and year
	  		for (var j = 0; j < indicatorList[ind].indicators.length; j++) {
	  			query_str += indicatorList[ind].indicators[j]; // append each indicator
	  			if (j != indicatorList[ind].indicators.length - 1) query_str += ',';
	  		}
	  		qsa.push({query_str: query_str, dataset_name: ind});
	  	}

		var gtgArray = []; // indicates whether we have received back each query request
		for (var i = 0; i < qsa.length; i++) gtgArray.push(false);
		
    	data = {};
    	
    	var getRequest = function(query_str, queryIndex, datasetName) {
		  	d3.xhr('http://nacocic.naco.org/ciccfm/indicators.cfm?'+ query_str, function(error, request){
		    	// restructure response object to object indexed by fips
		    	try {
		    		var responseObj = jQuery.parseJSON(request.responseText);
		    	}
		    	catch(error) {
		    		noty({text: 'Error retreiving information from database.'});
		    		return;
		    	}
		    	if (responseObj.ROWCOUNT === 0) {
		    		noty({text: 'Database error: ROWCOUNT = 0'});
		    		return;
		    	}
		    	
		    	
		    	for (var i = 0; i < responseObj.DATA.FIPS.length; i++) {
		    		var fips = parseInt(responseObj.DATA.FIPS[i]);
		    		if (!data.hasOwnProperty(fips)) data[fips] = {};
		    		for (var j = 1; j < responseObj.COLUMNS.length; j++) {
		    			var property = responseObj.COLUMNS[j]; // does not avoid duplicate property names; might need to change later by renaming property "database - indicator" if an indicator
		    			if (!data[fips].hasOwnProperty(property)) data[fips][property] = responseObj.DATA[property][i];
		    		}
		    		data[fips].id = fips;
		    		data[fips].geography = data[fips].COUNTY_NAME + ', ' + data[fips].STATE;
		    	}
		
				quantByIds = [];
				for (var i = 0; i < indObjects.length; i++) quantByIds.push([]);
				
				for (var fips in data) {
					for (var i = 0; i < indObjects.length; i++) {
						var value = data[fips][indObjects[i].db_indicator.toUpperCase()];
						quantByIds[i][fips] = isNumFun(indObjects[i].dataType) ? parseFloat(value) : value;
						if (indObjects[i].hasOwnProperty('unit') && indObjects[i].unit.indexOf('thousand') !== -1) quantByIds[i][fips] *= 1000;
					}
		
					idByName[data[fips].geography] = fips;
					countyObjectById[fips] = data[fips];
				}
				
				// check if everything's good to go
				gtgArray[queryIndex] = true;
				var gtg = true;
				for (var j = 0; j < gtgArray.length; j++) {
					if (gtgArray[j] === false) {
						gtg = false;
						break;
					}
				}	
				if (gtg === true) execUpdate();	
			});
		};
		
		for (var i = 0; i < qsa.length; i++) getRequest(qsa[i].query_str, i, qsa[i].dataset_name);
	}
}

function appendSecondInd(dataset, indicator) {
	currentSecondDI = dataset + ' - ' + indicator;
	s_indObjects = allData(dataset, indicator);
	
	d3.tsv("data/CData.tsv", function(error, countyData) {
		s_quantByIds = [];
		for (var i = 0; i < s_indObjects.length; i++) s_quantByIds.push([]);
		
		countyData.forEach(function(d) {
			for (var i = 0; i < s_indObjects.length; i++) {
				s_quantByIds[i][d.id] = isNumFun(s_indObjects[i].dataType) ? parseFloat(d[s_quantByIds[i].dataset+' - '+s_quantByIds[i].name]) : d[s_quantByIds[i].dataset+' - '+s_quantByIds[i].name];
			}
		});
				
		if (d3.select('.county.active').empty() !== true) populateTooltip(selected);
	});
}

function allData(dataset, indicator){
	var firstObj = getData(dataset, indicator);
	var objArray = [firstObj];
	for (var i = 0; i < firstObj.companions.length; i++) {
		var obj = getData(firstObj.companions[i][0], firstObj.companions[i][1]);
		if (obj.name !== firstObj.name && objArray.length < firstObj.companions.length) objArray.push(obj);	

	}	
	return objArray;
}

//Alternative to this big lookup is to list a i,j,h "JSON address" in the HTML anchor properties.  Would still likely require some type of HTML or JSON lookup for companion indicators though
function getData(dataset, indicator){
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
				if (Jdataset.hasOwnProperty('vintage')) selectedInd.vintage = Jdataset.vintage;
				
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
									selectedInd[prop] = crosswalk[selectedInd.DI][prop];
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
}

function fillMapColors() {
	selected = null;
	frmrActive = null;
	g.selectAll(".counties .county").transition().duration(750).style("fill", function(d) {
		
		if (isNumFun(currentDataType)) {
			return isNaN(quantByIds[0][d.id]) ? na_color : color(quantByIds[0][d.id]);
		} else {
			if (currentDataType === 'binary') {
				return (corrDomain.hasOwnProperty(d.id)) ? range[corrDomain[d.id]] : na_color;	
			} else {
				return isNaN(corrDomain[d.id]) ? na_color : range[corrDomain[d.id]];
			}
		}		
	});
}

function createLegend(keyArray) {
	d3.selectAll(".legend svg").remove();

	var primeIndObj = indObjects[0];
	var type = '';
	if (primeIndObj.hasOwnProperty('unit')) {
		if (primeIndObj.unit.indexOf("dollar") != -1) type = 'currency';
		else if (primeIndObj.unit.indexOf('person') != -1 || primeIndObj.unit.indexOf('people') != -1 || primeIndObj.unit.indexOf('employee') != -1) type = 'persons';
		else if (primeIndObj.unit.indexOf('year') != -1) type = 'year';
	}

	if (primeIndObj.dataType !== 'none') {
		var options = {
			boxHeight : 18,
			boxWidth : 58,
			dataType : primeIndObj.dataType,
			unitType : type,
			formatFnArr: format
		};
		if (keyArray) options.keyArray = keyArray;
		
		d3.select('#legendTitle').text(primeIndObj.year + ' ' + primeIndObj.dataset);
		d3.select('#legendSubtitle').text(primeIndObj.name);
		return colorlegend("#quantileLegend", color, "quantile", options);
	} else return false;
}

function populateTooltip(d) {
	$('#tipContainer').empty();
    tipContainer.append('div')
    	.attr('id', 'tipLocation')
    	.text(countyObjectById[d.id].geography);
		
	// loop through primary and all three companions and display corresponding formatted values
	var tipInfo = tipContainer.append('div').attr('id', 'tipInfo');	
	var tipTable = tipInfo.append('table')
		.attr('class', 'table')
		.style('margin-bottom', '5px'); // bootstrap defaults margin-bottom at 20px
	var none_avail = true;
	
	var writeIndicators = function(obj, quant, secondary) {
		var unit = '', type = '';
		if (obj.hasOwnProperty('unit')) {
			if (obj.unit.indexOf("dollar") != -1) type = 'currency';
			else if (obj.unit.indexOf('person') != -1 || obj.unit.indexOf('people') != -1 || obj.unit.indexOf('employee') != -1) type = 'persons';
			else if (obj.unit.indexOf('year') != -1) type = 'year';
		}
		var value = format_tt[obj.dataType](quant[d.id], type);
		if (value === '$NaN' || value === 'NaN' || value === 'NaN%' || value === '.') {
			value = 'Not Available';
		} else {
			none_avail = false;
			if (type !== 'currency' && obj.hasOwnProperty('unit')) unit = obj.unit;
			if (parseFloat(value) === 1 && unit.charAt(unit.length - 1) === 's') unit = unit.substr(0, unit.length - 1); // "1 employee"
		}
		
		var name = (obj.name.indexOf('(') != -1) ? obj.name.substring(0, obj.name.indexOf('(')) : obj.name; // cut off before parenthesis if there is one
		
		row.append('td').attr('class', 'dataName').classed('leftborder', secondary).text(obj.year + ' ' + name + ':');
		row.append('td').attr('class', 'dataNum').text(value + " " + unit);		
	};
	
	for (var i = 0; i < indObjects.length; i++) {
		var row = tipTable.append('tr')
			.attr('class', 'tipKey');
			
		writeIndicators(indObjects[i], quantByIds[i], false);
		if (currentSecondDI !== '' && i < s_indObjects.length) writeIndicators(s_indObjects[i], s_quantByIds[i], true);
	}

	/*if (none_avail) {
		tipTable.selectAll('tr').remove();
		tipTable.append('tr').attr('class', 'tipKey').html('<td>No data available for this county</td>');
	}*/
}

function positionTooltip(county) {
	if (county) {
		tooltip.classed('hidden', false);
		var ttWidth = $('#tt').width(); // tooltip width and height
		var ttHeight = $('#tt').height();
		
		var countyCoord = county.getBoundingClientRect(); // county position relative to document.body
		var left = countyCoord.left + countyCoord.width - ttWidth - containerOffset.left + document.body.scrollLeft + 20; // left relative to map
		var top = countyCoord.top - ttHeight - containerOffset.top + document.body.scrollTop - 10; // top relative to map
		
		// checks if tooltip goes past window and adjust if it does
		var dx = windowWidth - (left + ttWidth); // amount to tweak
		var dy = windowHeight - (top + ttHeight);

		if (left < 0) {
			d3.select('.arrow_box').transition().style('right', -left+'px');
			left = 0;
		} else if (dx < 0) {
			d3.select('.arrow_box').transition().style('right', (dx < -20) ? '-20px' : dx+'px');
			left += dx;
		} else {
			d3.select('.arrow_box').transition().style('right', '0px');			
		}
		
		if (top < 0) top = 0;
		else if (dy < 0) top += dy;
		
		tooltip.transition()
		  	.style("left", (left) + "px")
		  	.style("top", (top) + "px");
	}
}


function doubleClicked(fips) {
	tooltip.classed("hidden", true);
	
	var countyID = fips.toString();
	if (countyID.length == 4) countyID = "0" + countyID;
	displayResults('county.cfm?id=' + countyID);
}

function zoomTo(fips) {
	var t = path.centroid(countyPathById[fips]);
	var s = 4.5;
	var coordAdjust = 1.215; // adjust to center on county on zoom
	var transAdjust = 20; // adjust so county appears towards the bottom to provide room for tooltip
	var area = path.area(countyPathById[fips]); // zoom based on area
	// smallest counties (area=5) get more zoom; medium counties (area=100) get medium zoom; large counties (area=1000) get small zoom
	if (area < 5) s = 8;
	else if (area < 10) s = 7;
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
}

var frmrFill, frmrActive;

function highlight(d) {
	if (selected === d) tooltip.classed('hidden', true);
	
	if (d && selected !== d) {
		selected = (d.type === 'Feature') ? d : countyPathById[d.id];
	  } else {
	    selected = null;
	  }
	
	g.selectAll("path")
      .classed("active", selected && function(d) { return d === selected; });
	
	if (frmrActive) frmrActive.style("fill", frmrFill);	
	frmrActive = d3.select(".county.active");
	if (frmrActive.empty() !== true) {
		frmrFill = frmrActive.style("fill");
		frmrActive.style("fill", null);
	}
}

function redraw() {
	tooltip.classed("hidden", true);
  
	windowWidth = $(window).width();
	width = document.getElementById('container').offsetWidth-90;
	height = width / 2;
	containerOffset = $('#container').offset();
	
	d3.select('svg').remove();
	setup(width,height);
	draw(topo, stateMesh);
	
	if (typeof legend !== 'undefined' && legend !== false) legend.reposition();
	fillMapColors();
}

function move() {	
  	tooltip.classed("hidden", true); // hides on zoom or pan	
	
  var t = d3.event.translate;
  var s = d3.event.scale;
  var h = height / 2;

  t[0] = Math.min(width / 2 * (s - 1), Math.max(width / 2 * (1 - s), t[0]));
  t[1] = Math.min(height / 2 * (s - 1), Math.max(height / 2 * (1 - s), t[1]));
  //original function: t[1] = Math.min(height / 2 * (s - 1) + h * s, Math.max(height / 2 * (1 - s) - h * s, t[1]));
  //maximum translate value is 1944 (maine) from scale = 10 (t-value of 1902)
  	//1190 from 6 (1145)
  	//743 from 3.7 (626)
  	//343 from 2.2 (339)
  	//167 from 1.3 (132)
  	//0 from 1 (0)
	
  	var zoomSmoothly = !(s === frmrS); // dont do smoothly if panning
	zoomMap(t, s, zoomSmoothly);	
}

function zoomMap(t, s, smooth) {
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
}

function setZoomIcons() {
	var coords = map.offsetWidth;
	d3.select("#iconsGroup").style('left', (coords + 20) + 'px');
	d3.selectAll('.extraInstructions').style('display', function() {
		return ((windowWidth - coords) / 2 < 150) ? 'none' : 'table-cell';
	});
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
}

//Easter-Eggs, and other back-end functions
function exportSVG(){
	d3.selectAll('path').attr({'stroke': '#fff', 'stroke-width': '.2px'});
	d3.select('#state-borders').attr({'fill': 'none', 'stroke': '#fff', 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '1.5px'});
	svgenie.save('mapSvg', {name: 'test.png'});
}
//bind crtl + shit + L to change colors to blues
d3.select(document.body).on('keyup',function(){if(d3.event.ctrlKey&&d3.event.shiftKey&&d3.event.keyCode===76){level_colors=['rgb(189,215,231)','rgb(107,174,214)','rgb(49,130,189)','rgb(7,81,156)','rgb(28,53,99)'];var i=currentDI.lastIndexOf(' - ');update(currentDI.substring(0,i),currentDI.substring(i+3,currentDI.length));}});
//bind ctrl + shift + e to exportSVG() function
d3.select(document.body).on('keyup', function(){if(d3.event.ctrlKey&&d3.event.shiftKey&&d3.event.keyCode===69)exportSVG();});
//
//End Easter Eggs and Backend Section
//

var throttleTimer;
function throttle() {
  window.clearTimeout(throttleTimer);
    throttleTimer = window.setTimeout(redraw, 200);
}

setup(width,height);

// for testing
/*$.getScript('js/test/util.js', function(){
	//countIndicators();
	//areAllIndicatorsInDatabase();
	//testDatabaseResponses(); // will only work if on nacocic.naco.org and localVersion disabled (note: 700+ requests being sent! will take more than a minute!)
});*/

d3.json("us.json", function(error, us) {
  	var counties = topojson.feature(us, us.objects.counties).features;
  	var states = topojson.mesh(us, us.objects.states, function(a, b) { return a !== b; });
	
  	counties.forEach(function(d) { countyPathById[d.id] = d; });

  	topo = counties;
  	stateMesh = states;
	  
  	draw(topo, stateMesh); 
	  
  	// load cic structure
  	d3.json("data/CICstructure.json", function(error, CICStructure){
	    CICstructure = CICStructure;
		setBehaviors();

	    if (localVersion) {
	    	update('Population Levels and Trends', 'Population Level'); // fill in map colors for default indicator now that everything is loaded 	
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
	      		
	      		update("Administration Expenditures", "Total Expenditures"); // fill in map colors for default indicator now that everything is loaded
	    	});
	    }
  	});
});