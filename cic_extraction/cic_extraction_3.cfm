<CFPARAM name="tablename1" default="">
<CFPARAM name="SubCategory_List1" default="">

<CFPARAM name="tablename2" default="">
<CFPARAM name="SubCategory_List2" default="">


<CFIF tablename2 NEQ "" and  #SubCategory_List2# EQ "" >
<strong>GO BACK, YOU DID NOT SELECT ANY SUB-CATEGORIES!</strong>
<CFABORT>
</CFIF>

<cfquery datasource="naco_cic" name="get_states">
select statecode, statename
from states
where countrycode = 'USA'
</cfquery>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CIC Extraction Tool</title>

<link rel="stylesheet" href="../css/normalize.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
<link href='http://fonts.googleapis.com/css?family=Roboto+Condensed:300,400' rel='stylesheet' type='text/css'>
<link href='http://fonts.googleapis.com/css?family=Arvo' rel='stylesheet' type='text/css'>
<link rel="stylesheet" href="../css/main.css">

</head>
 <body>
    <div id="extraction-header">
	<div class="row" >
		<div class="col-md-10">
			<h1>NACo CIC Extraction Tool</h1>
			
			<H3><em>Select a specific State, or select "All States"</em></H3>
		</div>
		<div class="col-md-2">
			<img id="nacoLogo" alt="National Association of Counties Logo" src="../img/NACoLogo_NoTagBLACK_tm.png" />
		</div>
	</div>
	<a href="http://cic.naco.org">Return to Interactive Map</a>
</div>

<!-- start of third tab -->

<form class="extraction-form" action="cic_extraction_5.cfm" method="post">
<!-- skip county selection for now -->

    <select class="form-control extraction-multiple" id="statelist" name="States_List" size="10" multiple="multiple">
      <option value="ALL">All States</option>
      <CFOUTPUT query="get_states">
      <option value="'#StateCode#'">#StateName#</option>
      </CFOUTPUT>
    </select>
    
     <CFOUTPUT>
     <input type="hidden"  name="tablename1" value="#tablename1#" />
    <input type="hidden"  name="SubCategory_List1" value="#SubCategory_List1#" />
    <input type="hidden"  name="tablename2" value="#tablename2#" />
    <input type="hidden"  name="SubCategory_List2" value="#SubCategory_List2#" />
    
    </CFOUTPUT> 

<p>Hold the <i>Ctrl</i> key and select multiple states if desired. <input class="btn btn-info" type="submit" value="Next" /></p>

</form>



</body>
</html>

