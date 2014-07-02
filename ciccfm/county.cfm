<!--- Information on a Selected County --->

<CFPARAM NAME="URL.id" DEFAULT="">

			
           <CFQUERY NAME="getcountydata" DATASOURCE="naco_cic">
           SELECT  FIPS, LEFT(fips,2) as StateFIPS, county_name, state, Org_Type, Founded, Board_Size, Gov_type,
           Population_2013, Member_Status, County_Seat, Total_Square_Miles, Population_1990, Population_1980, Population_2000, Population_2010, county_website
           FROM County_data
           WHERE FIPS=  '#URL.id#'
            </CFQUERY> 
                        

            <CFQUERY NAME="getEXEC" DATASOURCE="naco_cic">
            SELECT 
                PersonID, First_Name, Last_Name, Suffix, Title, fnctn_code,  elect_appntd, cnty_dist, state, fips
            FROM cic_county_officials
            WHERE FIPS = '#URL.id#'
              and elect_appntd='Elected' and fnctn_code = '151'
            ORDER BY fnctn_code,  Last_Name
            </CFQUERY> 

            <CFQUERY NAME="getofficials" DATASOURCE="naco_cic">
            SELECT 
                PersonID, First_Name, Last_Name, Suffix, Title, fnctn_code, state,  elect_appntd, cnty_dist,  fips
            FROM cic_county_officials
            WHERE FIPS = '#URL.id#'
              and elect_appntd='Elected' and fnctn_code <> '151'
              and  ((fnctn_code <> '253')  OR (fnctn_code = '253' and State='SC'))
            ORDER BY fnctn_code,  Last_Name
            </CFQUERY> 
            
  
<CFSET PersonsPerSqMile =    #getcountydata.Population_2013# /   #getcountydata.Total_Square_Miles#>    
            
			
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>


<div id="responseContent" class="container-fluid">
<CFOUTPUT query="getcountydata">

<div id="countyResponse-title" class="row">
    <div class="col-md-12">
    	<H3>#county_name#, #state#</H3>
	</div>
</div>


<CFIF #Member_Status# EQ "Active">   
	<div id="countyResponse-memberRow" class="row">
		<div id="countyResponse-nacoMember" class="col-md-12">
			<h4>NACo Member County</h4>
		</div>
	</div>   
</CFIF>



<div id="countyResponse-basicInfoRow" class="row">
    <div id="countyResponse-countyDetails" class="col-md-6">
        <h4>County Details</h4>
        <table class="table table-condensed" >
        	<tr><td align="right">Website:&nbsp;</td><td><A HREF="#County_Website#" target="_blank">#County_Website#</A></td></tr>
        	<tr><td align="right">County Seat:&nbsp; </td><td>#County_Seat#</td></tr>
        	<tr><td align="right">Year Organized:&nbsp;</td><td>#Founded#</td></tr>
        	<tr><td align="right">Land Square Miles:&nbsp;</td><td>#Total_Square_Miles#</td></tr>
        	<tr><TD align="right">2013 Population:&nbsp;</TD><TD>#NumberFormat(Population_2013, "999,999,999,999")#</TD></tr>
            <tr><td align="right">Persons/Square Mile:&nbsp;</td><td>#NumberFormat(PersonsPerSqMile, "999,999,999.99")#</td></tr>
        	<tr><td align="right">Size of Board:&nbsp;</td><td>#Board_Size#</td></tr>
        </table>
    </div>
    
    <div class="col-md-6">
        <div id="countyResponse-populations">
        	<h4>County Population</h4>
	        <table class="table table-condensed table-striped">
	        	<tr>
	        		<th>1980</th>
	        		<th>1990</th>
	        		<th>2000</th>
	        		<th>2010</th>
                    <th>2013</th>
	        	</tr>
                
	        	<tr>
	        		<td>#NumberFormat(Population_1980, "999,999,999,999")#</td>
	        		<td>#NumberFormat(Population_1990, "999,999,999,999")#</td>
	        		<td>#NumberFormat(Population_2000, "999,999,999,999")#</td>
                    <td>#NumberFormat(Population_2010, "999,999,999,999")#</td>
	        		<td>#NumberFormat(Population_2013, "999,999,999,999")#</td>
	        	</tr>
	        </table>
		</div>
		<div id="countyResponse-quickLinks" class="hidden-print">
	        <h4>Quick Links</h4>
	        <ul>
	        	<li><A HREF="http://quickfacts.census.gov/qfd/states/#StateFIPS#/#fips#.html" target="_blank" title="U.S. Census Bureau: State and County QuickFacts">Census Quick Facts</A></li>
	        	<li><A HREF="http://www.fedstats.gov/qf/states/#StateFIPS#/#fips#.html" target="_blank" title="Fedstats provides access to the full range of official statistical information produced by the Federal Government">Fed Stats</A></li>
	        	<li><A HREF="http://maps.google.com/maps?q=#county_Name#,#State#" target="_blank" title="View Google Map of County">Google Map View</A></li>
	        </ul>
	    </div>
    </div>  
</div>

</CFOUTPUT>

<CFIF getcountydata.Org_Type EQ "County" OR  getcountydata.Org_Type EQ "Independent City"> 
<div id="countyResponse-electedOfficials" class="row">	
	<h4>Elected Officials</strong></h4>
	<Table class="table table-condensed table-striped">
		<CFOUTPUT QUERY="getEXEC">
		<TR><TD>#First_name# #Last_Name# #Suffix#</TD><TD>#title#</TD></TR>
		</CFOUTPUT>
		<CFOUTPUT QUERY="getofficials">
		<TR>
		<TD style="width:50%; text-align:right;">#First_name# #Last_Name# #Suffix# &nbsp;  </TD>
		<CFIF cnty_dist GT 0 and fnctn_code EQ "103" >
		<CFIF state EQ 'TX'><TD style="text-align:left;">#title#, Precinct #cnty_Dist#</TD><br>
		<CFELSE><TD style="text-align:left;">#title#, District #cnty_Dist#</TD>
		</CFIF>		
		<CFELSE><TD style="width: 50%; text-align:left;">#title#</TD>
		</CFIF>
		</TR>
		</CFOUTPUT>
	</Table>
	<CFELSE>
<CFOUTPUT query="getcountydata">#county_name# Has No Form Of County Government</cfoutput> 
</CFIF>
</div>			
			

</div> 


</html>