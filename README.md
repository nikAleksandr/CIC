#CIC
===

##The County Explorer

=========

The CIC uses D3's data manipulating and mapping abilities to display a very wide range of county-based data based on user selection.

Metadata is kept in the hierarchical CICstructure.json file, which is pulled into main.js as needed on data calls to the server.

Binary, categorical, percent, and levels with negative values are all treated slightly differently in creating quantiles, or linear thresholds where needed.

Single-click on a county returns a tooltip displaying exact data including and related to the selected "Primary Indicator"

Data is recieved in JSON format from an SQL server by running requests through a Coldfusion script

=========
##Additional Functionality
- Verbose Mode - For debugging, change CIC.verbose to true in main.js.  Important/common error logging will occur even when false.
- Ctrl + shift + L will force the map to adopt a more standard single-hue color scheme for continuous data as seen at [Color Brewer](www.colorbrewer2.org)

![Single-hue colors](/img/CICThumb_IPad_oldColors.png)

- Ctrl + shift + E will export the current map SVG as a .png image

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

