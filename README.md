#CIC
===

##The County Intelligence Connection (CIC) 2.0

=========

The CIC uses D3's data manipulating and mapping abilities to display a very wide range of county-based data based on user selection.

Metadata is kept in the hierarchical CICstructure.json file, which is pulled into main.js as needed on data calls to the server.

Binary, categorical, percent, and levels with negative values are all treated slightly differently in creating quantiles, or linear thresholds where needed.

Single-click on a county returns a tooltip displaying exact data including and related to the selected "Primary Indicator"

Data is recieved in JSON format from an SQL server by running requests through a Coldfusion script

=========
##Additional Functionality

- Ctrl + shift + L will force the map to adopt a more standard single-hue color scheme for continuous data as seen at [Color Brewer](www.colorbrewer2.org)

![Single-hue colors](/img/CICThumb_IPad_oldColors.png)

- Ctrl + shift + E will export the current map SVG as a .png image

=========
##data.json Options
- years - applies specifically to the year the data is supposed to reflect, or the year the data was collected.
- source
- companions
- suppressYear - supresses the year in the source information.


- vintage - remove? maybe add a "month of last update" in the format of a Date object with year and month inputs

###Legend Properties
Indicator level properties that apply to the legend will override Dataset-level properties
- legendTitlePre - defaults to dataset year or the year the data is supposed to reflect. When overridden, may contain a span of years, or a vintage year for the dataset.  Should always be a year value.  Will also appear on the source when the source year is not suppressed.
- legendTitleMain - defaults to dataset name.
- legendTitlePost - default off.  Override may contain an addendum to the dataset, such as ",as of May, 2015".
- subtitlePre - default off.  Override if there is a specific year for an indicator separate from the dataset.  Will turn off legendTitlePre.
- subtitleMain - defaults to indicator name.  If the indicator is a profile, this will default to the first companion.
- subtitlePost - default off. If a "unit" property is present, will take this value unless subtitlePost is present and overrides.

##indicator level names
- name
- dataType
- year: Used to override the dataset level "years" property at the indicator level.
- definition
- unit
- thresholds
- has_profile
- order
- longLegendNames
- greyData - changes the labeling of the grey legend color from N/A to the string value associated with this indicator object's greyData.
- overrideLegendMax
- suppressMinMax
- format_type
- notes - [".exports-note"]
- CETNulls
- customColors
- suppressPrimeInd – suppresses the primary indicator display in the tooltip (and the definition)

