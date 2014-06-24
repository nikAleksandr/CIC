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
 <link rel="stylesheet" href="../../css/main.css">
<title>CIC</title>
</head>
 <body>
        <div id="header">
			<div>
			<h1>NACo County Intelligence Connection 2.0</h1>
			</div>
</div>
<HR />




<!-- start of third tab -->
<em><font size="4">Select Specific States or "All States":</font></em></p>



<form action="cic_extraction_5.cfm" method="post">
<!-- skip county selection for now -->

    <select id="statelist" name="States_List" size="10" multiple="multiple">
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

<input type="submit" value="Next" />

</form>



</body>
</html>

