d3.select(window).on("resize", throttle);

function toTitleCase(str){ return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();}); }

var format = {
	"percent": d3.format('.1%'),
	"binary": function (num) {
		if (num === 1) return "Yes";
		else if (num === 0) return "No";
		else return "N/A";
	},
	"categorical": function (num) { return num; },
	"level": function (num) {
    	if (num >= 1000000000) {
    		return String((num/1000000000).toFixed(1)) + "bil";
    	} else if (num >= 1000000) {
    		return String((num/1000000).toFixed(1)) + "mil";
    	} else if (num >= 10000) {
    		return String((num/1000).toFixed(1)) + "k";
    	} else if (num >= 100) {
    		return num.toFixed(0);
    	} else if (num == 0) {
    		return 0;
    	} else {
    		return num.toFixed(1);	
    	}
    }			
};
format['level_np'] = format['level'];

var zoom = d3.behavior.zoom()
    .scaleExtent([1, 10])
    .on("zoom", move);

var width = document.getElementById('container').offsetWidth-60;
var height = width / 2;

var projection = d3.geo.albersUsa()
    .scale(width)
    .translate([width / 2, height / 2]);

var path = d3.geo.path()
	.projection(projection);

var topo,stateMesh,projection,path,svg,g;

var tooltip = d3.select("#container").append("div").attr("class", "tooltip hidden").attr("id", "tt");
var tipContainer = tooltip.append('div').attr('id', 'tipContainer');
var tooltipOffsetL = document.getElementById('container').offsetLeft+(width/2)+40;
var tooltipOffsetT = document.getElementById('container').offsetTop+(height/2)+20;


var CICstructure,
	selectedData,
	selectedDataset,
	selectedDataText = "GDP Growth, 2013",
	primeInd = {},
	dataYear,
	data,
	legend,
	selected,
	clickCount = 0;
	
var quantById = [], secondQuantById = [], thirdQuantById = [], fourthQuantById = []
	nameById = [],
	idByName = {},
	countyObjectById = {},
	countyPathById = {};

var quantOneThird,
	quantTwoThird,
	range = ['rgb(239,243,255)','rgb(189,215,231)','rgb(107,174,214)','rgb(49,130,189)','rgb(8,81,156)'];
	
var color = d3.scale.quantile();

d3.json("data/CICstructure.json", function(error, CICStructure){
	
	CICstructure = CICStructure;
	// dataset to map first
	update("Payment in Lieu of Taxes (PILT)", "PILT Amount");
	
});

function setup(width,height){
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
  		
  d3.select('#map').on('click', function() { tooltip.classed('hidden', true); });
  d3.select('#close').on('click', function() { $('#instructions').hide(); });
		
  buildIndDropdown();
  buildSearch();  
}
	

