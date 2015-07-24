<!--- State Map Page --->

<CFPARAM NAME="state" DEFAULT="">
<CFPARAM NAME="statelist" DEFAULT="">

<CFQUERY NAME="getcounties" DATASOURCE="naco_data">
		SELECT CompanyID,  Company, State,  CountyName, CountyNameShort		
		FROM  client_naco_AMS_MAST  (NOLOCK)
		WHERE State='#state#' and OrgType in ('County W/o Govt Structure', 'Geographical Census Area', 'County', 'Independent City') 
		ORDER BY OrgType, CountyNameShort
		</CFQUERY> 


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Find a County</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../naco_default.css" rel="stylesheet" type="text/css">
</head>
<body class="body">


		
		
		<CFQUERY NAME="getstate" DATASOURCE="naco_data">
		SELECT Name, Code
		FROM States
		WHERE code = '#state#'
		</CFQUERY>
	
		
		<CFOUTPUT><H3>#getstate.name#</H3><P></CFOUTPUT>
		
		
		<CFLOOP QUERY="getstate">
		 <CFINCLUDE template="maps/#code#.cfm">
		</CFLOOP> 
		
		
		<CENTER>
		
		<CFOUTPUT>
		<img src="images/#getstate.code#.gif" usemap="##map" ismap border="0" align="top">
		</CFOUTPUT>
</CENTER>
		<P>




<A HREF="usamap_blue.cfm?websource=naco" >USA Map</A>

</body>
</html>