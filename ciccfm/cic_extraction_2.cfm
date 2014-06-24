<cfparam name="Category_List" default="">
<cfparam name="tablename1" default="">
<cfparam name="Category_List1" default="">
<cfparam name="Category_List2" default="">


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



<!--- Abort if no selection --->
<CFIF #Category_List# EQ "">
<strong>GO BACK - YOU DID NOT SELECT ANYTHING!</strong><CFABORT>
</CFIF>

<!--- Abort if more than two selectios --->
<CFOUTPUT>
		<CFIF #ListLen(Category_List)# GT 2>
        PLEASE LIMIT THE NUMBER OF CATEGORIES TO NO MORE THAN TWO. <P>
        <A HREF="cic_extraction_1.cfm">Return to Category Selections</a>.
        <CFABORT>
        </CFIF>
        <CFSET Category_List1=#trim(listGetAt(Category_List,1))#>
        <CFIF #ListLen(Category_List)# EQ 2><CFSET Category_List2=#trim(listGetAt(Category_List,2))#></CFIF>
</CFOUTPUT>



        <cfquery datasource="naco_cic" name="get_sub_category">
        select * from categories
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
         <form  action="cic_extraction_3.cfm" method="post">
            <select id="sublist" name="SubCategory_List1" size="15" multiple="multiple">
              <CFOUTPUT query="get_sub_category">
              <option value="#Data_field#" >#sub_type# - #Sub_Cat#  <em>#units#</em> &nbsp; </option>
              </CFOUTPUT>
            </select>
            <CFOUTPUT>
            <input type="hidden" name="tablename1" value="#tablename1#" />
            </CFOUTPUT>
            <input type="submit"  value="Next...">
        </form> 
<CFELSE>
         <form  action="cic_extraction_2b.cfm" method="post">
            <select id="sublist" name="SubCategory_List1" size="15" multiple="multiple">
              <CFOUTPUT query="get_sub_category">
              <option value="#Data_field#" >#sub_type# - #Sub_Cat# &nbsp;  #units#&nbsp; </option>
              </CFOUTPUT>
            </select>
            <CFOUTPUT>
            <input type="hidden" name="Category_List" value="#Category_List#" />
            <input type="hidden" name="tablename1" value="#tablename1#" />
            </CFOUTPUT>
            <input type="submit"  value="Next...">
        </form> 
 </CFIF>       
        <p>Select  the Indicators for <CFOUTPUT><strong>#Category_List1#</strong></CFOUTPUT></p>
        Hold <em>ctrl</em> key and click, to select multiple indicators.
        
        </body>
        </html>


