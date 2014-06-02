d3.select(window).on("resize", throttle);

function toTitleCase(str){ return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();}); }
function isNumFun(data_type) { return (data_type === 'level' || data_type === 'level_np' || data_type === 'percent'); }
function positionInstruction(){var instructionLeft = (windowWidth * .2) / 2; if(windowWidth > 1125){instructionLeft = (windowWidth - 900)/2;}; d3.select('#instructions').style("left", instructionLeft + "px");}

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

var zoom = d3.behavior.zoom()
    .scaleExtent([1, 10])
    .on("zoom", move);

var width = document.getElementById('container').offsetWidth-60,
	height = width / 2,
	windowWidth = $(window).width();;

var projection = d3.geo.albersUsa()
    .scale(width)
    .translate([width / 2, height / 2]);

var path = d3.geo.path()
	.projection(projection);

var topo,stateMesh,projection,path,svg,g;

var tooltip = d3.select("#container").append("div").attr("class", "tooltip hidden").attr("id", "tt");
var tipContainer = tooltip.append('div').attr('id', 'tipContainer');
var tooltipOffsetL = document.getElementById('container').offsetLeft+(width/2)+40;   //offsets plus width/height of transform, plus 20 px of padding, plus 20 extra for tooltip offset off mouse
var tooltipOffsetT = document.getElementById('container').offsetTop+(height/2)+20;


var CICstructure,
	selectedData, selectedDataset, selectedDataText = "GDP Growth, 2013",
	showingSecond = false,
	dataYear,
	data,
	legend,
	selected;
		
var quantById = [], secondQuantById = [], thirdQuantById = [], fourthQuantById = [],
	s_quantById = [], s_secondQuantById = [], s_thirdQuantById = [], s_fourthQuantById = [],
	primeInd = {},
	nameById = [],
	idByName = {},
	countyCoords = [],
	countyObjectById = {},
	countyPathById = {};

var quantOneThird,
	quantTwoThird,
	na_color = 'rgb(200,200,200)',
	range = ['rgb(239,243,255)','rgb(189,215,231)','rgb(107,174,214)','rgb(49,130,189)','rgb(8,81,156)'];
	
var color = d3.scale.quantile();

d3.json("data/CICstructure.json", function(error, CICStructure){	
	CICstructure = CICStructure;

	setDropdownBehavior();
	setSearchBehavior();  

	// dataset to map first
	update("Payment in Lieu of Taxes (PILT)", "PILT Amount");
	
});


function setup(width, height) {
	projection = d3.geo.albersUsa()
    .translate([0, 0])
    .scale(width *1.1);

  path = d3.geo.path()
      .projection(projection);

  svg = d3.select("#map").append("svg")
      .attr("width", width)
      .attr("height", height)
      .append("g")
      .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")")
      .call(zoom);

  g = svg.append("g")
  		.attr("class", "counties");
  		
  d3.select('#map').on('click', function() { if (selected !== null) highlight(selected); });
  d3.select('#close').on('click', function() { $('#instructions').hide(); });

	positionInstruction();
	
	//add Not Applicable data box
	//d3.select("#legendNoData").insert("svg").append("rect").attr({"width": "60", "height": "15", "x": "30", "y": "10"}).style("fill", na_color);
}

	

d3.json("us.json", function(error, us) {

  var counties = topojson.feature(us, us.objects.counties).features;
  var states = topojson.mesh(us, us.objects.states, function(a, b) { return a !== b; });

	counties.forEach(function(d) { 
	  	countyPathById[d.id] = d;
	  	//countyCoords[d.id] = d.centroid();
	});

  topo = counties;
  stateMesh = states;
  
  draw(topo, stateMesh);
  
});

function draw(topo, stateMesh) {
  var county = g.selectAll(".county").data(topo);
  
  county.enter().insert("path")
      .attr("class", "county")
      .attr("d", path)
      .attr("id", function(d){ return d.id;})
      .style("fill", function(d) { if(!isNaN(quantById[d.id])){return color(quantById[d.id]);} else{return na_color;} });

  g.append("path")
		      .datum(stateMesh)
		      .attr("id", "state-borders")
		      .attr("d", path);
  
  //tooltips
  var clickCount = 0;
  county
    .on('click', function(d, i) {
    	d3.event.stopPropagation();
    	var mouse = d3.mouse(svg.node()).map( function(d) { return parseInt(d); } );
		
		highlight(d);
		
		clickCount++;
		if (clickCount === 1) {
			singleClickTimer = setTimeout(function() {
				clickCount = 0;
				if (d3.select('.active').empty() !== true) clicked(mouse, tooltipOffsetL, tooltipOffsetT, d, i);
			}, 300);
		} else if (clickCount === 2) {
			clearTimeout(singleClickTimer);
			clickCount = 0;
			doubleClicked(d, i);
		}
	}, false);
    
   
}

