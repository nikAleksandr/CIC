window.addEventListener('resize', function(event){
	width = parseInt(d3.select(".container").style("width")),
	height = width/1.92,
	totWidth = parseInt(d3.select('body').style('width'));
	svg.remove();
	mapMaker();
});

var selectedCat = "gasTaxRate",
	width = parseInt(d3.select('.container').style('width')),
	height = width/1.92,
	xDomain = {},
	data,
	myPos,
	myX,
	myY,
	totWidth = parseInt(d3.select('body').style('width')),
	extraNote = d3.select("#underMap").append("div"),
	source = d3.select("#dataSource").append("div").attr("id", "source"),
	projection,
	path,
	svg,
	g;

chooseCat(selectedCat);

var quantByState = {};
var nameByState = {};
var linkByState = {};
  
var legendExists = false;

var color = d3.scale.threshold()
	.domain(domain)
	.range(range);

var tooltip = d3.select("#map").append("div").attr("id", "tt").style("z-index", "10").style("position", "absolute").style("visibility", "hidden");

var legend;   

legendMaker(domain, range, units, legendTitleText, notes, sourceText);
//Make a key:value pair for Domain and Range in order to automatically generate the legend
function legendMaker(domain, range, units, legendTitleText, notes, sourceText){
	if(legendExists){
		legend.remove();
	}
	
	
	
	legend = d3.select("#map").append("div")
		.attr("id", "legend");

	xDomain = {};
		for(var i=0; i< domain.length; i++){
			var DText = parseFloat(domain[i-1]+.9) + "-" + parseFloat(domain[i]-.1) + units;
				if(i==0){
					DText = "≤ " + parseFloat(domain[i]-.1) + units;
					if(units=="%"){
						DText = "0%";
					}
				}
				if(i==1){
					if(units=="%"){
						DText = ".01-" + parseFloat(domain[i]-.1) + units;
					}
				}
				if(i==4 && units=="%"){
						DText = "> 71" + units;
				}
				
			if(units=="/gal."){
				var DText = "$" + parseFloat((domain[i-1]+1)/100).toFixed(2) + "-" + parseFloat(domain[i]/100).toFixed(2) + units;
					if(i==0){
						DText = "≤ " + "$" + parseFloat(domain[i]/100).toFixed(2) + units;
					}
			}
			var RColor = range[i];
				//we don't have this key yet, so make a new one
				xDomain[DText] = RColor;
		}
		
	if(units=="binary"){
		xDomain = {
			"No": 'rgb(201, 228, 242)',
			"Yes": 'rgb(255, 166, 1)',
		};
	}  
	if(units=="categorical"){
		xDomain = {
			"Both property tax rate and assessment limit": 'rgb(10,132,193)',
			"Only assessment limit": 'rgb(201,228,242)', 
			"Only property tax rate limit": 'rgb(255,166,1)', 
			"Neither property tax rate nor assessment limit": 'rgb(96,175,215)',
			"Counties do not have authority to levy property taxes on their own": 'rgb(255,204,102)',
		};
	}
	if(units=="gasType"){
		xDomain = {
			"Fixed rate": 'rgb(255,166,1)',
			"Variable rate": 'rgb(255,204,102)',
			"Fixed and variable rate": 'rgb(10,132,193)', 
		};
	}
	if(units=="localGasTax"){
		xDomain = {
			"Not authorized": 'rgb(255,166,1)',
			"Authorized but not adopted": 'rgb(96,175,215)',
			"Adopted": 'rgb(10,132,193)', 
		};
	}
	
	var legendTitle = legend.append("div").attr("id", "legendTitle");
		legendTitle.append("strong").text(legendTitleText);
		
	legend.selectAll("legendoption").data(d3.values(xDomain)).enter().append("legendoption")
		    	.attr("class", "legendOption")
		    	.append("i").style("background-color", function(d){ return d; });
	d3.selectAll("legendoption")
		.append("p").data(d3.keys(xDomain)).text(function(d){ return d; });
	
	extraNote.remove();
	extraNote = d3.select("#underMap").append("div");
		extraNote.append("p").text(notes);
		
	source.remove();
	source = d3.select("#dataSource").append("div").attr("id", "source");
		source.html(sourceText);
	
	legendExists = true;
}
mapMaker();
function mapMaker(){
	
	projection = d3.geo.albersUsa()
	    .scale(width*1.1)
	    .translate([width / 2, height / 2]);
	
	path = d3.geo.path()
	    .projection(projection);
	
	svg = d3.select("#map").append("svg")
	    .attr("width", width)
	    .attr("height", height);
	
	svg.append("rect")
	    .attr("class", "background")
	    .attr("width", width)
	    .attr("height", height);
	    //.on("click", clicked);
	
	g = svg.append("g");
	
	
	d3.csv("data/transData.csv", function (error, transData) {
		data = transData;
	
	  transData.forEach(function(d) { 
	  	quantByState[d.id] = +d.gasTaxRate; 
	  	nameByState[d.id] = d.stateName;
	  	linkByState[d.id] = d.stateAbbrev;
	  });
	  
	
		d3.json("us.json", function(error, us) {
		  g.append("g")
		      .attr("class", "states")
		    .selectAll("path")
		      .data(topojson.feature(us, us.objects.states).features)
		    .enter().append("path")
		      .attr("d", path)
		      .style("fill", function(d) { if(!isNaN(quantByState[d.id])){return color(quantByState[d.id]);} else{return "#ccc";} })
		      .on("click", clicked)
		      .on("mouseover", function (d) {
			        return toolOver(d, this);
		    }).on("mouseout", function (d) {
		        return toolOut(d, this);
		    }).on("mousemove", function (d, i) {
		        var filtered;
		        for (var i = 0; i < data.length; i++) {
		            if (data[i].id == d.id) {
		                filtered = data[i];
		                break;
		            }
		        }
		        myPos = d3.mouse(this);
		        myX = myPos[0];    
		        myY = myPos[1];
		        
		        //var coords = getScreenCoords(myX, myY, this.getCTM());
				var a = (isNaN(data[i].gasTaxRate) ? "N/A" : data[i].gasTaxRate);
				var b = (isNaN(+data[i].yrsSinceInc) ? "N/A" : +data[i].yrsSinceInc);
				var c = (isNaN(+data[i].pctBridges) ? "N/A" : +data[i].pctBridges);
				var d = (isNaN(+data[i].pctRoads) ? "N/A" : +data[i].pctRoads);
		
		        //myX = coords.x;
		        //myY = coords.y;
		        return toolMove(data[i].stateName, a, b, c, d);
		    });
		      /*.append("svg:title")
		      	.text(function(d) {return nameByState[d.id]; });
		      */
		     
		  g.append("path")
		      .datum(topojson.mesh(us, us.objects.states, function(a, b) { return a !== b; }))
		      .attr("id", "state-borders")
		      .attr("d", path);
		});
		
		extraNote.remove();
		extraNote = d3.select("#underMap").append("div");
			extraNote.append("p").text(notes);
			
		source.remove();
		source = d3.select("#dataSource").append("div").attr("id", "source");
			source.html(sourceText);
			
		update(selectedCat);
	});
};
function chooseCat(value){
	//set up a switch that sets domain, range, and other cross-data variables based on their button selection
	switch (value){
		case "gasTaxRate": 
			domain = [5, 15, 25, 35, 45 ];
			range = ['rgb(201,228,242)', 'rgb(96,175,215)', 'rgb(10,132,193)', 'rgb(255,166,1)', 'rgb(255,204,102)', 'rgb(155,155,155)'];
			//research colors(dark-yellow to dark-blue): 'rgb(255,166,1)', 'rgb(255,204,102)', 'rgb(201,228,242)', 'rgb(96,175,215)', 'rgb(10,132,193)', 'rgb(155,155,155)'
			//research colors(light-blue to light-yellow): 'rgb(201,228,242)', 'rgb(96,175,215)', 'rgb(10,132,193)', 'rgb(255,166,1)', 'rgb(255,204,102)', 'rgb(155,155,155)'
			//research colors(light-yellow to light-blue):
			//research colors(dark-blue to dark-yellow): 'rgb(10,132,193)', 'rgb(96,175,215)', 'rgb(201,228,242)', 'rgb(255,204,102)', 'rgb(255,166,1)', 'rgb(155,155,155)'
			//research blues: 'rgb(201,228,242)', 'rgb(150,205,233)', 'rgb(96,175,215)', 'rgb(48,146,195)', 'rgb(10,132,193)', 'rgb(155,155,155)'
			units = "/gal.";
			legendTitleText = "State Excise Tax on Gasoline, as of January 2014";
			notes = "*State gas tax rate does not include the 18.4 cents per gallon federal gas tax.";
			sourceText = "<em>Source: American Petroleum Institute, 2014</em>";
			break;
		case "yrsSinceInc":
			domain = [1.1, 10.1, 20.1, 30.1, 45.1];
			range = ['rgb(201,228,242)', 'rgb(96,175,215)', 'rgb(10,132,193)', 'rgb(255,166,1)', 'rgb(255,204,102)', 'rgb(155,155,155)'];
			units = " years";
			legendTitleText = "Number of Years Since the Last Increase of the State Gas Tax, as of February 2014";
			notes = "*NACo recalculated the number of years since the last increase of the state gas tax based on the current year 2014 and updated some of the years of the last increase of the state gas tax from the National Governors Association (NGA), How States and Territories Fund Transportation, 2009.";
			sourceText = "<em>Sources: NACo update of data from National Governors Association (NGA), How States and Territories Fund Transportation, 2009.</em>";
			break;
		case "localGasTax":
			domain = [1, 2, 3];
			range = ['rgb(255, 166, 1)', 'rgb(96,175,215)', 'rgb(10,132,193)', 'rgb(155,155,155)'];
			units = "localGasTax";
			legendTitleText = "States Allowing Counties to Collect Local Option Gas Taxes, as of February 2014";
			notes = "";
			sourceText = "<em>Sources: NACo Analysis of Goldman and Wachs, 2003; American Petroleum Institute (API), State Motor Fuel Taxes, October 2013; Goldman, Todd; Corbett, Sam; Wachs, Martin. Institute of Transportation Studies University of Berkeley. Local Option Transportation Taxes in the United States, Part One: Issues and Trends. March 2001.</em>";
			break;
		case "pctBridges":
			domain = [.01, 30.1, 50.1, 70.1, 100.1];
			range = ['rgb(201,228,242)', 'rgb(96,175,215)', 'rgb(10,132,193)', 'rgb(255,204,102)', 'rgb(255,166,1)', 'rgb(155,155,155)'];
			units = "%";
			legendTitleText = "County Owned Bridges, Share of Statewide Bridges, 2012";
			notes = "";
			sourceText = "<em>Source: NACo analysis of U.S. DOT, FHWA, National Bridge Inventory data, 2012</em>";
			break;
		case "pctBridgesDef":
			domain = [.01, 30.1, 50.1, 70.1, 100.1];
			range = ['rgb(201,228,242)', 'rgb(96,175,215)', 'rgb(10,132,193)', 'rgb(255,204,102)', 'rgb(255,166,1)', 'rgb(155,155,155)'];
			units = "%";
			legendTitleText = "Share of County Structurally Deficient Bridges of all Structurally Deficient Bridges in the State, 2012";
			notes = "";
			sourceText = "<em>Source: NACo analysis of U.S. DOT, FHWA, National Bridge Inventory data, 2012</em>";
			break;
		case "pctRoads":
			domain = [.01, 30.1, 50.1, 70.1, 100.1];
			range = ['rgb(201,228,242)', 'rgb(96,175,215)', 'rgb(10,132,193)', 'rgb(255,204,102)', 'rgb(255,166,1)', 'rgb(155,155,155)'];
			units = "%";
			legendTitleText = "County Owned Roads, Share of Statewide Public Roads, 2011";
			notes = "";
			sourceText = "<em>Source: NACo analysis of U.S. Department of Transportation (DOT), FHWA, Highway Performance Monitoring System data, 2011</em>";
			break;
		case "gasTaxType": 
			domain = [2, 3, 4];
			range = ['rgb(255,166,1)', 'rgb(255,204,102)', 'rgb(10,132,193)',  'rgb(155, 155, 155)'];
			units = "gasType";
			legendTitleText = "State Gas Tax Rates (Fixed or Variable), as of February 2014";
			notes = "";
			sourceText = "<em>Source: NACo analysis and update of Institute for Taxation and Economic Policy (ITEP), 2011</em>";
			break;
		case "localSalesTax": 
			domain = [1, 2, 3];
			range = [ 'rgb(255, 166, 1)', 'rgb(96,175,215)', 'rgb(10,132,193)', 'rgb(155,155,155)'];
			units = "localGasTax";
			legendTitleText = "County Local Option Sales Taxes for Transportation, as of February 2014";
			notes = "";
			sourceText = "<em>Sources: NACo analysis of Goldman, Corbett and Wachs, 2001</em>";
			break;
		case "propTaxLimits": 
			domain = [1, 2, 3, 4, 5];
			range = ['rgb(255,204,102)',  'rgb(96,175,215)', 'rgb(255,166,1)', 'rgb(201,228,242)', 'rgb(10,132,193)', 'rgb(155, 155, 155)'];
			units = "categorical";
			legendTitleText = "State Imposed Limitations on County Property Tax Rates and Property Assessment, as of February 2014";
			notes = "*Maine and Vermont do not give counties the authority to levy any taxes, but counties may request an assessment from the state government based on estimates of the costs of county services. In New Hampshire, a county delegation composed of state representatives is responsible for levying taxes.";
			sourceText = "<em>Sources: NACo update of National Conference of State Legislatures, A Guide to Property Taxes: Property Tax Relief, 2009.</em>";
			break;			
	}
}

