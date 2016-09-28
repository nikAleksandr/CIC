#CIC (Now County Explorer)

========
##The County Explorer

The CIC uses D3's data manipulating and mapping abilities to display a very wide range of county-based data based on user selection.

Binary, categorical, percent, and levels with negative values are all treated slightly differently in creating quantiles, or linear (or arbitrary) thresholds where needed.

Single-click on a county returns a tooltip displaying exact data including and related to the selected "Primary Indicator".

Double-click presents basic county information.

Data is recieved in JSON format from an SQL server by running requests through a Coldfusion script.

=========
##Installation
1. Clone this repo
2. Install [Node Package Manager](https://www.nodejs.org/en/download) if you don't already have it installed.
3. Use npm to install [grunt CLI](http://gruntjs/com/getting-started). (May need sudo)
4. Go to the root CIC directory and run `npm install`, which will install all other dependencies.
5. Use `grunt` inside the CIC root directory to create a minified and combined build.js file.

=========
##Update Procedure
1. Update the datatbase with any new indicators and updated indicators.  Keep track of any changed or additonal field and table names for updating in CICstructure.json
  * Binary data should be represented with 1 and 0 values.  
  * Percentage data should be in decimal format (90% = 0.9).  
  * Categorical data must have values that exactly match what will be shown in the legend.  
  * Level data should have numeric data entries.
  * Null values should be represented by a "." character.
2. Update CICStructure.json with indicators and datasets.  Datasets are unique and should not be duplicated across multiple categories.  Categories are for organizational purposes only and do not relate to the categories on the front end of the site.  See the section on CICStructure.json for a full list of options.
  * ```
{
  "name": "Example Dataset",
  "years": [
    2007,
    2012
  ],
  "source": "NACo Analysis of U.S. Census Bureau - American Communities Survey data",
  "db_dataset": "Example_SQL_Table_Name",
  "companions": [
    [
      "Example Dataset",
      "Example Indicator 1"
    ],
    [
      "Example Dataset",
      "Example Indicator 2"
    ]
  ],
  "children": [
    {
      "name": "Example Indicator 1",
      "unit": "dollars",
      "dataType": "level",
      "definition": "This indicator has a short definition",
      "db_indicator": "Example_Indicator_One_SQL_Field_Name"
    }
     {
      "name": "Example Indicator 2",
      "dataType": "categorical",
      "definition": "This indicator has a short definition as well",
      "db_indicator": "Example_Indicator_Two_SQL_Field_Name"
    }
  ]
}
```
3. Update indicatorList.html.  Remove previous month's 'updated' and 'new' badges, add any new indicators, update any needed indicators and datasets.  Datasets may appear in several categories.  Update the curated list of datasets (or categories) at the top of the file.  Angular.js is used to determine which will appear and be hidden.  Use `ng-show` or `ng-hide` such as: `ng-show="indicatorListType == 'curated'"` in order to show or hide for the curated list.
```
<li class="dataset" name="Transportation Employment">
	<a>Transportation Employment</a>
	<ul class="dropdown-menu">
		<!-- --><li class="disabled dropdown-header">
			<a class="disabled dropdown-header" href="#">Header One</a>
		<!-- --></li>
		<li>
			<a class="indicator" name="Example Indicator 1" href="#">Example Indicator 1 Name</a>
		</li>
		<li>
			<a class="indicator" name="Example Indicator 2" href="#">Example Indicator 2 Name</a>
		</li>
		<!-- --><li class="disabled dropdown-header">
			<a class="disabled dropdown-header" href="#">Header Two</a>
		<!-- --></li>
		<li>
			<a class="indicator" name="Example Indicator 3" href="#">Example Indicator 3 Name</a>
		</li>
	</ul>
</li>
```
4. Update overlay.html with a sample of indicators, using angular.js in the anchor tag to link internally to the appropriate indicators.
```
<div class="pad-down-5 panel-bullet">&bull; <a class="link" ng-click="panel.goToIndicator('Example Dataset', 'Example Indicator 1')">Example Indicator 1 Name</a></div>
```
5. Push changed files into their respective folders on future/ on the server for testing.
6. Prepare and schedule email.
7. Test.
8. If any javascript files have been changed (not including CICStructure.json), run 'grunt' in terminal inside the root folder to compile and minify the code.  CIC.min.js is the only file neccessary to push to the live version.  It is located at: CIC/build/CIC.min.js
9. Push changed files to their respective folders in the live version (See 8 above for changes to javascript files).  If index.html has changed, make sure to comment javascript links at the bottom so that only CIC.min.js is linked as it contains all the internal dependencies and javaScript files.
10. Test again.  Success!  Push changes to github.

=========
##API Reference
CICstructure.json contains the metadata where these options and properties are used.  There are no duplicates.  When duplicate entries occur in the indicatorList.html, CICStructure will group them according to dataset for efficiency when updating a large data source.  For example, Administration Employment is under the County Employment category, rather than the County Administration category.

###Standard Properties
'req' indicates that the property and a value is required for the data to function.

| Property          | Type            | Default | Dataset or Indicator |  Description  |
| :---------------- | :-------------- | :------ | :------------------- | :------------ |
| 'name'            | 'string'        | req     | both                 | The primary dataset and indicator identifier. Necessary for both dataset and indicator. |
| 'years'           | 'numeric array' | req     | dataset              | Array of years. Applies specifically to the year the data is supposed to reflect, or seoncdarily, the year the data was collected.  The latest year in the array must match the year of the data you want to display as stored in the SQL database.  The indicator-level 'year' property can be used to override an indicator not matching its dataset. |
| 'source'          | 'string         | req     | dataset or both      | Information about the source of the data.  Will automatically append the latest of the 'years' array at the end of the source unless the 'suppressYear' or 'legendTitlePre' properties are active. |
| 'companions'      | '2-D array'     | req     | dataset or both      | Two-dimensional array containing the dataset and indicator names of the indicators that will appear in the overlay on a single-click event.  Will show length minus one indicators in the overlay.  Indicator-level 'companions' property will override any dataset-level 'companions' property. |
| 'children'        | 'object array'  | req     | dataset or both      | Array of objects, each of which is an indicator within the dataset. |
| 'DBDataset'       | 'string'        | req     | dataset or both      | SQL table location of 'database' data. |
| 'DBIndicator'     | 'string'        | req     | indicator            | SQL field location of 'indicator' data. |
| 'dataType'        | 'string'        | req     | indicator            | Type of data interpretation, supported types include: 'level' - standard numeric, 'level_np' - standard numeric that does not start at 0, for negative number or other reasons, 'categorical' - discrete data, generally as strings. supports 5 categories, 'binary' - yes and no or on or off., and 'percent', for percentages.  For both binary and categorical, data must be stored as strings exactly as it will be displayed. 'format_type' may be used to change the number of decimals displayed. |
| 'definition'      | 'string'        | null    | indicator            | The definition will be displayed below the map when an indicator is mapped or shown as a companion.
| 'unit'            | 'string'        | null    | indicator            | 'unit' property will be displayed in the legend when present.  'dollars' will change the formatting of the numbers.  Neccessary for clarity when using the 'perCapita' feature. |

###Additional Properties

| Property          | Type            | Default | Dataset or Indicator |  Description  |
| :---------------- | :-------------- | :------ | :------------------- | :------------ |
| 'year'            | 'numeric'       | from 'years' | indicator       | Used to override the dataset level 'years' property at the indicator level.
| 'suppressYear'    | 'boolean'       | false   | either               | Supresses the year in the source information.
| 'thresholds'      | 'numeric array' | null    | indicator            | Used to mandate the legend instead of the default quantiles.  IE: '[-0.3,-0.2,-0.1,0]' The first and last numbers are determined by the minimum and maximum data values. |
| 'has_profile'     | 'boolean'       | false   | indicator            | Indicates when an indicator should change its single-click behavior to load a profile.  Must be paired with a change to the profile section of main.js.  The data shown will be from the first non-self 'companions' indicator.  Aside from 'has_profile', the 'name' and 'definition' property, all other properties should match the first companion. |
| 'order'           | 'object'        | null    | indicator            | Used for 'categorical' and 'binary' 'dataType' indicating the name of the category and the numeric order (0-indexed) as property and value, respectively.  IE: '{"Minimum Requirements": 0,"State Regulatory Requirements": 1,"Require GAAP": 2}'. |
| longLegendNames   | 'boolean'       | false   | indicator            | Indicates that the (usually categorical) data needs more room in the legend.  Makes text wrap and adds a few more pixels of legend width. |
| 'greyData'        | 'string'        | null    | indicator            | Changes the "county data is unavailable if the county is colored grey" legend text to the string value associated with this indicator object's greyData. |
| 'overrideLegendMax' | 'string'      | null    | indicator            | Changes the legend maximum value to the string value of 'overrideLegendMax'. |
| 'suppressMinMax'  | 'boolean'       | false   | indicator            | Removes the minimum and maximum values from the legend when desired. |
| 'format_type'     | 'string'        | null    | indicator            | Only works for 'level' and 'level_np' values of 'dataType' properties. May take two possible values: 'dec1' fixed with one decimal place and 'dec2', fixed with 2 decimals places.  If format_type is missing or unspecified, values are displayed as integers. |
| 'notes'           | 'string'        | null    | either               | Specifies the CSS class of the note stored in the assets/notes.html file. IE: 'bjs-note'  The actual text of the note must be placed in a div that matches this class in addition to the "idio-note" class (so that it is recognized as a non-permanent note). |
| 'CETNulls'        | 'string'        | null    | indicator            | Intercepts numeric data and codes 999 as 'No Recession' and -999 as 'No Recovery'.  Sepcific function for the County Economies data.  Value of the property does not matter. |
| 'customRange'     | 'array'         | standard colors | indicator    | Creates a custom set and order of colors. IE: '["rgb(255,153,51)", "rgb(49,130,189)", "rgb(7,81,156)"]'. |
| 'suppressPrimeInd' | 'boolean'      | false   | indicator            | Suppresses the appearance of the primary indicator in the tooltip (and the definition).  Can be useful for hacking strange data. |
| 'perCapita'       | 'boolean'       | false   | either               | When true, will activate the perCapita button, dividing by the dataset's year of population data.  Can be activated at the dataset level and overridden for children by passing the value false.  PerCapita is always off for non "level" and "level_np" dataTypes. |

###Legend Properties
Can be applied at dataset or indicator level. Indicator level properties that apply to the legend will override Dataset-level properties.

| Property          | Type            | Default | Dataset or Indicator |  Description  |
| :---------------- | :-------------- | :------ | :------------------- | :------------ |
| 'legendTitlePre'  | 'string'        | year of data | either          | Replaces the dataset year value with a span of years, or a vintage year for the dataset.  Should always be a year value, though in string format.  Will also appear on the source when the 'suppressYear' is not 'true'. |
| 'legendTitleMain' | 'string'        | dataset name | either          | Replaces the dataset name in the legend with the string value indicated.  Not recommedned. |
| 'legendTitlePost' | 'string'        | null    | either               | Adds an addendum to the dataset, such as ",as of May, 2015". Often used with 'suppressYear' |
| 'subtitlePre'     | 'string'        | null    | indicator            | Adds a specific year for an indicator separate from the dataset before the indicator name.  Will deactivate legendTitlePre. |
| 'subtitleMain'    | 'string'        | indicator name | indicator     | Replaces the indicator name in the legend with string values indicated. Not Recommended. If the indicator is a profile, this will default to the first companion without having to use 'subtitleMain'. |
| 'subtitlePost'    | 'string'        | null    | indicator            | Adds an addendum to the indicator nname.  Overrides a "unit" property. |

=========
##Specific Examples

###Profile Example
Updating a profile is similar to the standard update procedure, but involves some special modifications to work properly.
1. Follow [Update Procedure]() steps 1 and 2 ignoring the profiles and just adding/updating the dataset's indicators.
2. Identify the profile data indicator and duplicate it.  The profile data indicator will be the data displayed on the map when people select the profile from indicatorList.html.
3. Change the name of this duplicate indicator to the name you want the profile to have.  This must be a unique name.
4. Add the property `"has_profile": true` to the profile indicator.
5. Make sure the dataset's (or at least the profile indicator's) first companion matches the profile data indicator you want.
5. Modify the `CIC.executeSearchMatch()` function in main.js to include the new profile indicator.
6. Add the profiles to the '/profiles/ExampleProfileName/' directory.
8. Continue with [Update Procedure]() Step 3.
  * When testing, make sure any county names that have "/", "'", and other special characters are being correctly found.


=========
##Additional Functionality
- Verbose Mode - For debugging, change CIC.verbose to true in main.js.  Important/common error logging will occur even when false.
- Ctrl + shift + L will force the map to adopt a more standard single-hue color scheme for continuous data as seen at [Color Brewer](www.colorbrewer2.org)

![Single-hue colors](/img/CICThumb_IPad_oldColors.png)

=========
##Contributors
Jefferson Pecht and Nick Lyell
