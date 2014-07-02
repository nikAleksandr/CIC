<cfparam name="Category_List" default="">
<cfparam name="tablename1" default="">
<cfparam name="Category_List1" default="">
<cfparam name="Category_List2" default="">


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
			
			<H3><em>Select no more than TEN indicators below.</em></H3>
		</div>
		<div class="col-md-2">
			<img id="nacoLogo" alt="National Association of Counties Logo" src="../img/NACoLogo_NoTagBLACK_tm.png" />
		</div>
	</div>
	<a href="http://cic.naco.org">Return to Interactive Map</a>
</div>

<!--- Abort if no selection --->
<CFIF #Category_List# EQ "">
<strong>You didn't make a selection.  Please <a href="cic_extraction_1.cfm">return to the previous page</a> and make a selection.</strong><CFABORT>
</CFIF>

<!--- Abort if more than two selectios --->
<CFOUTPUT>
		<CFIF #ListLen(Category_List)# GT 2>
        Please limit the selection of Categories to TWO or fewer. <P>
        <A HREF="cic_extraction_1.cfm">Return to Category Selections</a>.
        <CFABORT>
        </CFIF>
        <CFSET Category_List1=#trim(listGetAt(Category_List,1))#>
        <CFIF #ListLen(Category_List)# EQ 2><CFSET Category_List2=#trim(listGetAt(Category_List,2))#></CFIF>
</CFOUTPUT>



        <cfquery datasource="naco_cic" name="get_sub_category">
        select * from crosswalk
        where cat_name = '#Category_List1#' and sub_cat is not null
        order by sub_type
        </cfquery>
 
	    <CFSET tablename1 = #get_sub_category.table_name#>


       

<CFOUTPUT>
<H2>#Category_List1# Indicators</H2> <!---<CFIF #ListLen(Category_List)# EQ 2> and #Category_List2#</CFIF> --->
</CFOUTPUT>
</H2>
       
        
        <!-- start of second tab -->
        
    
        
<CFIF #Category_List2# EQ "">
     <form class="extraction-form" action="cic_extraction_3.cfm" method="post">
        <select class="form-control extraction-multiple" id="sublist" name="SubCategory_List1" size="15" multiple>
          <CFOUTPUT query="get_sub_category">
          <option value="#Data_field#" >#sub_type# - #Sub_Cat#  &nbsp; </option>
          </CFOUTPUT>
        </select>
        <CFOUTPUT>
        <input type="hidden" name="tablename1" value="#tablename1#" />
        </CFOUTPUT>
<CFELSE>
     <form class="extraction-form" action="cic_extraction_2b.cfm" method="post">
        <select class="form-control extraction-multiple" id="sublist" name="SubCategory_List1" size="15" multiple>
          <CFOUTPUT query="get_sub_category">
          <option value="#Data_field#" >#sub_type# - #Sub_Cat# &nbsp; </option>
          </CFOUTPUT>
        </select>
        <CFOUTPUT>
        <input type="hidden" name="Category_List" value="#Category_List#" />
        <input type="hidden" name="tablename1" value="#tablename1#" />
        </CFOUTPUT>
 </CFIF>       
        <p>Hold <em>ctrl</em> key and click, to select multiple indicators. <input class="btn btn-info" type="submit"  value="Next..."></p>
    </form>
</body>
</html>


