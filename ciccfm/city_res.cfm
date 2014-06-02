<!--- Search results based on Search By City NAME --->
<CFPARAM NAME="city" DEFAULT="">


<!---<CFIF #statecode# EQ '' AND #city# EQ ''><cfabort></CFIF>  --->



<!--- <CFQUERY NAME="getstate" DATASOURCE="naco_cic">
SELECT *
FROM States (NOLOCK)
WHERE code = '#statecode#'
</CFQUERY> --->


<CFQUERY NAME="getcities" DATASOURCE="naco_cic">
SELECT DISTINCT
   CITIES.FIPS,  CITIES.City, CensusPlace, IncorporatedArea, CensusPlace,  county_name, county_data.State
FROM
 CITIES (NOLOCK) INNER JOIN county_data (NOLOCK)  ON CITIES.FIPS = county_data.FIPS
WHERE CITIES.CITY LIKE   <cfqueryparam cfsqltype="cf_sql_varchar"  Value="%#city#%">  
 and  Abbreviated = 0 and notacity is null
ORDER BY county_data.STATE, county_name
</CFQUERY>

 


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>CITY RESULTS PAGE</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link href='http://fonts.googleapis.com/css?family=Roboto:400' rel='stylesheet' type='text/css'>
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
<link rel="stylesheet" href="http://nacocic.naco.org/css/main.css">
<style>
#responseContent{
	background-color: rgba(255,255,255,0);
}
</style>

</head>
<body id="responseContent">
<div class="container-fluid">
<CFOUTPUT>
		<CFIF #getcities.RecordCount# EQ 0>
		<H5>No Cities with the name of "#city#" were located.</H5><P>
		</CFIF>

		<CFIF #getcities.RecordCount# EQ 1>
		<H5>One City by the name of "#city#" was located.</H5>
		</CFIF>

		<CFIF #getcities.RecordCount# GT 1> 
		<H5>#getcities.RecordCount# Cities with the name of "#city#" were located.</H5>
		</CFIF>
</CFOUTPUT>
<P>

<CFIF #getcities.RecordCount# GT 0>

	<TABLE class="table table-striped table-condensed">
	<TR>
		<TH width="10%"align="center">State</TH>
		<TH width="25%">Place</TH>
		<TH width="35%">Type of Place &nbsp;  </TH>
		<TH width="30%">County</TH>
	</TR>
	 <CFOUTPUT QUERY="getcities">
	<TR>
		<TD align="center">#State#</TD>
		<TD>#CITY#</TD>
 		<TD>#CensusPlace# <CFIF #IncorporatedArea# EQ "Yes"> &nbsp; (Incorporated Area)<CFELSE>&nbsp; </CFIF>  &nbsp; </TD>
		<TD><a href="http://www.uscounties.org/cffiles_web/counties/county.cfm?id=#FIPS#" >#County_Name#</a>
        </TD>
	</TR>
	</CFOUTPUT> 
	</TABLE>
</CFIF>	
<P>
<P><font  color="#999999">
<strong>Incorporated Place:</strong> A type of governmental unit incorporated under state law as a 	city, town (except the New England states, New York, and Wisconsin), borough  (except in Alaska and New York), or village and having legally prescribed limits,  powers, and functions.</font>

</div>
</body>
</html>
