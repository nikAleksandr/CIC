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



        


<CFIF #get_data.recordcount# GT 4000>
<CFABORT>
<CFELSE>
DATA EXPORT!
        <cfsetting enablecfoutputonly="yes"> <!--- Required for CSV export to function properly --->
        <cfset delim = 44> <!--- comma --->
        
        <cfcontent type="text/csv">
        <cfheader name="Content-Disposition" value="attachment; filename=NACoData.csv">
        <cfoutput>
        FIPS  #chr(delim)# County  #chr(delim)# State #chr(delim)# Year #chr(delim)# <CFLOOP From="1" To = "#listLen(BigList)#" index="Counter">#exportfield[Counter]#  #chr(delim)# </CFLOOP></cfoutput>
        <cfoutput>#chr(13)#</cfoutput> <!--- line break --->
        
        <!--- Spill out data from a query --->
        <cfloop query="get_data">
            <cfoutput>#fips# #chr(delim)# #county_name# #chr(delim)# #state# #chr(delim)# #Data_Year# #chr(delim)#
            <CFLOOP From="1" To = "#listLen(BigList)#" index="Counter">#evaluate(exportfield[Counter])# #chr(delim)#</CFLOOP>
            </cfoutput>
            <cfoutput>#chr(13)#</cfoutput>
        </cfloop> 
</CFIF>

