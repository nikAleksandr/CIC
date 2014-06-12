d3.select(window).on("resize", throttle);
//d3.select('.rrssb-buttons').style('display', 'none');

function toTitleCase(str){ return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();}); }
function isNumFun(data_type) { return (data_type === 'level' || data_type === 'level_np' || data_type === 'percent'); }
function positionInstruction(){var instructionLeft = (windowWidth * .2) / 2; if(windowWidth > 1125){instructionLeft = (windowWidth - 900)/2;}; d3.select('#instructions').style("left", instructionLeft + "px");}

// default for noty alert system
$.noty.defaults.layout = 'center';
$.noty.defaults.killer = true;
$.noty.defaults.closeWith = ['click', 'button'];
$.noty.defaults.template = '<div class="noty_message"><div class="noty_text"></div><div class="noty_close"></div></div>';

// general formatting by data type
var format = {
	"percent": d3.format('.1%'),
	"binary": function (num) {
		if (num === 1) return "Yes";
		else if (num === 0) return "No";
		else return "N/A";
	},
	"categorical": function (num) { return num; },
	"level": function (num, curr) {
		var isCurrency = curr || false;
    	if (num >= 1000000000) {
    		var formatted = String((num/1000000000).toFixed(1)) + "bil";
    		return isCurrency ? '$' + formatted : formatted;
    	} else if (num >= 1000000) {
    		var formatted = String((num/1000000).toFixed(1)) + "mil";
    		return isCurrency ? '$' + formatted : formatted;
    	} else if (num >= 10000) {
    		var formatted = String((num/1000).toFixed(1)) + "k";
    		return isCurrency ? '$' + formatted : formatted;
    	} else if (num >= 100) {
    		return isCurrency ? d3.format('$,.0f')(num) : d3.format(',.0f')(num);
    	} else if (num == 0) {
    		return isCurrency ? '$0' : 0;
    	} else {
    		return isCurrency ? d3.format('$.1f')(num) : d3.format('.1f')(num);
    	}
    }
};
format['level_np'] = format['level'];

// formatting for the tooltip
var format_tt = {
	"percent": d3.format('.1%'),
	"binary": function (num) {
		if (num === 1) return "Yes";
		else if (num === 0) return "No";
		else return "N/A";
	},
	"categorical": function (num) { return num; },
	"level": function (num, curr) {
		var isCurrency = curr || false;
    	if (num >= 1000000000) {
    		var formatted = String((num/1000000000).toFixed(1)) + " Bil";
    		return isCurrency ? '$' + formatted : formatted;
    	} else if (num >= 1000000) {
    		var formatted = String((num/1000000).toFixed(1)) + " Mil";
    		return isCurrency ? '$' + formatted : formatted;
    	} else if (num >= 10000) {
    		var formatted = String((num/1000).toFixed(1)) + "k";
    		return isCurrency ? '$' + formatted : formatted;
    	} else if (num >= 100) {
    		return isCurrency ? d3.format('$,.0f')(num) : d3.format(',.0f')(num);
    	} else if (num == 0) {
    		return isCurrency ? '$0' : 0;
    	} else {
    		return isCurrency ? d3.format('$.1f')(num) : d3.format('.1f')(num);
    	}
    }
};
format_tt['level_np'] = format['level'];

var zoom = d3.behavior.zoom()
    .scaleExtent([1, 10])
    .on("zoomstart", moveStart)
    .on("zoom", move)
    .on("zoomend", moveEnd);

var width = document.getElementById('container').offsetWidth-90,
	height = width / 2,
	windowWidth = $(window).width(),
	windowHeight = $(window).height(),
	headHeight = $('#header').height();

var projection = d3.geo.albersUsa()
    .scale(width)
    .translate([width / 2, height / 2]);

var topo,stateMesh,projection,path,svg,g;

var tooltip = d3.select('#tt');
var tipContainer = d3.select('#tipContainer');

var CICstructure,
	data, // all county data
	legend,
	selected, // county path that has been selected
	currentDataType = '', // current datatype showing
	currentDI = '', // current dataset/indicator showing
	currentSecondDI = '', // current secondary dataset/indicator showing; empty string if not showing
	searchType = 'county',
	searchState = 'State';
		
