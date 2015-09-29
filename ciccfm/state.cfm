<!--- Listing of Counties for Selected State --->

<CFPARAM NAME="statecode" DEFAULT="">

        <CFQUERY NAME="getstate" datasource="naco_cic">
		SELECT *
		FROM States (NOLOCK)
		WHERE Statecode =  '#statecode#'
		</CFQUERY> 
			
		<CFQUERY NAME="getcounties" datasource="naco_cic">
		SELECT FIPS, County_Name, State, county_seat, Member_Status,  Org_Type,
		Population_2010, Population_2013, Total_Square_Miles, founded,  board_size, Gov_Type
		FROM  County_Data  (NOLOCK)
		WHERE State='#statecode#' and Org_Type in ('County', 'Independent City', 'County W/o Govt Structure', 'Geographical Census Area') 
		ORDER BY Org_Type, fips
		</CFQUERY> 
        
        
       
     

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>

<div id="responseContent" class="container-fluid">

 <CFOUTPUT QUERY="getstate" >
<div id="stateResponse-title" class="row">
	<h3>#getstate.StateName#</h3>
</div>

<div id="state-map-iframe">
		
		<CFLOOP QUERY="getstate">
		 <CFINCLUDE template="maps/#statecode#.cfm">
		</CFLOOP> 
		
		
		<CENTER>
		
		<CFOUTPUT>
		<img src="../ciccfm/images/#getstate.statecode#.gif" usemap="##map" ismap border="0" align="top">
		</CFOUTPUT>
</CENTER>
		<P>

<A HREF="../ciccfm/usamap_blue.cfm?websource=naco" >USA Map</A>
</div>
<!--<iframe title="Find a County" frameborder="0" id="state-map-iframe" width="100%" src="http://www.uscounties.org/cffiles_web/counties/statemap_blue.cfm?state=#statecode#">
					&lt;div class="UserGeneric"&gt;The current browser does not support Web pages that contain the IFRAME element. To use this Web Part, you must use a browser that supports this element, such as Internet Explorer 7.0 or later.&lt;/div&gt;
</iframe>-->

 </CFOUTPUT>



 
 <CFOUTPUT QUERY="getcounties" group="org_type">
    	
		
        <CFIF org_type EQ 'County'>
      	<div class="container-fluid">
        <TABLE id="stateResponse-table" class="table table-striped">
        <TR style="padding:10px 0; border-bottom:2px solid rgb(255,153,51);">
                <TH>
                    <CFIF #state# EQ 'LA'>PARISH</CFIF>
                    <CFIF #state# EQ 'AK'>BOROUGH</CFIF>
                    <CFIF #state# NEQ 'LA' AND #state# NEQ 'AK' >COUNTY</CFIF>
                </TH>
				<TH>2013 POPULATION</TH>
				<TH>SQUARE MILES</TH> 
				<TH>COUNTY SEAT</TH>
				<TH>BOARD SIZE</TH>
				<TH>FOUNDED</TH>
			</TR>
            <CFOUTPUT>
            <TR>
				<TD align="right"><a style="font-weight:bold; color:black;" id="#FIPS#" onClick="(CIC.findACounty) ? CIC.displayResults('county.cfm?id=' + CIC.fipsConversion('string', '#FIPS#')) : CIC.executeSearchMatch('#FIPS#')" >#County_Name#</a><CFIF Gov_Type EQ  "Consolidated">*</CFIF>
                </TD>
				<TD ALIGN="RIGHT"><CFIF #Population_2013# GT 0>#NumberFormat(Population_2013)#  <CFELSE><em>N/A</em></CFIF> </TD>
				<TD ALIGN="RIGHT"><CFIF #Total_Square_Miles# GT 0>#NumberFormat(Total_Square_Miles)#  <CFELSE><em>N/A</em></CFIF> </TD> 
				<TD ALIGN="right"> #county_seat#&nbsp; </TD> 
				<TD align="right"> #board_size#&nbsp;</TD> 
				<TD ALIGN="right">#founded#&nbsp;</TD>
				</TR>
            </CFOUTPUT>
         </TABLE>
       <br/>
         <DIV><em>* consolidated city-county government</em></DIV>
         </div>
         <div id="naco-website-feed-blank" class="container-fluid"></div>
       
          <CFELSE>
          
          		<div class="container-fluid">
				<TABLE class="table table-striped table-condensed">
                <TR><Th>#org_type#</TH>
                <TH align="right">2013 Population</TH>
                <TH align="right">Square Miles</TH></TR>
                    <CFOUTPUT>
                    <TR>
                    <TD>#County_Name#</TD>
                    <TD align="right"><CFIF #Population_2013# GT 0>#NumberFormat(Population_2013)#</CFIF></TD>
                    <TD align="right"><CFIF #Total_Square_Miles# GT 0>#NumberFormat(Total_Square_Miles)#</CFIF></TD></TR>
                    </CFOUTPUT>
                </TABLE>
                </div>
                <div id="naco-website-feed-blank" class="container-fluid"></div>

		</cfif>


</CFOUTPUT> 




</div>
</html>