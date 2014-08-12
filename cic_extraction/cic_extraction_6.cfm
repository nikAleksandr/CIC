<Cfparam name="States_List"  default="">
<Cfparam name="Year_List"  default="">
<CFPARAM name="tablename1" default="">
<Cfparam name="SubCategory_List1"  default="">
<CFPARAM name="tablename2" default="">
<Cfparam name="SubCategory_List2"  default="">
<CFPARAM name="BigList" default="">


<!--- CREATE ONE BIG LIST OF SUB-CATEGORIES --->
<CFIF listLen(#SubCategory_List2#)>
<CFSET BigList = ListAppend(#SubCategory_List1#,#SubCategory_List2#)>
<CFELSE>
<CFSET BigList = #SubCategory_List1#>
</CFIF>



<!--- CRERATE ARRAY OF ALL FIELD NAMES --->
<CFLOOP From="1" To = "#listLen(BigList)#" index="Counter">
<CFSET exportfield[counter] = #trim(ListGetAt(BigList, Counter))#>
</CFLOOP>



<!--- CREATE ARRAY OF TABLE1 FIELD NAMES --->
<CFLOOP From="1" To = "#listLen(SubCategory_List1)#" index="Counter">
<CFSET table1_fields[counter] = #trim(ListGetAt(SubCategory_List1, Counter))#>
</CFLOOP>

<!--- CREATE ARRAY OF TABLE2 FIELD NAMES --->
<CFIF listLen(#SubCategory_List2#) GT 0>
        <CFLOOP From="1" To = "#listLen(SubCategory_List2)#" index="Counter">
        <CFSET table2_fields[counter] = #trim(ListGetAt(SubCategory_List2, Counter))#>
        </CFLOOP>
</CFIF>




<!--- QUERY DATA ONE OR TWO CATEGORIES --->


<CFIF  #tablename1# EQ "COUNTY_DATA"  AND #tablename2#  EQ "">
 <cfquery name="get_data" datasource="naco_cic">
      select *    from COUNTY_DATA 
        where FIPS > 0
     <CFIF #States_List# NEQ "ALL"> and COUNTY_DATA.State in (#preservesinglequotes(States_List)#)</CFIF>
     </cfquery>
</CFIF>    


<CFIF  #tablename1#  EQ "COUNTY_DATA"  AND #tablename2#  NEQ "">
 <cfquery name="get_data" datasource="naco_cic">
      select * 
      from  #tablename1#, #tablename2#
      where  #tablename1#.FIPS = #tablename2#.FIPS 
     <CFIF #States_List# NEQ "ALL"> and COUNTY_DATA.State in (#preservesinglequotes(States_List)#)</CFIF>
     <CFIF #year_list# NEQ ""> and #tablename2#.DATA_YEAR in (#year_list#) </CFIF> 
    </cfquery>
</CFIF> 


<CFIF #tablename1# NEQ "COUNTY_DATA" AND #tablename2# EQ "">
    <cfquery name="get_data" datasource="naco_cic">
      select * 
      from #tablename1#, COUNTY_DATA
      where  #tablename1#.FIPS = COUNTY_DATA.FIPS 
     <CFIF #States_List# NEQ "ALL"> and COUNTY_DATA.State in (#preservesinglequotes(States_List)#)</CFIF>
     <CFIF #year_list# NEQ ""> and #tablename1#.DATA_YEAR in (#year_list#) </CFIF> 
    </cfquery>
</CFIF>


<CFIF #tablename1# NEQ "COUNTY_DATA" AND #tablename2# NEQ "" AND #tablename2# NEQ "COUNTY_DATA">
    <cfquery name="get_data" datasource="naco_cic">
      select * 
      from COUNTY_DATA, #tablename1#,  #tablename2# 
      where
           #tablename1#.FIPS = COUNTY_DATA.FIPS and   #tablename2#.FIPS = COUNTY_DATA.FIPS 
           AND #tablename1#.Data_year = #tablename2#.DATA_YEAR
     <CFIF #States_List# NEQ "ALL"> and COUNTY_DATA.State in (#preservesinglequotes(States_List)#)</CFIF>
     <CFIF #year_list# NEQ ""> and #tablename1#.DATA_YEAR in (#year_list#) </CFIF> 
    </cfquery>
</CFIF>    


<CFIF #tablename1# NEQ "COUNTY_DATA" AND #tablename2# EQ "COUNTY_DATA">
    <cfquery name="get_data" datasource="naco_cic">
      select * 
      from  #tablename1#,  #tablename2# 
      where
           #tablename1#.FIPS = #tablename2#.FIPS
     <CFIF #States_List# NEQ "ALL"> and COUNTY_DATA.State in (#preservesinglequotes(States_List)#)</CFIF>
     <CFIF #year_list# NEQ ""> and #tablename1#.DATA_YEAR in (#year_list#) </CFIF> 
    </cfquery>
</CFIF>




<!-- SELECT USER FRIENDLY CATEGORY AND INDICATOR NAMES -->

<cfquery name="get_uf1" datasource="naco_cic" >
select * from crosswalk
where Table_Name = '#tablename1#'  and data_field = '#table1_fields[1]#'
<CFLOOP From="1" To = "#listLen(SubCategory_List1)#" index="Counter">
or data_field = '#table1_fields[counter]#'
</CFLOOP>
order by cat_name
</cfquery>


<CFIF  #tablename2# NEQ "">
<cfquery name="get_uf2" datasource="naco_cic" >
select * from crosswalk
where Table_Name = '#tablename2#' and data_field = '#table2_fields[1]#'
<CFLOOP From="1" To = "#listLen(SubCategory_List2)#" index="Counter">
or data_field = '#table2_fields[counter]#'
</CFLOOP>
order by cat_name
</cfquery>



</CFIF>




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
		</div>
		<div class="col-md-2">
			<img id="nacoLogo" alt="National Association of Counties Logo" src="../img/NACoLogo_NoTagBLACK_tm.png" />
		</div>
	</div>
	<a href="http://cic.naco.org">Return to Interactive Map</a>
</div>


<CFIF  #get_data.recordCount# EQ 0>
Your selection did not result in any data. Please try again.
<P>
<A HREF="cic_extraction_1.cfm">Start a New Selection</A>
<CFELSE> 

            
          
            
            
            <P>
            <A HREF="cic_extraction_1.cfm">Start a New Selection</A>
            <P>
            Expoort the data to an Excel File<P>

			
			<H3><em>View your selections and download</em></H3>
<FORM class="extraction-form" action="cic_extraction_export.cfm">
<CFOUTPUT>
<input type="hidden" name="States_List" value="#States_List#" />
<input type="hidden" name="tablename1" value="#tablename1#" />
<input type="hidden" name="SubCategory_List1" value="#SubCategory_List1#" />
<input type="hidden" name="tablename2" value="#tablename2#" />
<input type="hidden" name="SubCategory_List2" value="#SubCategory_List2#" />
<input type="hidden" name="Year_List" value="#Year_List#" />
</CFOUTPUT>
<input class="btn btn-success" type="submit"  value="DOWNLOAD DATA!" />
</FORM> 
</CFIF>

<HR />

		 <CFOUTPUT>
             <strong>#get_data.recordCount#</strong> records selected based on the following selections:
             <BR />
             States: #States_List#<BR />
             Years: <CFIF #Year_List# EQ ""> <em>no years selected</em><CFELSE>#Year_List#</CFIF>
			</CFOUTPUT>
			


           <table style="white-space:normal;" class="table extraction-table">
            <CFOUTPUT query="get_uf1" group="Cat_Name" >
            <TR><TD colspan="2"><strong>#Cat_Name#</strong></TD></TR>
					<CFOUTPUT>
                    <TR valign="top"><TD width="30%"> &nbsp; #Sub_Cat#</TD><TD width="70%"><font size="-1">#definition#</font></TD></TR>
                    </CFOUTPUT>
            </CFOUTPUT>
            </table>
            
            
            <CFIF  #tablename2# NEQ "">
           
               <table style="white-space:normal;" class="table extraction-table">
            <CFOUTPUT query="get_uf2" group="Cat_Name" >
            <TR><TD colspan="2"><strong>#Cat_Name#</strong></TD></TR>
					<CFOUTPUT>
                    <TR valign="top"><TD width="30%"> &nbsp; #Sub_Cat#</TD><TD width="70%"><font size="-1">#definition#</font></TD></TR>
                    </CFOUTPUT>
            </CFOUTPUT>
            </table> 
           </CFIF>
            
   <P>         
            
            
			  


</body>
</html>