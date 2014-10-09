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

<div id="responseContent" class="container-fluid">
	<div id="cityResponse">
	<CFOUTPUT>
			<CFIF #getcities.RecordCount# EQ 0>
			<p>No Cities with the name of "#city#" were located.</P>
			</CFIF>
	
			<CFIF #getcities.RecordCount# EQ 1>
			<p>One City by the name of "#city#" was located.</p>
			</CFIF>
	
			<CFIF #getcities.RecordCount# GT 1> 
			<p>#getcities.RecordCount# Cities with the name of "#city#" were located.</p>
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
			<TD><a onclick="CIC.executeSearchMatch('#FIPS#')">#County_Name#</a>
	        </TD>
		</TR>
		</CFOUTPUT> 
		</TABLE>
	</CFIF>	
	<p style="color="#999999">
	<strong>Incorporated Place:</strong> A type of governmental unit incorporated under state law as a 	city, town (except the New England states, New York, and Wisconsin), borough  (except in Alaska and New York), or village and having legally prescribed limits,  powers, and functions.
	</p>
	</div>
</div>
</html>
