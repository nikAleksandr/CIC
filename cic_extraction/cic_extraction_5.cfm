<CFPARAM name="tablename1" default="">
<CFPARAM name="SubCategory_List1" default="">
<CFPARAM name="tablename2" default="">
<CFPARAM name="SubCategory_List2" default="">
<CFPARAM name="States_List" default="">

<!--- WHAT YEARS TO SHOW? --->
<cfquery datasource="naco_cic" name="get_years">
select * from CATEGORIES_YEARS
where CAT_TABLE_NAME = '#tablename1#'
order by cat_year DESC
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
			
			<H3><em>Select a year</em></H3>
		</div>
		<div class="col-md-2">
			<img id="nacoLogo" alt="National Association of Counties Logo" src="../img/NACoLogo_NoTagBLACK_tm.png" />
		</div>
	</div>
</div>

<!-- start of tab5 -->

<!---<CFOUTPUT>
Selected Values:<P>
Table1: #tablename1#<BR>
Sub1: #SubCategory_List1#<BR>
Table2: #tablename2#<BR>
Sub2: #SubCategory_List2#<BR>
States: #States_List#<BR>
</CFOUTPUT> --->

<FORM class="extraction-form" action="cic_extraction_6.cfm">
<CFIF #get_years.recordcount# GT 0>
<select class="form-control extraction-multiple" id="yearlist" name="Year_List" size="10" multiple>
	<CFOUTPUT query="get_years"> 
         <option value ="#CAT_YEAR#"> &nbsp; #CAT_YEAR#  &nbsp; </option>
    </CFOUTPUT>   
</select>
<CFELSE>
<p>Only one year of data availble for this selection.</p>
</CFIF>


<CFOUTPUT>
<input type="hidden" name="States_List" value="#States_List#" />
<input type="hidden" name="tablename1" value="#tablename1#" />
<input type="hidden" name="SubCategory_List1" value="#SubCategory_List1#" />
<input type="hidden" name="tablename2" value="#tablename2#" />
<input type="hidden" name="SubCategory_List2" value="#SubCategory_List2#" />

</CFOUTPUT>

<p>Hold the <i>Ctrl</i> key and click to select multiple years if desired. <input class="btn btn-info" type="submit" value="Next - Get Results!" /></p>

</FORM>
<i>Data may not be available for all years. </i>


</body>
</html>