var range, // output of data (only numbers; i.e. for categorical: 0, 1, 2)
	corrDomain = [], // only used for categorical data; a crosswalk for the range between text and numbers
	quantByIds = [], s_quantByIds = [], indObjects = {}, s_indObjects = {},
	idByName = {},
	countyObjectById = {},
	countyPathById = {};

var na_color = 'rgb(204,204,204)', // color for counties with no data
	range = [],
	percent_colors = ['rgb(522,204,102)', 'rgb(255,153,51)', 'rgb(49,130,189)', 'rgb(7,81,156)', 'rgb(28,53,99)'],
	binary_colors = ['rgb(0,153,204)', 'rgb(255,204,102)'],
	categorical_colors = ['rgb(522,204,102)', 'rgb(255,153,51)', 'rgb(49,130,189)', 'rgb(7,81,156)', 'rgb(28,53,99)'],
	level_colors = ['rgb(522,204,102)', 'rgb(255,153,51)', 'rgb(49,130,189)', 'rgb(7,81,156)', 'rgb(28,53,99)'];
	//percent_colors = ['rgb(189, 215, 231)','rgb(107, 174, 214)','rgb(49, 130, 189)','rgb(7, 81, 156)','rgb(28, 53, 99)']
	//categorical_colors = ['rgb(253,156,2)', 'rgb(0,153,209)', 'rgb(70,200,245)', 'rgb(254,207,47)', 'rgb(102,204,204)', 'rgb(69,178,157)']
	//level_colors = ['rgb(189, 215, 231)','rgb(107, 174, 214)','rgb(49, 130, 189)','rgb(7, 81, 156)','rgb(28, 53, 99)'];

var	color = d3.scale.quantile(); // quantile scale
var frmrS, frmrT; // keep track of current translate and scale values

