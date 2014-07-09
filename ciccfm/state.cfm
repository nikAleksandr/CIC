<!--- Listing of Counties for Selected State --->

<CFPARAM NAME="statecode" DEFAULT="">

        <CFQUERY NAME="getstate" datasource="naco_cic">
		SELECT *
		FROM States (NOLOCK)
		WHERE Statecode =  '#statecode#'
		</CFQUERY> 
			
		<CFQUERY NAME="getcounties" datasource="naco_cic">
		SELECT FIPS,   County_Name, State, county_seat, Member_Status,  Org_Type,
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
 </CFOUTPUT>



 
 <CFOUTPUT QUERY="getcounties" group="org_type">
    	
		
        <CFIF org_type EQ 'County'>
       
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
				<TD align="right"><a style="font-weight:bold; color:black;" id="#FIPS#" onClick="executeSearchMatch('#FIPS#')" >#County_Name#</a><CFIF Gov_Type EQ  "Consolidated">*</CFIF>
                </TD>
				<TD ALIGN="RIGHT"><CFIF #Population_2013# GT 0>#NumberFormat(Population_2013)#  <CFELSE><em>N/A</em></CFIF> </TD>
				<TD ALIGN="RIGHT"><CFIF #Total_Square_Miles# GT 0>#NumberFormat(Total_Square_Miles)#  <CFELSE><em>N/A</em></CFIF> </TD> 
				<TD ALIGN="right"> #county_seat#&nbsp; </TD> 
				<TD align="right"> #board_size#&nbsp;</TD> 
				<TD ALIGN="right">#founded#&nbsp;</TD>
				</TR>
            </CFOUTPUT>
         </TABLE>
       
         <DIV><em>* consolidated city-county government</em></DIV> 
       
          <CFELSE>
          
          <P>
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

		</cfif>


</CFOUTPUT> 




</div>
</html>