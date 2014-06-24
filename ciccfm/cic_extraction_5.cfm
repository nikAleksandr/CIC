<CFPARAM name="tablename1" default="">
<CFPARAM name="SubCategory_List1" default="">
<CFPARAM name="tablename2" default="">
<CFPARAM name="SubCategory_List2" default="">
<CFPARAM name="States_List" default="">

<!--- WHAT YEARS TO SHOW? --->
<cfquery datasource="naco_cic" name="get_years">
select * from CATEGORIES_YEARS
where cat_name_fk = '#tablename1#'
order by cat_year DESC
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


<!-- start of tab5 -->

<!---<CFOUTPUT>
Selected Values:<P>
Table1: #tablename1#<BR>
Sub1: #SubCategory_List1#<BR>
Table2: #tablename2#<BR>
Sub2: #SubCategory_List2#<BR>
States: #States_List#<BR>
</CFOUTPUT> --->


<p><em><font size="4">Select a Year:</font></em></p>


<FORM action="cic_extraction_6.cfm">
<CFIF #get_years.recordcount# GT 0>
<select id="yearlist" name="Year_List" size="10" >
	<CFOUTPUT query="get_years"> 
         <option value ="#CAT_YEAR#"> &nbsp; #CAT_YEAR#  &nbsp; </option>
    </CFOUTPUT>   
</select>
<CFELSE>
<strong>Only one year of data availble for this selection!  </strong>
</CFIF>


<CFOUTPUT>
<input type="hidden" name="States_List" value="#States_List#" />
<input type="hidden" name="tablename1" value="#tablename1#" />
<input type="hidden" name="SubCategory_List1" value="#SubCategory_List1#" />
<input type="hidden" name="tablename2" value="#tablename2#" />
<input type="hidden" name="SubCategory_List2" value="#SubCategory_List2#" />

</CFOUTPUT>
<input type="submit" value="Next - Get Results!" />

</FORM>
<P>
<em>Data may not be available for all years.</em>

</body>
</html>