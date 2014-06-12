<cfsetting showdebugoutput="no">
<cfheader name="Content-Type" value="application/json">


<CFPARAM name="db_set" default="">
<CFPARAM name="db_ind" default="">

<!--- Just In case more than one dataset (table) is passed if more than 2 Abort --->
<CFLOOP From="1" To = "#listLen(db_set)#" index="Counter">
<CFSET db_table[counter] = #trim(ListGetAt(db_set, Counter))#>
</CFLOOP> 



<CFIF #listLen(db_set)# EQ 1 >
		<cfquery name="get_data" datasource="naco_cic">
        select COUNTY_FIPS.FIPS, COUNTY_FIPS.State, COUNTY_FIPS.County_Name, #db_ind# 
        from COUNTY_FIPS
        JOIN  #db_table[1]# on   #db_table[1]#.Fips = COUNTY_FIPS.Fips
        </cfquery>
</CFIF> 

<CFIF #listLen(db_set)# EQ 2 >
		<cfquery name="get_data" datasource="naco_cic">
        select COUNTY_FIPS.FIPS, COUNTY_FIPS.State, COUNTY_FIPS.County_Name, #db_ind# 
        from 
        COUNTY_FIPS
         JOIN  #db_table[1]# on  #db_table[1]#.Fips = COUNTY_FIPS.Fips
         JOIN  #db_table[2]# on  #db_table[2]#.Fips = COUNTY_FIPS.Fips
         </cfquery>
</CFIF> 


<CFIF #listLen(db_set)# GT 2 >
		<cfabort>
</CFIF> 




<CFOUTPUT> 
#SerializeJSON(get_data, true)#
</CFOUTPUT>