function setDropdownBehavior() {		
	// this script is ONLY used to create html to COPY over to index.html
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
	
	d3.select('#primeInd').selectAll('.dataset').selectAll('.indicator').on('click', function() {
		var datasetName = this.parentNode.parentNode.parentNode.title; // real hokey, will fix eventually
		var indicatorName = this.title;
		d3.select("#primeIndText").html(indicatorName);
		
		highlight(selected);
		update(datasetName, indicatorName);
	});
	d3.select('#secondInd').selectAll('.dataset').selectAll('.indicator').on('click', function() {
		var datasetName = this.parentNode.parentNode.parentNode.title;
		var indicatorName = this.title;
		d3.select('#secondIndText').html(indicatorName);
		
		highlight(selected);
		appendSecondInd(datasetName, indicatorName);
	});
	
	d3.selectAll('.indicator').style('cursor', 'pointer');
}

function setSearchBehavior() {
	d3.select('#search_form').on('submit', submitSearch);	
	var searchField = d3.select('#search_field').on('keyup', function() { if (d3.event.keyCode === 13) submitSearch(); });	
	d3.select('#search_submit').on('click', submitSearch);
		
	var stateDrop = d3.select('#state_drop');
	var typeDrop = d3.select('#search_type');
		
	typeDrop.on('change', function() {
		var type = typeDrop.property('value');
		
		if (type === 'state') searchField.style('display', 'none');
		else searchField.style('display', '');

		if (type === 'city') stateDrop.style('display', 'none');
		else stateDrop.style('display', '');
		
		searchField.attr('placeholder', type + ' name');
	});
}

function submitSearch() {
	d3.event.preventDefault();
		
	var search_type = d3.select('#search_type').property('value');
	var search_str = d3.select('#search_field').property('value');
	var state_name = d3.select('#state_drop').property('value');
	var results_container = d3.select('#container');

	if (search_type === 'state') {
		// only state; return results of all counties within state
		displayResultsInFrame('ciccfm/state.cfm?statecode='+encodeURIComponent(state_name));
							
	} else if (search_type === 'county') {
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
			search_comb = toTitleCase(countyName) + geoDesc[j] + " " + state_name;
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
				if (db_array[1] === state_name || state_name === '') {
					if (db_array[0].toLowerCase().indexOf(countyName.toLowerCase().trim()) != -1) {
						pMatchArray.push(parseInt(idByName[ind]));
					}
				}
			}				

			if (pMatchArray.length > 1) {
				// display all matches if more than one match
				$('#instructionText').empty();
				var rTable = d3.select('#instructionText').append('table')
					.classed('search_results_table', true);
				var rTitleRow = rTable.append('tr').style('font-weight', 'bold');
				var rTitleFIPS = rTitleRow.append('td').text('FIPS');
				var rTitleCounty = rTitleRow.append('td').text('County Name');
				var rTitleState = rTitleRow.append('td').text('State');
					
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
				
				// styling; in anonymous function for closure in click function
				rTable.selectAll('tr').selectAll('td')
					.classed('search_results_cell', true);
					
				$('#instructions').show();
							
			} else if (pMatchArray.length == 1) {
				executeSearchMatch(pMatchArray[0]); // if only one match, display county
			} else {
				alert('search not matched :(');
				document.getElementById('search_form').reset();	
			}
		}
		
	} else if (search_type === 'city') {
		// city search: use city-county lookup
		var search_str_array = search_str.toLowerCase().split('city');
		var city_search_str = '';
		for (var i = 0; i < search_str_array.length; i++) city_search_str += search_str_array[i];
		
		displayResultsInFrame('http://www.uscounties.org/cffiles_web/counties/city_res.cfm?city='+encodeURIComponent(city_search_str.trim()));
	}
}

function executeSearchMatch(FIPS) {
	var county = countyObjectById[FIPS];
	
	highlight(county);
	//zoomTo(county);
	doubleClicked(county);
	
	//document.getElementById('search_form').reset();				
};

function displayResultsInFrame(url) {
	tooltip.classed("hidden", true);
	
	$('#instructionText').empty();
	var frame = d3.select('#instructionText').append('iframe')
		.classed('result_iframe', true)
		.attr('height', '300px') // very arbitrary, might want to change this
		.attr('src', url);
  			
	$('#instructions').show();
}

