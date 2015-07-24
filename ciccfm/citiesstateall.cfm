<!--- Lists all cities for a selected state --->

<CFPARAM NAME="atatime" DEFAULT="100">
<CFPARAM NAME="srow" DEFAULT="1">
<CFPARAM NAME="ALPHASEARCH" DEFAULT="A">
<CFPARAM NAME="STATECODE" DEFAULT="">
<CFPARAM NAME="ALPHATOTAL" DEFAULT="">

<CFPARAM default="" name="websource">



<CFIF #websource# NEQ "naco">
<cflocation url="http://www.naco.org/Counties/Pages/FindACounty.aspx" >
<CFELSE>



<CFSET #nsrow#= #srow# + #atatime#>
<CFSET #psrow#= #srow# - #atatime#>




<CFQUERY NAME="get_states" DATASOURCE="naco_data">
SELECT Code, Name
FROM STATES (NOLOCK)
WHERE Code= <cfqueryparam cfsqltype="cf_sql_varchar"  Value="#STATECODE#">
</CFQUERY>


<CFQUERY NAME="getcities" DATASOURCE="naco_data">
SELECT DISTINCT
     Cities2.FIPSID, Cities2.STATE, Cities2.CITY, 	 FIPS, company, client_naco_AMS_Mast.State, 	 SUBSTRING (Cities2.CITY,1,1) AS ALPHA
FROM        Cities2 (NOLOCK)  , client_naco_AMS_MAST (NOLOCK) 
WHERE      Cities2.FIPSID = client_naco_AMS_MAST.fips
			AND Cities2.STate = <cfqueryparam cfsqltype="cf_sql_varchar"  Value="#STATECODE#">
			AND Cities2.City LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ALPHASEARCH#%">
  and Abbreviated = 0 and NotACity is null
ORDER BY Cities2.CITY
</CFQUERY>



<CFQUERY NAME="get_counties" DATASOURCE="naco_data">
			SELECT  client_naco_AMS_Mast.state, company, OrgType,  FIPS
			FROM client_naco_AMS_MAST  
			WHERE state=<cfqueryparam cfsqltype="cf_sql_varchar"  Value="#STATECODE#">
             and OrgType in ('county', 'independent city', 'county w/o govt structure', 'geographical census area') 
			ORDER By OrgType, company
</CFQUERY>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Find a County</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../naco_default.css" rel="stylesheet" type="text/css">
</head>
<body class="body">


<CENTER>
<a href="http://www.naco.org/Counties/Pages/FindACounty.aspx#map" target="_top"><img src="images/icon_map.png"></A>
</CENTER>

<P>


<CFOUTPUT QUERY="get_states"><H3>Places in #Name#</h3></CFOUTPUT>

 
<P></P>

Select a letter of the alphabet to view a listing of all cities within <CFOUTPUT>#get_states.Name#</CFOUTPUT>
beginning with that letter or select a county to view a listing of the cities within that county.
<P> &nbsp; <BR>



<TABLE width="100%" border="0" cellpadding="0" cellspacing="0">
<TR valign="top">
<TD width="100%">

<CFOUTPUT>
	<CENTER>
	<FORM ACTION="citiesstateall.cfm" METHOD="GET">
	<INPUT TYPE="HIDDEN" VALUE="#STATECODE#" NAME="STATECODE">
    <input type="hidden" value="naco" name="websource">
	<input name="ALPHASEARCH" type="Submit" value="A"  ></input> 
	<input name="ALPHASEARCH" type="Submit" value="B"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="C"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="D"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="E"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="F"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="G"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="H"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="I"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="J"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="K"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="L"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="M"  ></input><BR>
	<input name="ALPHASEARCH" type="Submit" value="N"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="O"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="P"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="Q"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="R"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="S"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="T"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="U"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="V"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="W"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="X"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="Y"  ></input>
	<input name="ALPHASEARCH" type="Submit" value="Z"  ></input>
	</FORM>
</CFOUTPUT>


		<TABLE WIDTH="95%" BORDER="1" cellspacing="0" cellpadding="2">
		<TR align="center"><TH colspan="2" BGCOLOR="#A5BBD2" ><Font color="black"><strong>Places in 
		<CFOUTPUT>#get_states.Name# beginning with "#getcities.ALPHA#"</CFOUTPUT></strong></Font></TH></TR>
		<TR>
		<TH width="45%" BGCOLOR="#A5BBD2"><FONT color="black" ><strong>Place</strong></font></TH>
		<TH width="55%" BGCOLOR="#A5BBD2"><FONT color="black"><strong>County</strong></font></TH>
		</TR>
		
		

		<CFOUTPUT QUERY="getcities">
		<TR>
		<TD>#city#</TD>
		<TD>
		<A name="#ALPHA#">
		<a href="county.cfm?websource=naco&id=#FipsID#">#company#</a></A>
		</TD>
		</TR>
		</CFOUTPUT>
		</TABLE>
</CENTER>


		
	<blockquote>
	<em><b>Note</b>: The above listing includes cities, towns, 	boroughs and communities based on the US Postal Service mail delivery.</em>
	</blockquote>

	<P>




</TD></TR></TABLE>

	



</body>
</html>

</CFIF>
