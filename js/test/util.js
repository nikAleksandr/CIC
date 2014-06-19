function countIndicators() {
	// console logs count of indicators and datasets
	d3.json("data/CICstructure.json", function(error, CICStructure){
		var datasets = {};
		var u_dcount = 0, u_icount = 0, dcount = 0, icount = 0, c_count = 0;
		for (var i = 0; i < CICStructure.children.length; i++) {
			var category = CICStructure.children[i];
			c_count++;
			for (var j = 0; j < category.children.length; j++) {
				var dataset = category.children[j];
				dcount++;
				if (!datasets.hasOwnProperty(dataset.name)) {
					datasets[dataset.name] = true;
					for (var k = 0; k < dataset.children.length; k++) u_icount++;
				}				
				for (var k = 0; k < dataset.children.length; k++) icount++;
			}
		}
		for (var ind in datasets) u_dcount++;
		console.log('# of Categories: ' + c_count);
		console.log('# of Datasets: ' + dcount);
		console.log('# of Indicators in Datasets: ' + icount);	
		console.log('# of Unique Datasets: ' + u_dcount);
		console.log('# of Indicators in Unique Datasets: ' + u_icount);	
	});
}

function areAllIndicatorsInDatabase() {
  	d3.json("data/CICstructure.json", function(error, CICStructure){
    	d3.tsv('data/database_crosswalk.tsv', function(error, data_array) {
	      	var crosswalk = {};
      		for (var i = 0; i < data_array.length; i++) {
		        if (data_array[i].indicator !== '') {
          			var di = data_array[i].dataset + ' - ' + data_array[i].indicator;
          			crosswalk[di] = data_array[i];
        		}
      		}
      		
      		var di_list = [];
			for (var i = 0; i < CICStructure.children.length; i++) {
				var category = CICStructure.children[i];
				for (var j = 0; j < category.children.length; j++) {
					var dataset = category.children[j];
					for (var k = 0; k < dataset.children.length; k++) {
						var indicator = dataset.children[k];
						di_list.push(dataset.name + ' - ' + indicator.name);
					}
				}
			}
			
			var missing_di = [];
			for (var i = 0; i < di_list.length; i++) {
				if (!crosswalk.hasOwnProperty(di_list[i])) missing_di.push(di_list[i]);
			}
			if (missing_di.length === 0) console.log('All Indicators Are Connected To Database :)');
			else {
				console.log('Nope :(')
				for (var i = 0; i < missing_di.length; i++) console.log(missing_di[i]);
			}
		});
	});	
}

function testDatabaseResponses() {
	// used to test database responses for every indicator; console logs any null (or essentially null) database responses
  	d3.json("data/CICstructure.json", function(error, CICStructure){
    	d3.tsv('data/database_crosswalk.tsv', function(error, data_array) {
	      	var crosswalk = {};
      		for (var i = 0; i < data_array.length; i++) {
		        if (data_array[i].indicator !== '') {
          			var di = data_array[i].dataset + ' - ' + data_array[i].indicator;
          			crosswalk[di] = data_array[i];
        		}
      		}

			var dt = 100; // time between each query call
			var time = 0;
			for (var ind in crosswalk) {
				(function(ind, time){
					var query_str = 'db_set=' + crosswalk[ind].db_dataset + '&db_ind=' + crosswalk[ind].db_indicator;
					setTimeout(function() {
					  	d3.xhr('http://nacocic.naco.org/ciccfm/indicators.cfm?'+ query_str, function(error, request){
					    	// restructure response object to object indexed by fips
					    	try {
					    		var responseObj = jQuery.parseJSON(request.responseText);
						    	if (responseObj.ROWCOUNT === 0) {
						    		console.log('zero data: ' + crosswalk[ind].db_dataset + ', ' + crosswalk[ind].db_indicator);
						    	} else {
						    		console.log('check! :)')
						    	}
					    	}
					    	catch(error) {
					    		console.log('no response: ' + crosswalk[ind].db_dataset + ', ' + crosswalk[ind].db_indicator);
					    	}
						});
					}, time);
				})(ind, time);
									
				time += dt;
			}

    	});
  	});
}

function createDropdownStructure() {
	// create menu structure to be copied over to index.html; be cautious not overwriting anything; most likely will not use this again
	d3.json("data/CICstructure.json", function(error, CICStructure){
		$('#primeIndLi').empty();
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
		}
	});
}