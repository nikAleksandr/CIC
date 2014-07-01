#CIC
===

##The County Intelligence Connection (CIC) 2.0

=========

The CIC uses D3's data manipulating and mapping abilities to display a very wide range of county-based data based on user selection.

Metadata is kept in the heirarchichal CICstructure.json file, which is pulled into main.js as needed on data calls to the server.

Binary, categorical, percent, and levels with negative values are all treated slightly differently in creating quantiles, or linear thresholds where needed.

Single-click on a county returns a tooltip displaying exact data including and related to the selected "Primary Indicator"

Data is recieved in JSON format from an SQL server by running requests through a Coldfusion script

=========
##Additional Functionality

- Ctrl + shift + L will force the map to adopt a more standard single-hue color scheme for continuous data as seen at (Color Brewer)[www.colorbrewer2.org]
- Ctrl + shift + E will export the current map SVG as a .png image

