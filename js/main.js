d3.select(window).on("resize", throttle);

var zoom = d3.behavior.zoom()
    .scaleExtent([1, 10])
    .on("zoom", move);

var width = document.getElementById('container').offsetWidth-60;
var height = width / 2;

var topo,stateMesh,projection,path,svg,g;

var tooltip = d3.select("#container").append("div").attr("class", "tooltip hidden");

var selectedData,
	selectedDataText = "GDP Growth, 2013",
	data,
	legend;
	
var quantById = []; 
var nameById = [];

var max,
	min,
	median,
	quantOneThird,
	quantTwoThird,
	range = ['rgb(255,255,204)','rgb(255,237,160)','rgb(254,217,118)','rgb(254,178,76)','rgb(253,141,60)','rgb(252,78,42)','rgb(227,26,28)','rgb(189,0,38)','rgb(128,0,38)'];
	//['rgb(201,228,242)', 'rgb(96,176,215)', 'rgb(10,132,193)']
	
var color = d3.scale.quantile();

d3.tsv("CountyData.tsv", function (error, countyData) {
	data = countyData;
	
	countyData.forEach(function(d) { 
	  	quantById[d.id] = +d.RGDPGrowth13; 
	  	nameById[d.id] = d.geography;
	});
	/*
	max = Math.ceil(d3.max(quantById)*100)/100;
	min = Math.floor(d3.min(quantById)*100)/100;
	median = Math.round(d3.median(quantById)*100)/100;
	*/
	color
		.domain(quantById)
		.range(range);
	
	console.log(color.quantiles());
	
	d3.select(".legend").append("div").attr("id", "legendTitle").text(selectedDataText);
	legend = colorlegend("#quantileLegend", color, "quantile", {title: "legend", boxHeight: 15, boxWidth: 30});
});


setup(width,height);

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
  
  
  //ofsets plus width/height of transform, plsu 20 px of padding, plus 20 extra for tooltip offset off mouse
  var offsetL = document.getElementById('container').offsetLeft+(width/2)+40;
  var offsetT =document.getElementById('container').offsetTop+(height/2)+20;

  //tooltips
  county
    .on("mousemove", function(d,i) {
      var mouse = d3.mouse(svg.node()).map( function(d) { return parseInt(d); } );
        tooltip
          .classed("hidden", false)
          .attr("style", "left:"+(mouse[0]+offsetL)+"px;top:"+(mouse[1]+offsetT)+"px")
          .html(d.properties.name);
      })
      .on("mouseout",  function(d,i) {
        tooltip.classed("hidden", true);
      }); 
      

   
}

function update(value){
	
	//chooseCat(value);
	//	legendMaker(domain, range, units, legendTitleText, notes, sourceText);
	
	data.forEach(function(d){
		quantById[d.id] = +d[value]; 
  		nameById[d.id] = d.geography;
	});
	
	
	color
		.domain(quantById)
		.range(range);
	
	g.selectAll(".counties .county")
	  .transition()
      .duration(750)
	  .style("fill", function(d) { if(!isNaN(quantById[d.id])){return color(quantById[d.id]);} else{return "rgb(155,155,155)";} });

	d3.selectAll(".legend svg").remove();
	d3.select("#legendTitle").remove();
	d3.select(".legend").append("div").attr("id", "legendTitle").text(selectedDataText);
	legend = colorlegend("#quantileLegend", color, "quantile", {title: "legend", boxHeight: 15, boxWidth: 40});
}


$("#primeInd li a").click(function() {
	//$(".dropdown-menu li").removeClass("active");
	//$(this).addClass("btn active");
	selectedData = this.title;
	selectedDataset = this.name;
	getData(selectedData, selectedDataset);
	selectedDataText = this.innerHTML;
	update(selectedData);
});

var structure;

function getData(indName, datasetName){
	d3.json("data/CICstructure.json", function(error, CICStructure){
		structure = CICStructure.children;
		for(i=0; i<structure.length; i++){
			console.log(indName + " ,-, " + structure[i].name);
			if(structure[i].name==datasetName)
		}
	});
}

function redraw() {
  width = document.getElementById('container').offsetWidth-60;
  height = width / 2;
  d3.select('svg').remove();
  setup(width,height);
  draw(topo, stateMesh);
}

function move() {

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
