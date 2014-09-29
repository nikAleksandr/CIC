<cfparam name="Category_List" default="">
<cfparam name="tablename1" default="">
<cfparam name="tablename2" default="">
<cfparam name="Category_List1" default="">
<CFPARAM name="SubCategory_List1" default="">
<cfparam name="Category_List2" default="">


<CFOUTPUT>
<CFIF #ListLen(Category_List)# GT 2>
AT THIST TIME, PLEASE LIMIT YOUR SELECTION OF CATEGORIES to 1 or 2. <P>
PLEASE GO BACK AND LIMIT YOUR SELECTION TO JUST 1 OR 2 Primary Categories.
<CFABORT>
</CFIF>

<CFSET Category_List1=#trim(listGetAt(Category_List,1))#>
<CFIF #ListLen(Category_List)# EQ 2><CFSET Category_List2=#trim(listGetAt(Category_List,2))#></CFIF>

</CFOUTPUT>


<CFIF #SubCategory_List1# EQ "">
<CFOUTPUT>
<strong>You didn't make select any indicators.  Please <a href="cic_extraction_2.cfm?Category_List=#Category_List#">return to the previous page</a> and make a selection.</strong>
</CFOUTPUT>
<CFABORT>
</CFIF>

        <cfquery datasource="naco_cic" name="get_sub_category">
        select * from  crosswalk
        where cat_ID_FK = '#Category_List2#' and sub_cat is not null
        order by sub_type
        </cfquery>

	    <CFSET tablename2 = #get_sub_category.table_name#>   

        
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
<!--Script for limiting the number of selections in the selection box-->
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="http://www.google.com/jsapi"></script>
    <script type="text/javascript">
    google.load("jquery", "1");

    $(document).ready(function() {

      var last_valid_selection = null;

      $('#sublist').change(function(event) {
        if ($(this).val().length > 10) {
          alert('Sorry, you can only choose up to 10!');
          $(this).val(last_valid_selection);
        } else {
          last_valid_selection = $(this).val();
        }
      });
    });
</script>
</head>


<body>
<div id="extraction-header">
	<div class="row" >
		<div class="col-md-10">			<h1>NACo CIC Extraction Tool</h1>		</div>
	<!--	<div class="col-md-2">	<img id="nacoLogo" alt="National Association of Counties Logo" src="../img/NACoLogo_NoTagBLACK_tm.png" />		</div> -->
	
    <A HREF="cic_extraction_help.cfm"> CIC Extraction Tool Help</a> &nbsp;   &nbsp;   &nbsp; &nbsp;   &nbsp;<a href="cic_extraction_1.cfm">Return - Start a New Selection</a> 
    </div>
</div>
   <HR />
<DIV>     
 
      <CFOUTPUT><H2>#get_sub_category.cat_name# Indicators</H2></CFOUTPUT> 
			<H3><em>Choose up to TEN indicators</em></H3>
         <form class="extraction-form" action="cic_extraction_3.cfm" method="post">
            <select  id="sublist" name="SubCategory_List2" size="15" multiple>
              <CFOUTPUT query="get_sub_category">
              <option value="#Data_field#" >#sub_type# - #Sub_Cat#  <em>#units#</em> &nbsp; </option>
              </CFOUTPUT>
            </select>
            <CFOUTPUT>
            <input type="hidden" name="tablename1" value="#tablename1#" />
            <input type="hidden" name="SubCategory_List1" value="#SubCategory_List1#" />
            <input type="hidden" name="tablename2" value="#tablename2#" />
            <input type="hidden" name="Category_List" value="#Category_List#" />
            
            </CFOUTPUT>
      <div class="extraction-help-box">
      	<span class="extraction-help-text">Hold the CTRL key and click, to select multiple indicators.</span><input class="btn btn-info" type="submit"  value="Next...">
      </div>

        </form> 
        
 </DIV>       
</body>
</html>


