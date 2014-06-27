/**
 * @author jgoodall
 */
/*jshint browser:true, indent:2, globalstrict: true, laxcomma: true, laxbreak: true */
/*global d3:true */

/*
* colorlegend
*
* This script can be used to draw a color legend for a
* [d3.js scale](https://github.com/mbostock/d3/wiki/Scales)
* on a specified html div element.
* [d3.js](http://mbostock.github.com/d3/) is required.
*
*/

'use strict';

var colorlegend = function (target, scale, type, options) {

 	var scaleTypes = ['linear', 'quantile', 'ordinal']
    	, found = false
    	, opts = options || {}
    	, dataType = opts.dataType || 'level'
    	, boxWidth = opts.boxWidth || 20 // width of each box (int)
    	, boxHeight = opts.boxHeight || 20 // height of each box (int)
    	, title = opts.title || null // draw title (string)
    	, fill = opts.fill || false // fill the element (boolean)
    	, linearBoxes = opts.linearBoxes || 9 // number of boxes for linear scales (int)
    	, isNumeric = (dataType === 'level' || dataType === 'level_np' || dataType === 'percent')
    	, unitType = opts.unitType || false
    	, htmlElement = document.getElementById(target.substring(0, 1) === '#' ? target.substring(1, target.length) : target) // target container element - strip the prefix #
    	, w = htmlElement.offsetWidth // width of container element
    	, h = htmlElement.offsetHeight // height of container element
    	, colors = []
    	, padding = [0, 4, 10, 0] // top, right, bottom, left
    	, boxSpacing = type === 'ordinal' ? 3 : 0 // spacing between boxes
    	, titlePadding = title ? 22 : 0
    	, boxLabelHeight = 10
    	, domain = scale.domain()
    	, range = scale.range()
    	, quantiles = scale.quantiles()
    	, format = opts.formatFnArr;
    

	// check for valid input - 'quantize' not included
  	for (var i = 0; i < scaleTypes.length; i++) {
   		if (scaleTypes[i] === type) {
			found = true;
			break;
		}
	}
  	if (!found) throw new Error('Scale type, ' + type + ', is not supported.');

  	
  	// setup the colors to use
  	if (type === 'quantile') {
    	colors = range;
  	}
  	else if (type === 'ordinal') {
    	for (var i = 0 ; i < domain.length ; i++) {
      		colors[i] = range[i];
    	}
  	}
  	else if (type === 'linear') {
    	var min = domain[0];
    	var max = domain[domain.length - 1];
    	for (i = 0; i < linearBoxes ; i++) {
      		colors[i] = scale(min + i * ((max - min) / linearBoxes));
    	}
  	}
  
  	// check the width and height and adjust if necessary to fit in the element
  	// use the range if quantile
  	if (fill || w < (boxWidth + boxSpacing) * colors.length + padding[1] + padding[3]) {
	    boxWidth = (w - padding[1] - padding[3] - (boxSpacing * colors.length)) / colors.length;
  	}
  	if (fill || h < boxHeight + padding[0] + padding[2] + titlePadding) {
	    boxHeight = h - padding[0] - padding[2] - titlePadding;
  	}
  
  	// set up the legend graphics context
  	var svg = d3.select(target)
	    .append('svg')
      		.attr('width', w)
      		.attr('height', h);
    var legend = svg.append('g')
      		.attr('class', 'colorlegend')
      		.style('font-size', '.76em')
      		.style('fill', '#666');
 	
 	legend.reposition = function() {
 		svg.attr('width', htmlElement.offsetWidth).attr('height', htmlElement.offsetHeight);
 		legend.attr('transform', 'translate(' + (padding[3] + htmlElement.offsetWidth/2 - boxWidth*colors.length/2) + ',' + padding[0] + ')');
 	};
 	legend.reposition();
  
  	// set up data values to be used for text in legend
  	// if numeric, assume domain is sorted small to large
  	var dataValues = [];
	if (isNumeric) { 
		// for level (not level_np): min is set as 0
		(dataType === 'level') ? dataValues.push(0) : dataValues.push(domain[0]);
		for (var i = 0; i < quantiles.length; i++) dataValues.push(quantiles[i]);
		dataValues.push(domain[domain.length - 1]);
 	} else {
 		// if categorical or binary, find and store all unique data values
		for (var j = 0; j < colors.length; j++) {
			for (var ind in options.keyArray) {
				if (options.keyArray[ind] === j) {
					dataValues.push(ind);
					break;
				}
			}
		}
	}
	
	// for binary, show yes first and no second; override
	if (dataType === 'binary') {
		colors = [binary_colors[1], binary_colors[0]];
		dataValues = ['Yes', 'No'];
	}
    
  	var legendBoxes = legend.selectAll('g.legend')
    	.data(dataValues)
    	.enter().append('g');

  	// the colors, each color is drawn as a rectangle
  	legendBoxes.append('rect')
      	.attr('width', boxWidth)
      	.attr('height', boxHeight)
      	.attr('x', function (d, i) {
	      	return i * (boxWidth + boxSpacing);
      	})
      	.attr('y', boxLabelHeight)
      	.style('fill', function (d, i) { return colors[i]; })
      	.style('display', function (d, i) { if (i >= colors.length) return 'none'; });

    // additional text on top of color boxes, displaying "top 20%", "bottom 20%", etc.
    if (isNumeric && dataType !== 'level') {
	    legendBoxes.append('text')
	    	.attr('class', 'colorlegend-boxlabels')
	    	.attr('x', function (d, i) {
	    		return i * (boxWidth + boxSpacing) + boxWidth/2;
	    	})
	    	.attr('y', boxLabelHeight + 13)
	    	.style('text-anchor', 'middle')
	    	.style('pointer-events', 'none')
	    	.style('fill', function (d, i) {
	    		if (i === 0) return "black";
	    		if (i === 4) return "white";
	    	})
	    	.text(function (d, i) {
	    		if (i === 0) return "bottom 20%";
	    		if (i === 4) return "top 20%";
	    	});
	}

 	// value labels
  	legendBoxes.append('text')
    	.attr('class', 'colorlegend-labels')
      	.attr('dy', '.71em')
      	.attr('x', function (d, i) {
	        var leftAlignX = i * (boxWidth + boxSpacing);
    	    return isNumeric ? leftAlignX : (leftAlignX + boxWidth / 2);
      	})
      	.attr('y', boxLabelHeight + boxHeight + 4)
      	.style('text-anchor', function () {
	        return type === 'ordinal' ? 'start' : 'middle';
      	})
      	.style('pointer-events', 'none')
      	/*.classed('rotate', function() {
      		return (dataType === 'categorical');
      	})*/
      	.text(function (d, i) {
	        // show label for all ordinal values
    	    if (type === 'ordinal') return dataValues[i];
    	    else return format[dataType](dataValues[i], unitType); // format is defined based on dataType
      	});
      	  
  	// show a title in center of legend (bottom)
  	if (title) {
	    legend.append('text')
        	.attr('class', 'colorlegend-title')
        	.attr('x', (colors.length * (boxWidth / 2)))
        	.attr('y', boxLabelHeight + boxHeight + titlePadding)
        	.attr('dy', '.71em')
        	.style('text-anchor', 'middle')
        	.style('pointer-events', 'none')
        	.text(title);
  	}
    
  	return legend;
};