function update(value){
	
	chooseCat(value);
		legendMaker(domain, range, units, legendTitleText, notes, sourceText);
	
	data.forEach(function(d){
		quantByState[d.id] = d[value]; 
  		nameByState[d.id] = d.stateName;
	});
	
	color
		.domain(domain)
		.range(range);
	
	g.selectAll(".states path")
	  .transition()
      .duration(750)
	  .style("fill", function(d) { if(!isNaN(quantByState[d.id])){return color(quantByState[d.id]);} else{return "rgb(155,155,155)";} });

	
}

$("#select button").click(function() {
	$("#select button").removeClass("active");
	//$(this).addClass("btn active");
	selectedCat = this.value;
	update(this.value);
});

//

function clicked(d){
	console.log(linkByState[d.id]);
	if(linkByState[d.id]=="RI" | linkByState[d.id]=="CT" | linkByState[d.id]=="DE" | linkByState[d.id]=="NC" | linkByState[d.id]=="DE" | linkByState[d.id]=="VT" |linkByState[d.id]=="WV" |linkByState[d.id]=="NH"){
		return tooltip.style("top", myY+50 + "px").style("left", myX +((totWidth-width)/2) + "px").html("<div id='tipContainer'><div id='tipLocation'><b>" + "No Profile" + "</b></div><div id='tipKey'></b><p>The interactive provides individualized PDF profiles for 43 states where counties have authority over roads and/or bridges. Counties in four states (Delaware, North Carolina, Vermont and West Virginia) do not have authority over both roads and bridges. New Hampshire counties do not own roads and only one county (Belknap County) owns a bridge.</p></div></div>");
	}
	else{
		window.open('profiles/state_summary_' + linkByState[d.id] + '.pdf', '_blank');
	}
}
function toolOver(v, thepath) {
	d3.select(thepath).style({
		"fill-opacity": "0.1",
		"cursor": "pointer"
	});
	return tooltip.style("visibility", "visible");
};

