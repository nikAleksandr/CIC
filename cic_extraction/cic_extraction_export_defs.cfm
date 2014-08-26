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

<cfquery name="get_defs" datasource="naco_cic" >
select * from crosswalk
where data_field = '#exportfield[1]#'
<CFLOOP From="1" To = "#listLen(Biglist)#" index="Counter">
or data_field = '#exportfield[counter]#'
</CFLOOP>
order by cat_name
</cfquery> 

  

 <cfsetting enablecfoutputonly="yes"> 
        <cfset delim = 44> 
        
        <cfcontent type="text/csv">
        <cfheader name="Content-Disposition" value="attachment; filename=NACoDataDefinitions.csv">
      
       <cfoutput>
        Data Field #chr(delim)#  Category #chr(delim)#  Field Name  #chr(delim)#  Definition  #chr(delim)# 
       </cfoutput>
       
        <cfoutput>#chr(13)#</cfoutput>  <!--- line break --->
        
        <cfloop query="get_defs">
            <cfoutput>#Data_field# #chr(delim)# #cat_Name# #chr(delim)# #sub_cat#  #chr(delim)# #Definition# #chr(13)# </cfoutput>
            
        </cfloop> 


