<!--- Search results based on Search By City NAME --->

<CFPARAM NAME="zip" DEFAULT="">
<CFPARAM NAME="FORM.zip" DEFAULT="">


<CFIF  #zip# EQ '' >
<cfabort>
</CFIF>  




<!--- <CFIF #websource# NEQ "naco">
<cflocation url="http://www.naco.org/Counties/Pages/FindACounty.aspx" >
<CFELSE> --->


<CFQUERY NAME="cities" DATASOURCE="naco_cic">
SELECT FIPS, City, State, Zip, Abbreviated, county, incorporatedarea, CensusPlace, NYCBorough
FROM CITIES (NOLOCK)
WHERE CITIES.zip LIKE <cfqueryparam cfsqltype="cf_sql_varchar"  Value ="%#zip#%"> and  Abbreviated = 0
ORDER BY STATE, county
</CFQUERY>




<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Find a County</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!--- <link href="../../naco_default.css" rel="stylesheet" type="text/css"> --->
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-1394747-1', 'auto');
  ga('send', 'pageview');

</script>
</head>
<body>

<CFOUTPUT>
		<CFIF #cities.RecordCount# EQ 0>
		<H3>No zips with the name of "#zip#" were located.</H3>
		<H3>Search for another Zip Code.</H3>
		</CFIF>

		<CFIF #cities.RecordCount# EQ 1>
		<strong>One place by the name of "#zip#" was located.</strong>
		</CFIF>

		<CFIF #cities.RecordCount# GT 1> 
		<H2>#cities.RecordCount# places with the zip code  "#zip#" were located.</H2>
       
		</CFIF>
</CFOUTPUT>


<CFIF #cities.RecordCount# GT 0>

	<table class="table table-responsive table-hover">
	<tr>
		    <th align="center">State</th>
			<th>Place</th>
			<th>County</th>
	</tr>
	<CFOUTPUT QUERY="cities">
	<tr style="cursor:pointer" onClick="CIC.displayResults('county.cfm?id=' + CIC.fipsConversion('string', '#FIPS#'))">
		<td align="center">#State#</td>
		<td>#CITY#
		
		<CFIF #incorporatedarea# EQ "YES"><em>(Incorporated Area)</em></CFIF>
		</td>
		<td>#county#  <CFIF #NYCBorough# NEQ "">(#NYCBorough#  Borough)</CFIF>
		</td>
	</tr>
	</CFOUTPUT>
	</table>
</CFIF>	

<p>
<strong>Incorporated Place:</strong> A type of governmental unit incorporated under state law as a 
		 city, town (except the New England states, New York, and Wisconsin), borough   (except in Alaska and New York), 
		 or village and having legally prescribed limits,
		  powers, and functions. -  <A HREF="http://factfinder.census.gov/home/en/epss/glossary_i.html#incorporated_place">US Census Bureau</A>
		 <br/><br/>
         Please consult the <A HREF="https://tools.usps.com/go/ZipLookupAction!input.action" target="_blank">USPS</A> for official address details.
</p>

</body>
</html>
<!--- </CFIF> --->