#CIC
===

##The County Explorer

=========

The CIC uses D3's data manipulating and mapping abilities to display a very wide range of county-based data based on user selection.

Binary, categorical, percent, and levels with negative values are all treated slightly differently in creating quantiles, or linear (or arbitrary) thresholds where needed.

Single-click on a county returns a tooltip displaying exact data including and related to the selected "Primary Indicator".

Double-click presents basic county information.

Data is recieved in JSON format from an SQL server by running requests through a Coldfusion script.

=========
##Additional Functionality
- Verbose Mode - For debugging, change CIC.verbose to true in main.js.  Important/common error logging will occur even when false.
- Ctrl + shift + L will force the map to adopt a more standard single-hue color scheme for continuous data as seen at [Color Brewer](www.colorbrewer2.org)

![Single-hue colors](/img/CICThumb_IPad_oldColors.png)

=========
##Dependencies
- node.js
- Grunt.js

=========
##Update Procedure
1. Update the datatbase with any new indicators and updated indicators.  Keep track of any changed or additonal field and table names for updating in CICstructure.json
2. Update CICStructure.json with indicators and datasets.  Datasets are unique and should not be duplicated across multiple categories.  Categories are for organizational purposes only and do not relate to the categories on the front end of the site.  See the section on CICStructure.json for a full list of options.
3. Update indicatorList.html.  Remove previous month's 'updated' and 'new' badges, add any new indicators, update any needed indicators and datasets.  Datasets may appear in several categories.  Update the curated list of datasets (or categories) at the top of the file.  Angular.js is used to determine which will appear and be hidden.  Use ng-show or ng-hide such as: ng-show="indicatorListType == 'curated'" in order to show or hide for the curated list.
4. Update the overlay with a sample of indicators, using angular.js in the anchor tag to link internally to the appropriate indicators: ng-click="panel.goToIndicator('Educational Attainment', 'High School Graduate')"
5. Push changed files into future/ for testing.
6. Prepare and schedule email.
7. Test
8. If any javascript files have been changed (not including CICStructure.json), run 'grunt' in terminal inside the root folder to compile and minify the code.  CIC.min.js is the only file neccessary to push to the live version.  It is located at: CIC/build/CIC.min.js
9. Push changed files to live.  If index.html has changed, make sure to comment javascript links at the bottom so that only CIC.min.js is linked as it contains all the internal dependencies and javaScript files.
10. Test again.  Success!

=========
##CICStructure.json 
There are no duplicates.  When duplicate entries occur in the indicatorList.html, CICStructure will group them according to dataset for efficiency when updating a large data source.  For example, Administration Employment is under the County Employment category, rather than the County Administration category.

#Properties
- years - applies specifically to the year the data is supposed to reflect, or the year the data was collected.
- source
- companions
- suppressYear - supresses the year in the source information.


- vintage - remove? maybe add a "month of last update" in the format of a Date object with year and month inputs

###Legend Properties
Indicator level properties that apply to the legend will override Dataset-level properties
- legendTitlePre - defaults to dataset year or the year the data is supposed to reflect. When overridden, may contain a span of years, or a vintage year for the dataset.  Should always be a year value, though in string format.  Will also appear on the source when the source year is not suppressed.
- legendTitleMain - defaults to dataset name.
- legendTitlePost - default off.  Override may contain an addendum to the dataset, such as ",as of May, 2015".
- subtitlePre - default off.  Override if there is a specific year for an indicator separate from the dataset.  Will turn off legendTitlePre.
- subtitleMain - defaults to indicator name.  If the indicator is a profile, this will default to the first companion.
- subtitlePost - default off. subtitlePost overrides a "unit" property if it is present.

##indicator level properties
- name
- DBDataset - database table location (not yet implemented)
- DBIndicator - database field location (not yet implemented)
- dataType – supported types include: level, categorical, binary, percent
- year - Used to override the dataset level "years" property at the indicator level.
- definition
- unit
- thresholds
- has_profile
- order
- longLegendNames
- greyData - changes the labeling of the grey legend color from N/A to the string value associated with this indicator object's greyData.
- overrideLegendMax
- suppressMinMax
- suppressQuint - supresses the appearance of "bottom 20%" & "top 20%" text in legend when neccessary
- format_type
- notes - [".exports-note"]
- CETNulls
- customRange - creates a custom set and order of colors IE: ["rgb(255,153,51)", "rgb(49,130,189)", "rgb(7,81,156)"]
- suppressPrimeInd – suppresses the primary indicator display in the tooltip (and the definition)
- perCapita - will activate the perCapita button when set to true.  Can be activated at the dataset level and will be passed to children.  Can be deactivated for children by passing the value false.  PerCapita is off for non "level" and "level_np" dataTypes.