function toolOut(m, thepath) {
	d3.select(thepath).style({
		"fill-opacity": "1"
	});
	return tooltip.style("visibility", "hidden");
};


function toolMove(state, gasTaxRate, yrsSinceInc, pctBridges, pctRoads) {
		
		gasTaxRate = ((gasTaxRate==101) ? "N/A" : "$" + (Math.round(gasTaxRate)/100).toFixed(2));
		yrsSinceInc = ((yrsSinceInc==101) ? "N/A" : (2014-yearInc(yrsSinceInc)));
		pctBridges = ((pctBridges==101) ? "N/A" : Math.round(pctBridges*10)/10 + "%");
		pctRoads = ((pctRoads==101) ? "N/A" : Math.round(pctRoads*10)/10 + "%");
	
 
	if (myX < 50) {
		myX = 50;
	};
	
	if (myY < 50) {
		myY = 50;
	};
	
	/*function permitted(localGasTax){
		if(localGasTax==1){
			return "Permitted";
		}
		else{
			return "Not Permitted";
		}
	};
	*/
	function yearInc(yrsSinceInc){
		if(yrsSinceInc==0){
			return 1;
		}
		else{
			return yrsSinceInc;
		}
	}
	return tooltip.style("top", myY + "px").style("left", myX+20+((totWidth-width)/2) + "px").html("<div id='tipContainer'><div id='tipLocation'><b>" + state + "</b></div><div id='tipKey'></b>County-owned bridges, share of public bridges statewide: <b>" + pctBridges + "</b><br>County-owned roads, share of public roads statewide: <b>" + pctRoads + "</b>" + "<br/>State gas tax rate ($/gallon): <b>" + gasTaxRate + "</b><br>Year of last state gas tax increase: <b>" + yrsSinceInc  + "</div><div class='tipClear'></div> </div>");
};

function getScreenCoords(x, y, ctm) {
  var xn = ctm.e + x*ctm.a;
  var yn = ctm.f + y*ctm.d;
  return { x: xn, y: yn };
}

