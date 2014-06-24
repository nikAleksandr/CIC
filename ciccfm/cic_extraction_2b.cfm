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
<strong>GO BACK, YOU DID NOT SELECT ANY INDICATORS for <CFOUTPUT>#Category_List1#</CFOUTPUT> !</strong>
<CFABORT>
</CFIF>

        <cfquery datasource="naco_cic" name="get_sub_category">
        select * from categories
        where cat_name = '#Category_List2#' and sub_cat is not null
        order by sub_type
        </cfquery>

	    <CFSET tablename2 = #get_sub_category.table_name#>

        
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
        
        <!-- start of second tab -->
        
       <CFOUTPUT><H2>#Category_List2# Indicators</H2></CFOUTPUT> 
        

         <form  action="cic_extraction_3.cfm" method="post">
            <select id="sublist" name="SubCategory_List2" size="15" multiple="multiple">
              <CFOUTPUT query="get_sub_category">
              <option value="#Data_field#" >#sub_type# - #Sub_Cat#  <em>#units#</em> &nbsp; </option>
              </CFOUTPUT>
            </select>
            <CFOUTPUT>
            <input type="hidden" name="tablename1" value="#tablename1#" />
            <input type="hidden" name="SubCategory_List1" value="#SubCategory_List1#" />
            <input type="hidden" name="tablename2" value="#tablename2#" />
            </CFOUTPUT>
            <input type="submit"  value="Next...">
        </form> 
        
         <p>Select  the Indicators for <CFOUTPUT><strong>#Category_List2#</strong></CFOUTPUT></p>
        Hold <em>ctrl</em> key and click, to select multiple indicators.
        
        </body>
        </html>


