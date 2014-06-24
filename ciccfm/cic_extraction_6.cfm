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


<CFIF  #get_data.recordCount# EQ 0>
Your selection did not result in any data. Please try again.
<P>
<A HREF="cic_extraction_1.cfm">START A NEW SELECTION</A>
<CFELSE> 

            
            
           
            <CFOUTPUT>
            
            <strong>#get_data.recordCount#</strong> total records selected based on the following selections:
            <P>
            Category: #tablename1#<BR />
            Indicators: #SubCategory_List1#<BR />
            <CFIF #tablename2# NEQ "">Category: #tablename2#<BR /> Indicators: #SubCategory_List2#<BR /></CFIF>
            States - #States_List#<BR>
            Years - #Year_List#<P>
            </CFOUTPUT>
<P>           
            <P>
            <A HREF="cic_extraction_1.cfm">Start a New Selection</A>
            <HR />
            <P>
            Expoort the data to an Excel File<P>

<FORM action="cic_extraction_export.cfm">
<CFOUTPUT>
<input type="hidden" name="States_List" value="#States_List#" />
<input type="hidden" name="tablename1" value="#tablename1#" />
<input type="hidden" name="SubCategory_List1" value="#SubCategory_List1#" />
<input type="hidden" name="tablename2" value="#tablename2#" />
<input type="hidden" name="SubCategory_List2" value="#SubCategory_List2#" />
<input type="hidden" name="Year_List" value="#Year_List#" />
</CFOUTPUT>
<input type="submit"  value="DOWNLOAD DATA!" />
</FORM> 

</CFIF>

</body>
</html>