function zoomTo(d) {
	// not working...
	var t = d3.event.translate;
	var s = 4;
	var h = height / 2;

	//t[0] = Math.min(width / 2 * (s - 1), Math.max(width / 2 * (1 - s), t[0]));
	//t[1] = Math.min(height / 2 * (s - 1), Math.max(height / 2 * (1 - s), t[1]));
	//original function: t[1] = Math.min(height / 2 * (s - 1) + h * s, Math.max(height / 2 * (1 - s) - h * s, t[1]));
	//maximum translate value is 1944 (maine) from scale = 10 (t-value of 1902)
	//1190 from 6 (1145)
	//743 from 3.7 (626)
	//343 from 2.2 (339)
	//167 from 1.3 (132)
	//0 from 1 (0)

	g.style("stroke-width", 1 / s).attr("transform", "translate(" + [0,0] + ")scale(" + s + ")"); 

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



function update(dataset, indicator) {
	tooltip.classed("hidden", true);
	
	var indObject = allData(dataset, indicator); // pull data from JSON and fill primeIndObj, secondIndObj, etc.
	primeIndObj = indObject[0];
	secondIndObj = indObject[1];
	thirdIndObj = indObject[2];
	fourthIndObj = indObject[3];

	//This is Where GET requests are issued to the server for JSON with fips, county name/state, plus primeInd.name, secondInd.name, thirdInd.name, and fourthInd.name; redefine "data" variable as this JSON
	//"data" should be structured as a JSON with an array of each county.  each county has properties "id"(fips), "geography"(county name, ST), and each of the indicators specified above and clicked and doubleclicked data
	//
	d3.tsv("CData.tsv", function(error, countyData) {
		data = countyData;

		countyData.forEach(function(d) {
			quantById[d.id] =  isNumFun(primeIndObj.dataType) ? parseFloat(d[dataset+' - '+indicator]) : d[dataset+' - '+indicator];					
			secondQuantById[d.id] =  isNumFun(secondIndObj.dataType) ? parseFloat(d[secondIndObj.dataset+' - '+secondIndObj.name]) : d[secondIndObj.dataset+' - '+secondIndObj.name];		
			thirdQuantById[d.id] =  isNumFun(thirdIndObj.dataType) ? parseFloat(d[thirdIndObj.dataset+' - '+thirdIndObj.name]) : d[thirdIndObj.dataset+' - '+thirdIndObj.name];		
			fourthQuantById[d.id] =  isNumFun(fourthIndObj.dataType) ? parseFloat(d[fourthIndObj.dataset+' - '+fourthIndObj.name]) : d[fourthIndObj.dataset+' - '+fourthIndObj.name];		

			nameById[d.id] = d.geography;
			idByName[d.geography] = d.id;
			countyObjectById[d.id] = d;
		});
		
		var dataType = primeIndObj.dataType;
		var isNumeric = isNumFun(dataType);

		if (!isNumeric) {
			// translating string values to numeric values
			var numCorrVals = 0, vals = {}, corrVal = 0, corrDomain = [];
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
		switch(dataType) {
			case "percent":
				range = ['rgb(239,243,255)', 'rgb(189,215,231)', 'rgb(107,174,214)', 'rgb(49,130,189)', 'rgb(8,81,156)'];
				break;
			case "binary":
				range = ['rgb(201,228,242)', 'rgb(255,204,102)'];
				break;
			case "categorical":
				// max is 5 categories
				range = [];
				var availColors = ['rgb(228,26,28)', 'rgb(55,126,184)', 'rgb(77,175,74)', 'rgb(152,78,163)', 'rgb(255,127,0)'];
				for (var i = 0; i < numCorrVals; i++) range.push(availColors[i]);				
				break;
			default:
				range = ['rgb(239,243,255)', 'rgb(189,215,231)', 'rgb(107,174,214)', 'rgb(49,130,189)', 'rgb(8,81,156)'];
		}
		
		// set domain and range
		if (isNumeric) color.domain(quantById).range(range);
		else color.domain(corrDomain).range(range);

		// fill in map colors
		frmrActive = null;
		g.selectAll(".counties .county").transition().duration(750).style("fill", function(d) {
			if (isNumeric) {
				return isNaN(quantById[d.id]) ? na_color : color(quantById[d.id]);
			} else {
				return isNaN(corrDomain[d.id]) ? na_color : range[corrDomain[d.id]];
			}
		});

		isNumeric ? createLegend() : createLegend(vals); // note: vals is a correspondence array linking strings with numbers for categorical dataTypes
		
		// list source
		d3.select("#resultWindow").selectAll("p").remove();
		var sourceContainer = d3.select('#resultWindow').append('p').attr("id", "sourceText")
			.html('<i>Source</i>: ' + primeIndObj.source + ', ' + primeIndObj.year);
		
		// list definitions
		var obj = [primeIndObj, secondIndObj, thirdIndObj, fourthIndObj];
		var defContainer = d3.select("#resultWindow").append("p").attr("id", "definitionsText");
		for (var i = 0; i < obj.length; i++) {
			defContainer.append('div')
				.html('<b>' + obj[i].name + '</b>: ' + obj[i].definition);
		}
		
		// change title of dropdown to current indicator
		d3.select('#primeIndText').text(primeIndObj.name);
	});
}

function appendSecondInd(dataset, indicator) {
	showingSecond = true;
	tooltip.classed("hidden", true);
	
	var indObject = allData(dataset, indicator);
	s_primeIndObj = indObject[0];
	s_secondIndObj = indObject[1];
	s_thirdIndObj = indObject[2];
	s_fourthIndObj = indObject[3];
	
	d3.tsv("CData.tsv", function(error, countyData) {
		countyData.forEach(function(d) {
			s_quantById[d.id] =  isNumFun(s_primeIndObj.dataType) ? parseFloat(d[dataset+' - '+indicator]) : d[dataset+' - '+indicator];					
			s_secondQuantById[d.id] =  isNumFun(s_secondIndObj.dataType) ? parseFloat(d[secondIndObj.dataset+' - '+secondIndObj.name]) : d[secondIndObj.dataset+' - '+secondIndObj.name];		
			s_thirdQuantById[d.id] =  isNumFun(s_thirdIndObj.dataType) ? parseFloat(d[thirdIndObj.dataset+' - '+thirdIndObj.name]) : d[thirdIndObj.dataset+' - '+thirdIndObj.name];		
			s_fourthQuantById[d.id] =  isNumFun(s_fourthIndObj.dataType) ? parseFloat(d[fourthIndObj.dataset+' - '+fourthIndObj.name]) : d[fourthIndObj.dataset+' - '+fourthIndObj.name];		
		});
		
		// not written; populate a second tooltip to go side by side with primary tooltip, but only when a second indicator is selected.  Will need a global "comaprison" boolean switch.  See county tracker - comparison branch if need template
		

	});
}

function cancelSecondInd() {
	showingSecond = false;
	
	// remove second tooltip
	//under what conditions do we activate this?  is there a button, etc?
}


var primeIndObj = {}, secondIndObj = {}, thirdIndObj = {}, fourthIndObj = {};

function allData(dataset, indicator){
	
	var firstObj = getData(dataset, indicator);
	// grab companion indcators through same function
	var secondObj = getData(firstObj.companions[0][0], firstObj.companions[0][1]);
	var thirdObj = getData(firstObj.companions[1][0], firstObj.companions[1][1]);
	var fourthObj = getData(firstObj.companions[2][0], firstObj.companions[2][1]);
	
	//ensure no duplicates between primeInd and one of its companions;
	if(secondObj.name === firstObj.name){
		secondObj = thirdObj;
		thirdObj = fourthObj;
		fourthObj = getData(firstObj.companions[3][0], firstObj.companions[3][1]);
	}
	else if (thirdObj.name === firstObj.name){
		thirdObj = fourthObj;
		fourthObj = getData(firstObj.companions[3][0], firstObj.companions[3][1]);
	}
	else if (fourthObj.name === firstObj.name){
		fourthObj = getData(firstObj.companions[3][0], firstObj.companions[3][1]);
	}
	
	return [firstObj, secondObj, thirdObj, fourthObj];
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

function createLegend(keyArray) {
	d3.selectAll(".legend svg").remove();
	d3.select("#legendTitle").remove();

	var isCurrency = (primeIndObj.hasOwnProperty('unit')) ? (primeIndObj.unit.indexOf("dollar") != -1) : false; // determine if indicator values are currency by checking units
	var legendTitle = primeIndObj.year + " " + primeIndObj.name;
	//if (primeIndObj.dataType !== 'binary' && primeIndObj.dataType !== 'categorical') legendTitle += " in " + primeIndObj.unit; 

	if (primeIndObj.dataType !== 'none') {
		var options = {
			//title : "legend",
			boxHeight : 15,
			boxWidth : 60,
			dataType : primeIndObj.dataType,
			isCurrency : isCurrency,
			formatFnArr: format
		};
		if (keyArray) options.keyArray = keyArray;
		
		d3.select(".legend").append("div").attr("id", "legendTitle").text(legendTitle);
		legend = colorlegend("#quantileLegend", color, "quantile", options);
	}
}

function populateTooltip(d) {
	$('#tipContainer').empty();
    tipContainer.append('div')
    	.attr('id', 'tipLocation')
    	.text(countyObjectById[d.id].geography);

	var obj = [primeIndObj, secondIndObj, thirdIndObj, fourthIndObj],
		quant = [quantById, secondQuantById, thirdQuantById, fourthQuantById];
	if (showingSecond) {
		s_obj = [s_primeIndObj, s_secondIndObj, s_thirdIndObj, s_fourthIndObj],
		s_quant = [s_quantById, s_secondQuantById, s_thirdQuantById, s_fourthQuantById];
	}
		
	// loop through primary and all three companions and display corresponding formatted values
	var tipInfo1 = tipContainer.append('div').attr('id', 'tipInfo1');	
	var tipTable = tipInfo1.append('table').attr("class", "table");
	var none_avail = true;
	for (var i = 0; i < obj.length; i++) {
		var isCurrency = obj[i].hasOwnProperty('unit') ? (obj[i].unit.indexOf("dollar") != -1) : false; // determine if indicator values are currency by checking units
		var value = format[obj[i].dataType](quant[i][d.id], isCurrency);
		if (!isNaN(value)) {
			none_avail = false;
		} else {
			value = "Not Available";
		}

		if (obj[i].name.indexOf('(') != -1) {
			var name = obj[i].name.substring(0, obj[i].name.indexOf('('));
		} else {
			var name = obj[i].name;
		}
		
		var row = tipTable.append('tr')
			.attr('class', 'tipKey');
		row.append('td').attr('class', 'dataName').text(obj[i].year + ' ' + name + ':');
		row.append('td').attr('class', 'dataNum').text(value);
			
		if (showingSecond) {
			var s_isCurrency = s_obj[i].hasOwnProperty('unit') ? (s_obj[i].unit.indexOf("dollar") != -1) : false; // determine if indicator values are currency by checking units
			var s_value = format[s_obj[i].dataType](s_quant[i][d.id], s_isCurrency);
			if (!isNaN(s_quant[i][d.id])) {
				s_value = "Not Available";
			} 
	
			if (obj[i].name.indexOf('(') != -1) {
				var s_name = s_obj[i].name.substring(0, s_obj[i].name.indexOf('('));
			} else {
				var s_name = s_obj[i].name;
			}

			row.append('td').attr('class', 'dataName').text(s_obj[i].year + ' ' + s_name + ':');
			row.append('td').attr('class', 'dataNum').text(s_value);			
		}
	}
	/*if (none_avail) {
		tipTable.selectAll('tr').remove();
		tipTable.append('tr').attr('class', 'tipKey').html('<td>No data available for this county</td>');
	}*/

}

function clicked(mouse, l, t, d, i) {
	if (countyObjectById.hasOwnProperty(d.id)) {
	    tooltip
	     	.classed("hidden", false)
	      	.style("left", (mouse[0]+l) + "px")
	      	.style("top", +(mouse[1]+t) +"px");
	    populateTooltip(d);
	}
	console.log(path.centroid(d));
	
	//Zoom section
	var t = path.centroid(d);
	var s = 6;

  	t[0] = -t[0] * (s - 1);
  	t[1] = -t[1] * (s - 1);
	
  zoom.translate(t);
  g.transition().style("stroke-width", 1 / s).attr("transform", "translate(" + t + ")scale(" + s + ")");
}

function doubleClicked(d) {
	tooltip.classed("hidden", true);
	
	var countyID = d.id.toString();
	if (countyID.length == 4) countyID = "0" + countyID;
	displayResultsInFrame('http://www.uscounties.org/cffiles_web/counties/county.cfm?id=' + encodeURIComponent(countyID));
	/*d3.select('#showOnMap').on('click', function() {
	  	$('#instructions').hide();
	  	//clicked(countyPathById[d.id].geometry.coordinates[0][0], tooltipOffsetL, tooltipOffsetT, d); // a fake click to get tooltip to appear
  	});*/
}

function redraw() {
  tooltip.classed("hidden", true);
  
  windowWidth = $(window).width();
  width = document.getElementById('container').offsetWidth-60;
  height = width / 2;
  d3.select('svg').remove();
  setup(width,height);
  draw(topo, stateMesh);
}

function move() {	
  tooltip.classed("hidden", true);
	
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
	
  zoom.translate(t);
  g.transition().style("stroke-width", 1 / s).attr("transform", "translate(" + t + ")scale(" + s + ")");

}

var throttleTimer;
function throttle() {
  window.clearTimeout(throttleTimer);
    throttleTimer = window.setTimeout(function() {
      redraw();
    }, 200);
}

setup(width,height);