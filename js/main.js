d3.select(window).on("resize", throttle);

function toTitleCase(str){
    return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
}
var percentFmt = d3.format(".1%");
var stateAbbrev = ['AK', 'AL', 'AR', 'AZ', 'CA', 'CO', 'CT', 'DC', 'DE', 'FL', 'GA', 'HI', 'IA', 'ID', 'IL', 'IN', 'KS', 'KY', 'LA', 'MA', 'MD', 'ME', 'MI', 'MN', 'MO', 'MS', 'MT', 'NC', 'ND', 'NE', 'NH', 'NJ', 'NM', 'NV', 'NY', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VA', 'VT', 'WA', 'WI', 'WV', 'WY'];

var zoom = d3.behavior.zoom()
    .scaleExtent([1, 10])
    .on("zoom", move);

var width = document.getElementById('container').offsetWidth-60;
var height = width / 2;

var projection = d3.geo.albersUsa()
    .scale(width )
    .translate([width / 2, height / 2]);

var path = d3.geo.path()
	.projection(projection);

var topo,stateMesh,projection,path,svg,g;

var tooltip = d3.select("#container").append("div").attr("class", "tooltip hidden").attr("id", "tt");

var selectedData,
	selectedDataText = "GDP Growth, 2013",
	primeInd = {},
	dataYear,
	data,
	legend,
	selected,
	clickCount = 0;
	
var quantById = []; 
var nameById = [];
var idByName = {};
var countyPathById = {};

var quantOneThird,
	quantTwoThird,
	range = ['rgb(239,243,255)','rgb(189,215,231)','rgb(107,174,214)','rgb(49,130,189)','rgb(8,81,156)'];
	
var color = d3.scale.quantile();

d3.tsv("CountyData.tsv", function (error, countyData) {
	data = countyData;
	
	countyData.forEach(function(d) { 
	  	quantById[d.id] = +d.RGDPGrowth13; 
	  	nameById[d.id] = d.geography;
	  	idByName[d.geography] = d.id;	
	  	countyPathById[d.id] = d;  	
	});
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
  		
		
  buildDropdown();
  buildSearch();
}
	

d3.json("us.json", function(error, us) {

  var counties = topojson.feature(us, us.objects.counties).features;
  var states = topojson.mesh(us, us.objects.states, function(a, b) { return a !== b; });

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
      .style("fill", function(d) { if(!isNaN(quantById[d.id])){return color(quantById[d.id]);} else{return "#ccc";} });

  g.append("path")
		      .datum(stateMesh)
		      .attr("id", "state-borders")
		      .attr("d", path);
  
  
  //offsets plus width/height of transform, plus 20 px of padding, plus 20 extra for tooltip offset off mouse
  var offsetL = document.getElementById('container').offsetLeft+(width/2)+40;
  var offsetT = document.getElementById('container').offsetTop+(height/2)+20;

  //tooltips
  county
    .on('click', function(d, i) {
    	var mouse = d3.mouse(svg.node()).map( function(d) { return parseInt(d); } );
		
		highlight(d);
		
		clickCount++;
		if (clickCount === 1) {
			singleClickTimer = setTimeout(function() {
				clickCount = 0;
				clicked(mouse, offsetL, offsetT, d, i);
			}, 400);
		} else if (clickCount === 2) {
			clearTimeout(singleClickTimer);
			clickCount = 0;
			doubleClicked(d, i);
		}
	}, false);
    
    
    // dataset to map first
	selectedData = "PILT Amount";
	selectedDataset = "Payment in Lieu of Taxes (PILT)";
  	getData(selectedData, selectedDataset);
   
}

function buildDropdown() {
	// populate dropdown menu with categories pulled from json
	d3.json("data/CICstructure.json", function(error, CICStructure){
		if (!error) {
			// empty out dropdown
			d3.select('#primeInd')
				.selectAll('li')
					.remove();
			
			var s = CICStructure.children;
			var createCategory = function(catName) {
				/*var primeDrop = d3.select('#primeInd');
				primeDrop.append('a').text(catName);
				var cat = primeDrop.append('li');*/
				var cat = d3.select('#primeInd').append('li').append('a')
					.attr('name', catName)
					.attr('title', catName)
					.attr('href', '#')
					.style('text-align', 'left')
					.text(catName)
					.on('click', function(d) {
						tooltip.classed("hidden", true);				
						selectedData = catName;
						selectedDataset = catName;
						selectedDataText = catName;
						d3.select('#primeIndText').html(selectedDataText);
						
						getData(selectedData, selectedDataset);
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
	});
}

function buildSearch() {
	var searchForm = d3.select('#searchContainer').append('form')
		.attr('id', 'search_form')
		.on('submit', submitSearch);
	var searchField = searchForm.append("input")
		.attr('type', 'search')
		.attr('id', 'search_field')
		.attr('placeholder', 'city or county')
		.on('keyup', function() {
			if (d3.event.keyCode === 13) {
				d3.event.preventDefault();
				submitSearch();
			}
		});
	
	var stateDropdown = searchForm.append('select')
		.attr('id', 'state_drop');
	stateDropdown.append('option')
		.text('State')
		.attr('value', '');
	for (var i = 0; i < stateAbbrev.length; i++) {
		stateDropdown.append('option')
			.text(stateAbbrev[i])
			.attr('value', stateAbbrev[i]);
	}
	
	var submitButton = searchForm.append('input')
		.attr('type', 'button')
		.attr('id', 'search_submit')
		.attr('value', 'Search')
		.on('click', submitSearch);
}

function submitSearch() {
	var search_str = document.getElementById('search_field').value;
	var state_name = document.getElementById('state_drop').value;
	var results_container = d3.select('#container');

	if (search_str === '' && state_name !== '') {
		// only state; return results of all counties within state
		displayResultsInFrame('http://www.uscounties.org/cffiles_web/counties/state.cfm?statecode='+encodeURIComponent(state_name));
							
	} else if (search_str !== '') {
		// city/county and state OR city/county
		
		// first, determine whether searching a city or a county
		// if it has the word "city" and is not among the county names with the word "city": treat as city. otherwise assume county search
		var county_search = true;
		var counties_with_word_city = ['Juneau', 'Sitka', 'Wrangell', 'Yakutat', 'San Francisco', 'Broomfield', 'Denver', 'Jacksonville', 'Honolulu', 'Kansas', 'Baltimore', 'Boston', 'St. Louis', 'St Louis', 'Carson', 'New York', 'Charles', 'James']; 
		if (search_str.toLowerCase().indexOf('city') != -1) {
			for (var i = 0; i < counties_with_word_city.length; i++) {
				var cwwc = counties_with_word_city[i].toLowerCase();
				var cwwc_match = false;
				if (search_str.toLowerCase().indexOf(cwwc) != -1) {
					cwwc_match = true;
					break;
				}
			}
			if (cwwc_match === true) county_search = false;
		}
		
		if (county_search === true) {
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
			}
			console.log(pMatchArray);
			
			if (pMatchArray.length > 1) {
				// display all matches, if more than one match
				$('#resultWindow').empty();
				var rTable = d3.select('#resultWindow').append('table')
					.classed('search_results_table', true);
				var rTitleRow = rTable.append('tr').style('font-weight', 'bold');
				var rTitleFIPS = rTitleRow.append('td').text('FIPS');
				var rTitleCounty = rTitleRow.append('td').text('County Name');
				var rTitleState = rTitleRow.append('td').text('State');
					
				for (var i = 0; i < pMatchArray.length; i++) {
					var countyObj = countyPathById[pMatchArray[i]];
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
				
				// styling; in anon function for closure in click function
				rTable.selectAll('tr').selectAll('td')
					.classed('search_results_cell', true);	
				
				
			} else if (pMatchArray.length == 1) {
				// if only one match, display county
				executeSearchMatch(pMatchArray[0]);
			} else {
				alert('search not matched :(');
			}

		} else {
			// city search: use city-county lookup
			console.log('city search');
			
			var search_str_array = search_str.toLowerCase().split('city');
			var city_search_str = '';
			for (var i = 0; i < search_str_array.length; i++) city_search_str += search_str_array[i];
			
			displayResultsInFrame('http://www.uscounties.org/cffiles_web/counties/city_res.cfm?city='+encodeURIComponent(city_search_str.trim()));
		}
	}
}

function executeSearchMatch(FIPS) {
	var county = countyPathById[FIPS];
	
	console.log('MATCH');
	console.log(county);
	
	//highlight(county);
	zoomTo(county);
	doubleClicked(county);
	
	//document.getElementById('search_form').reset();				
};

function displayResultsInFrame(url) {
	tooltip.classed("hidden", true);
	
	$('#resultWindow').empty();
	d3.select('#resultWindow').append('iframe')
		.classed('result_iframe', true)
		.attr('src', url);
		
	/*d3.xhr(url, function(error, searchResults){
		d3.select("#resultWindow").html(searchResults.responseText);
	});*/
}

function zoomTo(d) {
	// doesnt work
	zoom.center(path.centroid(d));
}

var frmrFill, frmrActive;

function highlight(d) {
	if (d && selected !== d) {
	    selected = d;
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


function update(primeInd, primeIndYear){
	//Will first break the JSON object into component parts here:
	var primeIndText = primeInd.name;
	var primeIndUnits = primeInd.unit;
	var dataType = primeInd.dataType;
	
	//will need to redefine "data" variable to be our returned data from the GET call	
	data.forEach(function(d){
		quantById[d.id] = +d[primeIndText]; 
  		//nameById[d.id] = d.geography;
	});
	
	
	var legendTitle = "";
	switch(dataType){
		case "percent":
			primeIndUnits = "percent";
			range = ['rgb(239,243,255)','rgb(189,215,231)','rgb(107,174,214)','rgb(49,130,189)','rgb(8,81,156)'];
			legendTitle = primeIndYear + " " + primeIndText + " in " + primeIndUnits;
			break;
		/*case "divergent":
			range = ['rgb(215,25,28)','rgb(253,174,97)','rgb(255,255,191)','rgb(171,217,233)','rgb(44,123,182)'];
			//get the center-point from somewhere
			break;
		*/
		case "binary":
			range = ['rgb(201,228,242)', 'rgb(255,204,102)'];
			legendTitle = primeIndYear + " " + primeIndText;
			break;
		case "categorical":
			// max is 5 categories
			range = ['rgb(228,26,28)','rgb(55,126,184)','rgb(77,175,74)','rgb(152,78,163)','rgb(255,127,0)'];
			legendTitle = primeIndYear + " " + primeIndText;
			break;
		default:
			//continous, so we don't have to have this property in the JSON
			range = ['rgb(239,243,255)','rgb(189,215,231)','rgb(107,174,214)','rgb(49,130,189)','rgb(8,81,156)'];
			legendTitle = primeIndYear + " " + primeIndText + " in " + primeIndUnits;
	}
	
	// determine if indicator values are currency by checking units
	var isCurrency = (primeIndUnits) ? (primeIndUnits.indexOf("dollar") != -1) : false;
	
	// pack data in color array
	color
		.domain(quantById)
		.range(range);
	d3.selectAll(".legend svg").remove();  d3.select("#legendTitle").remove();
	
	if (dataType !== 'none') { 
		// create legend
		d3.select(".legend").append("div").attr("id", "legendTitle").text(legendTitle);
		legend = colorlegend("#quantileLegend", color, "quantile", {
			title: "legend", 
			boxHeight: 15, 
			boxWidth: 60, 
			dataType: dataType,
			isCurrency: isCurrency
		});
	}
	
	
	g.selectAll(".counties .county").transition().duration(750).style("fill", function(d) {
		if (!isNaN(quantById[d.id])) {
			return color(quantById[d.id]);
		} else {
			return "rgb(155,155,155)";
		}
	});

}


var structure, extraInd = [], extraIndYears = [];

//Alternative to this big lookup is to list a i,j,h "JSON address" in the HTML anchor properties.  Would still likely require some type of HTML or JSON lookup for companion indicators though
function getData(indName, datasetName){
	
	// replace with .get() function call
	d3.json("data/CICstructure.json", function(error, CICStructure){
		if (!error) {
			var Jcategory, primeInd;
			structure = CICStructure.children;
			for (var i = 0; i < structure.length; i++) {
				for (var j = 0; j < structure[i].children.length; j++) {
					if (structure[i].children[j].name == datasetName) {
						Jcategory = structure[i];
						var Jdataset = structure[i].children[j];
						primeIndYear = d3.max(Jdataset.years);
						//will also want vintage, source, companions, and dataNotes properties from here
						vintage = Jdataset.vintage;
						sourceText = Jdataset.source;
						companions = Jdataset.companions;
						dataNotes = Jdataset.notes;
						for (var h = 0; h < Jdataset.children.length; h++) {
							if (indName == Jdataset.children[h].name) {
								//primeInd is a JSON object from CIC-structure with the properties: name, units, dataType
								primeInd = Jdataset.children[h];
								break;
							}
						}
						break;
					}
				}
			}
						
			//getCompanionData(Jdataset);
			
			//temporary switch to override this function while using tsv data
			switch(indName){
				case "Administration":
					primeInd = { 
						'name': "RGDPGrowth13",
						'dataType': "percent"
					};
					primeIndYear = '2013';
					break;
				case "County Structure":
					primeInd = { 
						'name': "countyGov",
						'dataType': "binary"
					};
					primeIndYear = '2014';
					break;
				case "County Finance":
					primeInd = { 
						'name': "avgWageFAKE",
						'dataType': "level",
						'unit': "dollars"
					};
					primeIndYear = '1910';
					break;
				default:
					primeInd = {
						"name": "HHpriceGrowth13",
						"dataType": "percent"
					};
					primeIndYear = '2013';
					break;
			};
			//
			///
			//This is Where GET requests are issued to the server for JSON with fips, county name/state, plus primeIndText, extraInd1Text, extraInd2Text, and extraInd3Text; redefine "data" variable as this JSON
			//"data" should be structured as a JSON with an array of each county.  each county has properties "id"(fips), "geography"(county name, ST), and each of the indicators specified above and clicked and doubleclicked data
			//
			//Will move update(selectedData) down here and replace with update(primeInd, primeIndYear)
			update(primeInd, primeIndYear);
		} else {
			// notify user of error in some way
			console.log(error);
		}
	});	
}
//comnpanion data always has to be run AFTER getData
function getCompanionData(Jcategory){
	for (k = 0; k < companions.length; k++) {
		for (i = 0; i < Jcategory.children.length; i++) {
			for (j = 0; j < Jcategory.children[i].children.length; j++) {
				if (companions[k] == Jcategory.children[i].children[j].name) {
					extraInd[k] = Jcategory.children[i].children[j];
					//extraInd is an array of JSON objects from CIC-structure with the properties: name, units
					extraIndYears[k] = d3.max(Jcategory.children[i].years);
				}
			}
		}
	}
	extraInd1Text = extraInd[0].name;
	extraInd1Units = extraInd[0].unit;
	extraInd1Year = extraIndYears[0];
	extraInd2Text = extraInd[1].name;
	extraInd2Units = extraInd[2].unit;
	extraInd2Year = extraIndYears[1];
	extraInd3Text = extraInd[2].name;
	extraInd3Units = extraInd[2].unit;
	extraInd3Year = extraIndYears[2];
}

function clicked(mouse, l, t, d, i) {
    tooltip
      .classed("hidden", false)
      .style("left", (mouse[0]+l) + "px")
      .style("top", +(mouse[1]+t) +"px");
  	return tooltip.html("<div id='tipContainer'><div id='tipLocation'><b>" + "FIPS: " + d.id + "</b></div><div id='tipKey'></b>" + primeIndText + ": <b>" + percentFmt(quantById[d.id]) + "</b><br>County-owned roads, share of public roads statewide: <b>" + "VAR" + "</b>" + "<br/>State gas tax rate ($/gallon): <b>" + "VAR" + "</b><br>Year of last state gas tax increase: <b>" + "VAR"  + "</div><div class='tipClear'></div> </div>");
}

function doubleClicked(d) {
	tooltip.classed("hidden", true);
	var countyID = d.id.toString();
	if (countyID.length == 4) countyID = "0" + countyID;
	displayResultsInFrame('http://www.uscounties.org/cffiles_web/counties/county.cfm?id=' + encodeURIComponent(countyID));
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
  var h = height / 3;
  
  t[0] = Math.min(width / 2 * (s - 1), Math.max(width / 2 * (1 - s), t[0]));
  t[1] = Math.min(height / 2 * (s - 1) + h * s, Math.max(height / 2 * (1 - s) - h * s, t[1]));

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