d3.json("us.json", function(error, us) {

  var counties = topojson.feature(us, us.objects.counties).features;
  var states = topojson.mesh(us, us.objects.states, function(a, b) { return a !== b; });

	counties.forEach(function(d) { 
	  	countyPathById[d.id] = d;  	
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
      .style("fill", function(d) { if(!isNaN(quantById[d.id])){return color(quantById[d.id]);} else{return "rgb(155,155,155)";} });

  g.append("path")
		      .datum(stateMesh)
		      .attr("id", "state-borders")
		      .attr("d", path);
  
  
  //offsets plus width/height of transform, plus 20 px of padding, plus 20 extra for tooltip offset off mouse

  //tooltips
  county
    .on('click', function(d, i) {
    	var mouse = d3.mouse(svg.node()).map( function(d) { return parseInt(d); } );
		
		highlight(d);
		
		clickCount++;
		if (clickCount === 1) {
			singleClickTimer = setTimeout(function() {
				clickCount = 0;
				clicked(mouse, tooltipOffsetL, tooltipOffsetT, d, i);
			}, 400);
		} else if (clickCount === 2) {
			clearTimeout(singleClickTimer);
			clickCount = 0;
			doubleClicked(d, i);
		}
	}, false);
    
   
}

function buildIndDropdown() {
	// dynamically create dropdown menu with categories pulled from json
	/*d3.json("data/CICstructure.json", function(error, CICStructure){
		if (!error) {
			// empty out dropdown
			d3.select('#primeInd')
				.selectAll('li')
					.remove();
			
			var s = CICStructure.children;
			var createCategory = function(catName) {
				/*var primeDrop = d3.select('#primeInd');
				primeDrop.append('a').text(catName);
				var cat = primeDrop.append('li');
				var cat = d3.select('#primeInd').append('li').append('a')
					.attr('name', catName)
					.attr('title', catName)
					.attr('href', '#')
					.style('text-align', 'left')
					.text(catName)
					.on('click', function(d) {
						tooltip.classed("hidden", true);				
						selectedData = "Total";
						selectedDataset = "Administration Expenditures";
						selectedDataText = catName;
						d3.select('#primeIndText').html(selectedDataText);
						
						update(selectedDataset, selectedData);
					});
				return cat;
			};
			var createIndicator = function(cat, indName) {
				var indDrop = cat.append('ul');
				indDrop.classed('dropdown-menu', true);
				indDrop.append('li')
					.append('a')
					.attr('title', indName)
					.attr('name', indName)
					.attr('href', '#')
					.text(indName);
			};
						
			for (var i = 0; i < s.length; i++) createCategory(s[i].name);
			//var testCat = createCategory('Test');
			//createIndicator(testCat, 'Test 2');
								
		} else throw new Error('Error reading JSON file');
	});*/
	
	d3.selectAll('.dataset').selectAll('.indicator').on('click', function() {
		var datasetName = this.parentNode.parentNode.parentNode.title; // real hokey, will fix eventually
		var indicatorName = this.title;
		update(datasetName, indicatorName);
	});
}

function buildSearch() {
	d3.select('#search_form').on('submit', submitSearch);	
	var searchField = d3.select('#search_field').on('keyup', function() { if (d3.event.keyCode === 13) submitSearch(); });	
	d3.select('#search_submit').on('click', submitSearch);
		
	var stateDrop = d3.select('#state_drop');
	var typeDrop = d3.select('#search_type');
	//var searchWidth = searchField.style('width');
	//var searchRight = searchField.style('right');
		
	typeDrop.on('change', function() {
		console.log("changed");
		var type = typeDrop.property('value');
		
		if (type === 'state') searchField.style('display', 'none');
		else searchField.style('display', '');
		
		if (type === 'city') {
			stateDrop.style('display', 'none');
			//searchField.style('width', (parseInt(searchWidth) + 60) + 'px');
			//searchField.style('right', (parseInt(searchRight) - 60) + 'px');
		} else {
			stateDrop.style('display', '');
			//searchField.style('width', searchWidth);
			//searchField.style('right', searchRight);
		}
		
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
		displayResultsInFrame('http://www.uscounties.org/cffiles_web/counties/state.cfm?statecode='+encodeURIComponent(state_name));
							
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
				// if only one match, display county
				executeSearchMatch(pMatchArray[0]);
			} else {
				alert('search not matched :(');
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
	zoomTo(county);
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
	zoom.scale(3);
	zoom.translate(100,100);
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
	
	if(frmrActive){
		frmrActive.style("fill", frmrFill);
	}
	
	frmrActive = d3.select(".active");
	frmrFill = frmrActive.style("fill");
	frmrActive.style("fill", null);
}



function update(dataset, indicator) {
	tooltip.classed("hidden", true);
	frmrActive = null;
	
	allData(dataset, indicator); // pull necessary data from JSON and fill primeIndObj

	//This is Where GET requests are issued to the server for JSON with fips, county name/state, plus primeInd.name, secondInd.name, thirdInd.name, and fourthInd.name; redefine "data" variable as this JSON
	//"data" should be structured as a JSON with an array of each county.  each county has properties "id"(fips), "geography"(county name, ST), and each of the indicators specified above and clicked and doubleclicked data
	//
	d3.tsv("CData.tsv", function(error, countyData) {
		data = countyData;
		var dataType = primeIndObj.dataType;
		var isNumeric = (dataType === 'level' || dataType === 'level_np' || dataType === 'percent');

		countyData.forEach(function(d) {
			quantById[d.id] =  isNumeric ? parseFloat(d[dataset+' - '+indicator]) : d[dataset+' - '+indicator];					
			secondQuantById[d.id] =  isNumeric ? parseFloat(d[secondIndObj.dataset+' - '+secondIndObj.name]) : d[secondIndObj.dataset+' - '+secondIndObj.name];		
			thirdQuantById[d.id] =  isNumeric ? parseFloat(d[thirdIndObj.dataset+' - '+thirdIndObj.name]) : d[thirdIndObj.dataset+' - '+thirdIndObj.name];		
			fourthQuantById[d.id] =  isNumeric ? parseFloat(d[fourthIndObj.dataset+' - '+fourthIndObj.name]) : d[fourthIndObj.dataset+' - '+fourthIndObj.name];		

			nameById[d.id] = d.geography;
			idByName[d.geography] = d.id;
			countyObjectById[d.id] = d;
		});
		
		if (!isNumeric) {
			// translating string values to numeric values
			var numCorrVals = 0, vals = {}, corrVal = 0;
			for (var ind in quantById) {
				if (!vals.hasOwnProperty(quantById[ind])) {
					vals[quantById[ind]] = corrVal;
					corrVal++;
				}
				quantById[ind] = vals[quantById[ind]];
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
		color.domain(quantById).range(range); // set domain and range

		// fill in map colors
		g.selectAll(".counties .county").transition().duration(750).style("fill", function(d) {
			if (!isNaN(quantById[d.id])) {
				return isNumeric ? color(quantById[d.id]) : range[quantById[d.id]];
			} else {
				return "rgb(155,155,155)";
			}
		});

		isNumeric ? createLegend() : createLegend(vals);
	});
}


var primeIndObj = {}, secondIndObj = {}, thirdIndObj = {}, fourthIndObj = {};

function allData(dataset, indicator){
	
	primeIndObj = getData(dataset, indicator);
	//grab companion indcators through same function
	secondIndObj = getData(primeIndObj.companions[0][0], primeIndObj.companions[0][1]);
	thirdIndObj = getData(primeIndObj.companions[1][0], primeIndObj.companions[1][1]);
	fourthIndObj = getData(primeIndObj.companions[2][0], primeIndObj.companions[2][1]);
	
	if(secondIndObj.name==primeIndObj.name){
		secondIndObj = getData(primeIndObj.companions[3][0], primeIndObj.companions[3][1]);
	}
	else if(thirdIndObj.name==primeIndObj.name){
		thirdIndObj = getData(primeIndObj.companions[3][0], primeIndObj.companions[3][1]);
	}
	else if(fourthIndObj.name==primeIndObj.name){
		fourthIndObj = getData(primeIndObj.companions[3][0], primeIndObj.companions[3][1]);
	}
	
	//temp script for seeing immediately the four indicators name's listed at bottom
	d3.select("#resultWindow").select("p").remove();
	d3.select("#resultWindow").append("p").text(primeIndObj.name + ", " + secondIndObj.name + ", " + thirdIndObj.name + ", " + fourthIndObj.name);
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
			title : "legend",
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

function clicked(mouse, l, t, d, i) {
    tooltip
     	.classed("hidden", false)
      	.style("left", (mouse[0]+l) + "px")
      	.style("top", +(mouse[1]+t) +"px");
    
    $('#tipContainer').empty();
    tipContainer.append('div')
    	.attr('id', 'tipLocation')
    	.text(countyObjectById[d.id].geography);

	var obj = [secondIndObj, thirdIndObj, fourthIndObj],
		quant = [secondQuantById, thirdQuantById, fourthQuantById];
		
	// loop through all three companions and display corresponding formatted values	
	for (var i = 0; i < 3; i++) {
		var currencyText = "";
		if (obj[i].hasOwnProperty('unit') && obj[i].unit.indexOf("dollar") != -1) currencyText = "$"; // determine if indicator values are currency by checking units
		tipContainer.append('div')
			.attr('class', 'tipKey')
			.text(obj[i].name + ': ' + currencyText + format[obj[i].dataType](quant[i][d.id]));
	}	
}

function doubleClicked(d) {
	tooltip.classed("hidden", true);
	var countyID = d.id.toString();
	if (countyID.length == 4) countyID = "0" + countyID;
	
	/*
	displayResultsInFrame('http://www.uscounties.org/cffiles_web/counties/county.cfm?id=' + encodeURIComponent(countyID));
	d3.select('#showOnMap').on('click', function() {
	  	$('#instructions').hide();
	  	//clicked(countyPathById[d.id].geometry.coordinates[0][0], tooltipOffsetL, tooltipOffsetT, d); // a fake click to get tooltip to appear
  	});
	*/
}

function redraw() {
  tooltip.classed("hidden", true);
  
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
	
	//unsure what the first below function does?
  zoom.translate(t);
  g.style("stroke-width", 1 / s).attr("transform", "translate(" + t + ")scale(" + s + ")");

}

var throttleTimer;
function throttle() {
  window.clearTimeout(throttleTimer);
    throttleTimer = window.setTimeout(function() {
      redraw();
    }, 200);
}

setup(width,height);