function setup(width, height) {
	projection = d3.geo.albersUsa()
    .translate([0, 0])
    .scale(width *1.0);
    
	path = d3.geo.path().projection(projection);
	svg = d3.select("#map").insert("svg", "div")
    	.attr("width", width)
    	.attr("height", height)
    	.attr("id", "#mapSvg")
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
  		if (d3.select('.active').empty() !== true) {
  			var active_county = document.getElementsByClassName('active')[0];
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
		
	var mdownTime = -1;
	var clickCount = 0;
	  
	county.on('mousedown', function(d, i) {
		mdownTime = $.now();
	});
	county.on('click', function(d, i) {
		if ($.now() - mdownTime < 300) {
			d3.event.stopPropagation();
			var mouse = d3.mouse(svg.node()).map(function(d) { return parseInt(d); });
			var event = d3.event;
		
			clickCount++;
			if (clickCount === 1) {
				singleClickTimer = setTimeout(function() {
					clickCount = 0;
					highlight(d);
					$('#instructions').hide();
					if (d3.select('.active').empty() !== true) executeSearchMatch(event.target.id);
				}, 300);
			} else if (clickCount === 2) {
				clearTimeout(singleClickTimer);
				clickCount = 0;
				highlight(d);
				doubleClicked(d, i);
			}
		}
	});
	
	fillMapColors();
}
//Functions for Icons
function helpText(){
	$('#instructionText').empty();
	
	d3.select('#instructionText').html('<p><b>Instructions</b></p><br><p>&bull; Pick a statistic by clicking on &quot;Primary Indicator&quot; on the top left of the screen and choosing an indicator.<br>&bull; Click on a county on the map to show the statistics for that county.<br>&bull; Or search for a county with the search bar on the top right of the screen.</p><br><p>To show additional statistics, click on &quot;Secondary Indicator&quot; on the top left of the screen and choose another indicator.</p><br><p><img src="img/Back_to_US.svg"></img> - Click this to fully zoom out and see the entire map</p><p><img src="img/Reset_indicators.svg"></img> - Click this to no longer see the secondary indicator</p><p><img src="img/Share.svg"></img> - Click this to share on social media</p><p><img src="img/More_interactives.svg"></img> - Click this to access more data through COIN</p>');
	
	$('#instructions').show();
	$('#showOnMap').hide();
}
function resetAll() {
	currentSecondDI = '';
	if (d3.select('.active').empty() !== true) {
		populateTooltip(selected);
	}
	d3.select('#secondIndText').html('Secondary Indicator' + '<span class="sub-arrow"></span>');
}

var rrssbHidden=true;
function showHideRrssb(){
	var rrssbContainer = d3.select('#rrssbContainer');
	var placement = (windowWidth - width)/2;
	if(rrssbHidden){
		d3.select('.rrssb-buttons').style('display', 'block');
		rrssbContainer.transition().duration(500).style('right', placement + "px");
		rrssbHidden = false;
	}
	else{
		rrssbContainer.transition().duration(500).style('right', '-200px');
		d3.select('.rrssb-buttons').style('display', 'none');
		rrssbHidden=true;
	}
	
}
var moreDataContent = '<div id="moreDataContent" class="container-fluid"><div class="row"><div class="col-md-5"><h3><a href="#">Full Interactive Map</a></h3><a href="#"><img src="img/CICFullThumb.png"/></a></div><div class="col-md-7"><p>Access more datasets and indicators for display on the interactive map.<br/><br/>Login free to COIN <a href="#">here</a> to access</p></div></div><div class="row"><div class="col-md-5"><h3><a href="#">CIC Extraction Tool</a></h3><a href="#"><img src="img/CICExtractionThumb.png"/></a></div><div class="col-md-7"><p>Full access to all 18 categories, 66 datasets, and 889 indicators.<br/><br/>Customizable data downloads available <a href="#">here</a></p></div></div></div>';
var moreDataHidden = true;
function moreDataShow(){
	if(moreDataHidden){
		$('#instructionText').empty();
	
		d3.select('#instructionText').html(moreDataContent);
		
		$('#instructions').show();
		$('#showOnMap').hide();
		moreDataHidden = false;
	}
	else{
		$('#instructions').hide();
		moreDataHidden = true;
	}
	
}
//End icon functions
function setDropdownBehavior() {		
	// don't delete: this script is ONLY used to create html to COPY over to index.html
	/*$('#primeIndLi').empty();
	var primeList = d3.select('#primeIndLi');
	primeList.append('a')
		.attr('id', 'primeIndText')
		.text('Primary Indicator');
	var mainDrop = primeList.append('ul').attr('id', 'primeInd').attr('class', 'dropdown-menu');
	
	for (var i = 0; i < CICstructure.children.length; i++) {
		var category = CICstructure.children[i];
		var catLi = mainDrop.append('li').attr('class', 'category').attr('title', category.name);
		catLi.append('a').text(category.name);
		var catDrop = catLi.append('ul').attr('class', 'dropdown-menu');
		
		for (var j = 0; j < category.children.length; j++) {
			var dataset = category.children[j];
			var dsLi = catDrop.append('li').attr('class', 'dataset').attr('title', dataset.name);
			dsLi.append('a').text(dataset.name);
			var dsDrop = dsLi.append('ul').attr('class', 'dropdown-menu');
			
			for (var k = 0; k < dataset.children.length; k++) {
				var indicator = dataset.children[k];
				var indLi = dsDrop.append('li').append('a')
					.attr('class', 'indicator')
					.attr('title', indicator.name)
					.attr('href', '#')
					.text(indicator.name);
			}
		}
	}*/
	
	d3.select('#primeInd').selectAll('.dataset').each(function() {
		var dataset = d3.select(this);		
		var datasetName = dataset.attr('name');

		dataset.selectAll('li').on('click', function() {
			if (!d3.select(this).classed('disabled')) {
				$.SmartMenus.hideAll();
				var indicatorName = d3.select(this).select('.indicator').attr('name');
				if (currentDI === datasetName + ' - ' + indicatorName) {
					noty({text: 'Already showing "' + indicatorName + '"!'});
				} else {
					update(datasetName, indicatorName);			
					d3.select('#primeIndText').html(this.innerHTML + '<span class="sub-arrow"></span>');
				}
			}
		});
	});
	
	d3.select('#secondInd').selectAll('.dataset').each(function() {
		var dataset = d3.select(this);
		var datasetName = dataset.attr('name');
		dataset.selectAll('li').on('click', function() {
			if (!d3.select(this).classed('disabled')) {
				var indicatorName = d3.select(this).select('.indicator').attr('name');
				if (currentSecondDI !== datasetName + ' - ' + indicatorName) {
					appendSecondInd(datasetName, indicatorName);
					d3.select('#secondIndText').html(this.innerHTML + '<span class="sub-arrow"></span>');
				}
			}
		});
	});
			
	//d3.selectAll('.indicator').style('cursor', 'pointer'); // uncomment if you want disabled to cursor: pointer
	d3.selectAll('.dataset').selectAll('li:not(.disabled)').selectAll('.indicator').style('cursor', 'pointer');
}

function setSearchBehavior() {
	// both of these are redundant and causing search to fire multiple times
	//d3.select('#search_form').on('submit', submitSearch);	
	//var searchField = d3.select('#search_field').on('keyup', function() { if (d3.event.keyCode === 13) submitSearch(); });
	var searchField = d3.select('#search_field');
	var stateDrop = d3.select('#stateDropLi');
	
	d3.select('#search_submit').on('click', submitSearch);
		
	d3.select('#searchTypeDrop').selectAll('a').on('click', function() {
		if (searchType !== this.name) {
			$('#search_field').val('');
			
			if (this.name === 'state') searchField.classed('hidden', true);
			else searchField.classed('hidden', false);
	
			if (this.name === 'city') stateDrop.classed('hidden', true);
			else stateDrop.classed('hidden', false);
		}	
		searchType = this.name;
		d3.select('#searchTypeText').html(toTitleCase(searchType) + ' Search' + '<span class="sub-arrow"></span>');
	});
	d3.select('#stateDrop').selectAll('a').on('click', function() {
		if (searchState !== this.name) {
			searchState = this.name;		
			d3.select('#stateDropText').html(searchState  + '<span class="sub-arrow"></span>');
			
			//if (searchType === 'state' && searchState !== 'State') submitSearch();
		} 
	});
}

function submitSearch() {
	d3.event.preventDefault();
		
	var search_str = d3.select('#search_field').property('value');
	var results_container = d3.select('#container');

	if (searchType === 'state') {
		// only state; return results of all counties within state
		if (searchState === 'MA' || searchState === 'RI' || searchState === 'CT') {
			noty({text: 'No county data available for this state.'});
		} else {
			state_search_str = 'state.cfm?statecode=' + searchState;
			displayResults(state_search_str);
		}
							
	} else if (searchType === 'county') {
		// trim out the fat
		var search_arr = search_str.split(" ");
		var geoDesc = ["County", "County,", "City", "City,", "city", "city,", "Borough", "Borough,", "Parish", "Parish,"];
		var countyName = "";
		var descBin = false;
		for (var i = 0; i < search_arr.length; i++) {
			var a = search_arr[i].toUpperCase();
			for (var j = 0; j < geoDesc.length; j++) {
				if (a == geoDesc[j].toUpperCase()) {
					descBin = true;
					break;
				}
			}
			if (!descBin) countyName = countyName.concat(a, " ");
		}
		countyName = countyName.replace(",", "");
	
		// check for entire phrase matches
		var search_comb = "", full_match = false;
		for (var j = 0; j < geoDesc.length; j++) {
			search_comb = toTitleCase(countyName) + geoDesc[j] + " " + searchState;
			if (idByName[search_comb]) {
				full_match = true;
				foundId = parseInt(idByName[search_comb]);
				executeSearchMatch(foundId);
				break;
			}
		}

		if (full_match === false) {
			// check for partial word matches
			var pMatchArray = [];
			for (var ind in idByName) {
				var db_array = ind.split(', ');
				if (db_array[1] === searchState || searchState === 'State') {
					if (db_array[0].toLowerCase().indexOf(countyName.toLowerCase().trim()) != -1) {
						pMatchArray.push(parseInt(idByName[ind]));
					}
				}
			}				

			if (pMatchArray.length > 1) {
				// display all matches if more than one match
				$('#instructionText').empty();
					d3.select('#instructionText').append('p').text('Your search returned ' + pMatchArray.length + ' results');
					
				var rTable = d3.select('#instructionText').append('div').attr('id', 'multiCountyResult').attr('class', 'container-fluid').append('table')
					.attr('class', 'table table-striped table-condensed table-hover').append('tbody');
				var rTitleRow = rTable.append('tr');
				var rTitleFIPS = rTitleRow.append('th').text('FIPS');
				var rTitleCounty = rTitleRow.append('th').text('County Name');
				var rTitleState = rTitleRow.append('th').text('State');
					
				for (var i = 0; i < pMatchArray.length; i++) {
					var countyObj = countyObjectById[pMatchArray[i]];
					var nameArr = countyObj.geography. split(', ');
					
					var countyRow = rTable.append('tr');
					var FIPS_cell = countyRow.append('td')
						.text(countyObj.fips_num);
					var name_cell = countyRow.append('td')
						.classed('county_link', true)
						.text(nameArr[0]); 
					var state_cell = countyRow.append('td')
						.text(nameArr[1]);
	
					(function(cell, fips) {
						cell.on('click', function() { executeSearchMatch(fips); });
					})(name_cell, pMatchArray[i]);
				}
				
				$('#showOnMap').hide();
				$('#instructions').show();
							
			} else if (pMatchArray.length == 1) {
				executeSearchMatch(pMatchArray[0]); // if only one match, display county
			} else {
				noty({text: 'Your search did not match any counties.'});
				document.getElementById('search_form').reset();	
			}
		}
		
	} else if (searchType === 'city') {
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
	//$('#stateDropLi').val('State'); // doesnt work right now
	
	var county = countyObjectById[parseInt(FIPS)];
    if (county) {
		highlight(county);
		var zoomTransition = zoomTo(FIPS);
	    populateTooltip(county);
		zoomTransition.each('end', function() { 
			positionTooltip($('.active')[0]); 
		});
	} else {
		tooltip.classed('hidden', true);
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
	
	indObjects = allData(dataset, indicator); // pull data from JSON
	currentDataType = indObjects[0].dataType;

	//This is Where GET requests are issued to the server for JSON with fips, county name/state, plus indicator properties; redefine "data" variable as this JSON
	//"data" should be structured as a JSON with an array of each county.  each county has properties "id"(fips), "geography"(county name, ST), and each of the indicators specified above and clicked and doubleclicked data
	//
	d3.tsv("data/CData.tsv", function(error, countyData) {
		data = countyData;
		quantByIds = [];
		for (var i = 0; i < indObjects.length; i++) quantByIds.push([]);
		
		countyData.forEach(function(d) {			
			for (var i = 0; i < indObjects.length; i++) {
				quantByIds[i][d.id] = isNumFun(indObjects[i].dataType) ? parseFloat(d[indObjects[i].dataset+' - '+indObjects[i].name]) : d[indObjects[i].dataset+' - '+indObjects[i].name];
			}

			idByName[d.geography] = d.id;
			countyObjectById[d.id] = d;
		});
		
		var isNumeric = isNumFun(currentDataType);
		var quantById = quantByIds[0];
	
		// define domain
		if (isNumeric) {
			var domain = [];
			for (var ind in quantById) {
				if (currentDataType === 'level') {
					// for levels, we do not want "zero" to be considered during the quantile categorization
					if (parseFloat(quantById[ind]) === 0) domain[ind] = ".";
					else domain[ind] = quantById[ind];
				} else {
					domain[ind] = quantById[ind];	
				}
			}
		} else {
			// translating string values to numeric values
			var numCorrVals = 0, vals = {}, corrVal = 0;
			for (var ind in quantById) {
				if (!vals.hasOwnProperty(quantById[ind])) {
					vals[quantById[ind]] = corrVal;
					corrVal++;
				}
				corrDomain[ind] = vals[quantById[ind]];
			}
			for (var ind in vals) numCorrVals++;
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
				range = [];
				var availColors = categorical_colors;
				for (var i = 0; i < numCorrVals; i++) range.push(availColors[i]);				
				break;
			default:
				range = level_colors;
		}

		// set domain and range
		if (isNumeric) color.domain(domain).range(range);
		else color.domain(corrDomain).range(range);

		fillMapColors(); // fill in map colors
		isNumeric ? createLegend() : createLegend(vals); // create the legend; note: vals is a correspondence array linking strings with numbers for categorical dataTypes
		
		// list source
		d3.select("#additionalInfo").selectAll("p").remove();
		var sourceContainer = d3.select('#additionalInfo').append('p').attr("id", "sourceText")
			.html('<i>Source</i>: ' + indObjects[0].source + ', ' + indObjects[0].year);
		
		// list definitions
		var defContainer = d3.select("#additionalInfo").append("p").attr("id", "definitionsText");
		for (var i = 0; i < indObjects.length; i++) {
			defContainer.append('div')
				.html('<b>' + indObjects[i].name + '</b>: ' + indObjects[i].definition);
		}
		
	});
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
				
		if (d3.select('.active').empty() !== true) populateTooltip(selected);
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
	var Jcategory;
	var structure = CICstructure.children;
	for (var i = 0; i < structure.length; i++) {
		for (var j = 0; j < structure[i].children.length; j++) {
			if (structure[i].children[j].name === dataset) {
				Jcategory = structure[i];
				var Jdataset = structure[i].children[j];
				selectedIndYear = d3.max(Jdataset.years);
				//vintage = Jdataset.vintage;
				sourceText = Jdataset.source;
				companions = Jdataset.companions;
				//dataNotes = Jdataset.notes;
				for (var h = 0; h < Jdataset.children.length; h++) {
					if (indicator === Jdataset.children[h].name) {
						//primeInd is a JSON object from CIC-structure with the properties: name, units, dataType
						selectedInd = Jdataset.children[h];
						//append dataset properties to the selected indicator
							selectedInd.year = selectedIndYear;
							//selectedInd.vintage = vintage;
							selectedInd.source = sourceText;
							//selectedInd.notes = dataNotes;
							selectedInd.dataset = Jdataset.name;
							selectedInd.companions = companions;
							
						break;
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
			return isNaN(corrDomain[d.id]) ? na_color : range[corrDomain[d.id]];
		}
	});
}

function createLegend(keyArray) {
	d3.selectAll(".legend svg").remove();
	d3.select("#legendTitle").remove();

	var primeIndObj = indObjects[0];
	var isCurrency = (primeIndObj.hasOwnProperty('unit')) ? (primeIndObj.unit.indexOf("dollar") != -1) : false; // determine if indicator values are currency by checking units
	var legendTitle = primeIndObj.year + " " + primeIndObj.name;
	//if (primeIndObj.dataType !== 'binary' && primeIndObj.dataType !== 'categorical') legendTitle += " in " + primeIndObj.unit; 

	if (primeIndObj.dataType !== 'none') {
		var options = {
			//title : "legend",
			boxHeight : 18,
			boxWidth : 58,
			dataType : primeIndObj.dataType,
			isCurrency : isCurrency,
			formatFnArr: format
		};
		if (keyArray) options.keyArray = keyArray;
		
		d3.select(".legend").append("div").attr("id", "legendTitle").text(legendTitle);
		legend = colorlegend("#quantileLegend", color, "quantile", options);
	}
}
function moveLegend(){
	var parentWidth = $('#quantileLegend').width();
		if(parentWidth<350){
			parentWidth=350;
		}
	d3.select('.colorlegend').attr('transform', 'translate(' + (parentWidth-350)/2 + ',' + 0 + ')');
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
		var isCurrency = obj.hasOwnProperty('unit') ? (obj.unit.indexOf("dollar") != -1) : false; // determine if indicator values are currency by checking units
		var value = format_tt[obj.dataType](quant[d.id], isCurrency);
		if (value === '$NaN' || value === 'NaN' || value === 'NaN%') {
			value = 'Not Available';
		} else {
			none_avail = false;
		}

		if (obj.name.indexOf('(') != -1) {
			var name = obj.name.substring(0, obj.name.indexOf('('));
		} else {
			var name = obj.name;
		}
		
		row.append('td').attr('class', 'dataName').classed('leftborder', secondary).text(obj.year + ' ' + name + ':');
		row.append('td').attr('class', 'dataNum').text(value);
		
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
	tooltip.classed('hidden', false);
	var ttWidth = $('#tt').width(); // tooltip width and height
	var ttHeight = $('#tt').height();
	
	var countyCoord = county.getBoundingClientRect();
	var left = countyCoord.left + countyCoord.width - ttWidth + document.body.scrollLeft;
	var top = countyCoord.top - ttHeight + document.body.scrollTop - 10;
	
	// checks if tooltip goes past window and adjust if it does
	var dx = windowWidth - (left + ttWidth); // amount to tweak
	var dy = windowHeight - (top + ttHeight);
			
	if (dx < 0) left += dx;
	if (dy < 0) top += dy;
	
	tooltip.transition()
	  	.style("left", (left) + "px")
	  	.style("top", (top) + "px");
}


function doubleClicked(d) {
	tooltip.classed("hidden", true);
	
	var countyID = d.id.toString();
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
	frmrActive = d3.select(".active");
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
  headHeight = $('#header').height();
  d3.select('svg').remove();
  setup(width,height);
  draw(topo, stateMesh);
  moveLegend();
}

function moveStart() {}
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
function moveEnd() {
	//if (d3.select('.active').empty() !== true) positionTooltip(document.getElementsByClassName('active')[0]);
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
	var coords = map.getBoundingClientRect();
	d3.select('#zoomIcons').style({'left': (coords.left + 30) + 'px', 'top': headHeight + 15 + 'px'});
	
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


var throttleTimer;
d3.select(document.body).on('keyup',function(){if(d3.event.ctrlKey&&d3.event.shiftKey&&d3.event.keyCode===76){var i=currentDI.lastIndexOf(' - ');update(currentDI.substring(0,i),currentDI.substring(i+3,currentDI.length));level_colors=['rgb(189,215,231)','rgb(107,174,214)','rgb(49,130,189)','rgb(7,81,156)','rgb(28,53,99)'];}});
function throttle() {
  window.clearTimeout(throttleTimer);
    throttleTimer = window.setTimeout(function() {
      redraw();
    }, 200);
}

setup(width,height);

d3.json("us.json", function(error, us) {
	var counties = topojson.feature(us, us.objects.counties).features;
	var states = topojson.mesh(us, us.objects.states, function(a, b) { return a !== b; });

	counties.forEach(function(d) { countyPathById[d.id] = d; });

	topo = counties;
	stateMesh = states;
  
	draw(topo, stateMesh); 
});

d3.json("data/CICstructure.json", function(error, CICStructure){
	CICstructure = CICStructure;

	// temp check to see if all indicators are in crosswalk
	d3.tsv('data/database_crosswalk.tsv', function(error, data_array) {
		// collect cicstructure indicators
		var cic_ind = [];
		for (var i = 0; i < CICstructure.children.length; i++) {
			var category = CICstructure.children[i];
			for (var j = 0; j < category.children.length; j++) {
				var dataset = category.children[j];
				for (var k = 0; k < dataset.children.length; k++) {
					var indicator = dataset.children[k];
					cic_ind.push(dataset.name + ' - ' + indicator.name);
				}
			}
		}		
		// collect database indicators
		var db_ind = [];
		for (var i = 0; i < data_array.length; i++) {
			if (data_array[i].indicator !== '') {
				db_ind.push(data_array[i].dataset + ' - ' + data_array[i].indicator);
			}
		}	
		// check to see if indicator names match names in CICstructure
		/*for (var i = 0; i < db_ind.length; i++) {
			var name_match = false;
			for (var j = 0; j < cic_ind.length; j++) {
				if (db_ind[i] === cic_ind[j]) {
					name_match = true;
					break;
				}
			}
			if (name_match === false) console.log('Name mismatch in Database Crosswalk to CICstructure: ' + db_ind[i]);
		}*/
		
		// check to see if indicators are missing
		/*for (var i = 0; i < cic_ind.length; i++) {
			var ind_match = false;
			for (var j = 0; j < db_ind.length; j++) {
				if (cic_ind[i] === db_ind[j]) {
					ind_match = true;
					break;
				}	
			}
			if (ind_match === false) console.log('Missing indicator in Database Crosswalk: ' + cic_ind[i]);
		}*/
	});

	setBehaviors();

	// dataset to map first
	update("Population Levels and Trends", "Population Level");	
});