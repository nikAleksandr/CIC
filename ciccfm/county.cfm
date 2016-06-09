<!--- Information on a Selected County --->

<CFPARAM NAME="URL.id" DEFAULT="">

            
           <CFQUERY NAME="getcountydata" DATASOURCE="naco_cic">
           SELECT FIPS, LEFT(fips,2) as StateFIPS, county_name, state, Org_Type, Founded, Board_Size, Gov_type,
           Population_2013, Member_Status, County_Seat, Total_Square_Miles, Population_1990, Population_1980,                     Population_2000, Population_2010, county_website, Population_2015,
           Address1, Address2, AddressCity, AddressState, AddressZip, AddressPhone
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
    <div class="col-md-9">
        <div class="col-sm-2" style="padding:0"><a onClick="CIC.executeSearchMatch(#FIPS#)"><img width="45px" height="45px" style="width:45px; height:45px; margin:7px;" src="img/showOnMap.svg" alt="data"></a></div>
        <div class="col-sm-10"><H3>#county_name#, #state#</H3></div>
    </div>
    <CFIF #Member_Status# EQ "Active">
    <div class="col-md-3" id="countyResponse-memberBadge">   
            <h4>NACo Member</h4>
    </div>
    </CFIF>
</div>


<div id="countyResponse-basicInfoRow" class="row">
    
    <div id="countyResponse-populations" class="col-md-9 hidden-xs">
        <div >
            <h4><img class="svgCircle" src="/img/population.svg"/>COUNTY POPULATION</h4>
            <table class="table">
                <tr>
                    <th>1980</th>
                    <th>1990</th>
                    <th>2000</th>
                    <th>2010</th>
                    <th>2015</th>
                </tr>
                
                <tr>
                    <td>#NumberFormat(Population_1980, "999,999,999,999")#</td>
                    <td>#NumberFormat(Population_1990, "999,999,999,999")#</td>
                    <td>#NumberFormat(Population_2000, "999,999,999,999")#</td>
                    <td>#NumberFormat(Population_2010, "999,999,999,999")#</td>
                    <td>#NumberFormat(Population_2015, "999,999,999,999")#</td>
                </tr>
            </table>
        </div>
    </div> 
    <div id="countyResponse-quickLinks" class="col-md-3 hidden-xs">
        <div id="hidden-print">
            <h4 style="margin-bottom:8px;"><img class="svgCircle" src="/img/quickLinks.svg"/>QUICK LINKS</h4>
            <ul>
                <li style="margin-bottom:8px;"><A HREF="http://quickfacts.census.gov/qfd/states/#StateFIPS#/#fips#.html" target="_blank" title="U.S. Census Bureau: State and County QuickFacts">Census Quick Facts</A></li>
                <li><A HREF="http://maps.google.com/maps?q=#county_Name#,#State#" target="_blank" title="View Google Map of County">Google Map View</A></li>
            </ul>
        </div>
    </div> 
</div>


<div id="countyResponse-electedOfficials" class="row">  
    <div id="countyResponse-countyDetails" class="col-md-6">
        <h4><img class="svgCircle" src="/img/countyDetails.svg"/>COUNTY DETAILS</h4>
        <table class="table table-condensed" >
            <tr><th align="right">Website:&nbsp;</td><td><A HREF="#County_Website#" target="_blank">#County_Website#</A></td></tr>
            <tr><th align="right">County Seat:&nbsp; </td><td>#County_Seat#</td></tr>
            <tr><th align="right">Year Organized:&nbsp;</td><td>#Founded#</td></tr>
            <tr><th align="right">Total Square Miles:&nbsp;</td><td>#Total_Square_Miles#</td></tr>
            <tr><Th align="right">2015 Population:&nbsp;</TD><TD>#NumberFormat(Population_2015, "999,999,999,999")#</TD></tr>
            <tr><th align="right">Persons/Square Mile:&nbsp;</td><td>#NumberFormat(PersonsPerSqMile, "999,999,999.99")#</td></tr>
            <tr><th align="right">Size of Board:&nbsp;</td><td>#Board_Size#</td></tr>
        </table>

        <h4><img class="svgCircle" src="/img/electedOfficials.svg"/>COUNTY CONTACT</h4>
        <table class="table table-condensed" style="width:303px">
            <tr><th align="right">Phone:</th><td>#AddressPhone#</td></tr>
            <tr><th align="right">Address:</th><td>#Address1#</td></tr>
            <tr><th style="border-top:none;"></th><td style="border-top:none;">#Address2#</td></tr>
            <tr><th style="border-top:none;"></th><td style="border-top:none;">#AddressCity#, #AddressState#</td></tr>
            <tr><th style="border-top:none;"></th><td style="border-top:none;">#AddressZip#</td></tr>
        </table>
    </div>
</CFOUTPUT>
<CFIF getcountydata.Org_Type EQ "County" OR  getcountydata.Org_Type EQ "Independent City">
    <div id="countyResponse-electedOfficials" class="col-md-6">
        <h4><img class="svgCircle" src="/img/electedOfficials.svg"/>ELECTED OFFICIALS</strong></h4>
        <Table class="table table-condensed table-striped">
            <CFOUTPUT QUERY="getEXEC">
            <TR><Th>#First_name# #Last_Name# #Suffix#</TD><TD>#title#</TD></TR>
            </CFOUTPUT>
            <CFOUTPUT QUERY="getofficials">
            <TR>
            <Th style="width:50%; text-align:right;">#First_name# #Last_Name# #Suffix# &nbsp;  </TD>
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
            

</div> 


</html>