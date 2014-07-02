<Cfparam name="States_List"  default="">
<Cfparam name="Year_List"  default="">
<CFPARAM name="tablename1" default="">
<Cfparam name="SubCategory_List1"  default="">
<CFPARAM name="tablename2" default="">
<Cfparam name="SubCategory_List2"  default="">
<CFPARAM name="BigList" default="">


<!--- CREATE ONE BIG LIST OF SUB-CATEGORIES --->
<CFIF listLen(#SubCategory_List2#) GT 0>
<CFSET BigList = ListAppend(#SubCategory_List1#,#SubCategory_List2#)>
<CFELSE>
<CFSET BigList = #SubCategory_List1#>
</CFIF>



<!--- CRERATE ARRAY OF FIELD NAMES --->
<CFLOOP From="1" To = "#listLen(BigList)#" index="Counter">
<CFSET exportfield[counter] = #trim(ListGetAt(BigList, Counter))#>
</CFLOOP>




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
           #tablename1#.FIPS = COUNTY_DATA.FIPS and
           #tablename2#.FIPS = COUNTY_DATA.FIPS 
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
			
			<H3><em>View your selections and download</em></H3>
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
<A HREF="cic_extraction_1.cfm">Start a new selection</A>
<CFELSE> 

            
            
           
            <CFOUTPUT>
            
            <strong>#get_data.recordCount#</strong> total records selected based on the following selections:
<table style="white-space:normal;" class="table extraction-table"></tbody>
            <tr><td>Category:</td><td>#tablename1#</td></tr>
            <tr><td>Indicators:</td><td>#SubCategory_List1#</td></tr>
            <CFIF #tablename2# NEQ "">
            	<tr><td>Category2:</td><td>#tablename2#</td></tr>
            	<tr><td>Indicators:</td><td>#SubCategory_List2#</td></tr>
            </CFIF>
            <tr><td>States:</td><td>#States_List#</td></tr>
            <tr><td>Years:</td><td>#Year_List#</td></tr>
            </CFOUTPUT>
</tbody></table>           
            <P>
            <A HREF="cic_extraction_1.cfm">Start a New Selection</A>
            <HR />
            <P>
            Expoort the data to an Excel File<P>

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

</body>
</html>