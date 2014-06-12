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
		ORDER BY Org_Type
		</CFQUERY> 
     

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>

<div id="responseContent" class="container-fluid">

<CFOUTPUT QUERY="getcounties" group="org_type">
<h2 style="text-align:left; padding-bottom:10px;">#getstate.StateName#</h2>

<CFIF org_type NEQ 'County'>
               
                <TABLE WIDTH="100%" BORDER="1" cellspacing="0" cellpadding="0">
                <TR><TD>#org_type#</TD>
                <TD align="right">2013 Population</TD>
                <TD align="right">Square Miles</TD></TR>
                    <CFOUTPUT>
                    <TR>
                    <TD>#County_Name#</TD>
                    <TD align="right">#NumberFormat(Population_2010)#</TD><TD align="right">#NumberFormat(Square_Miles)#</TD></TR>
                    </CFOUTPUT>
                </TABLE>
               
 <CFELSE>
    			<TABLE class="table table-striped table-condensed">
				<TR valign="bottom">
                    <TH align="left">
                    <CFIF #state# EQ 'LA'>Parish</CFIF>
                    <CFIF #state# EQ 'AK'>Borough</CFIF>
                    <CFIF #state# NEQ 'LA' AND #state# NEQ 'AK' >County</CFIF>
                    </TH>
					<TH>2013<BR>Population</a></TH>
					<TH>Square<BR>Miles</TH> 
					<TH>County Seat</TH>
					<TH>Board<BR>Size</TH>
					<TH>Founded</TH>
					</TR>
		
		     <CFOUTPUT>
				<TR>
				<TD><a id="#FIPS#" onClick="executeSearchMatch('#FIPS#')" >#County_Name#</a><CFIF Gov_Type EQ  "Consolidated">*</CFIF>
                </TD>
				<TD ALIGN="RIGHT"><CFIF Population_2013 GT 0>#NumberFormat(Population_2013)#<CFELSE><em>N/A</em></CFIF> </TD>
				<TD ALIGN="RIGHT"><CFIF Total_Square_Miles GT 0>#NumberFormat(Total_Square_Miles)#  <CFELSE><em>N/A</em></CFIF> </TD> 
				<TD ALIGN="LEFT"> #county_seat#&nbsp;</TD> 
				<TD align="right"> #board_size#&nbsp;</TD> 
				<TD ALIGN="CENTER">#founded#&nbsp;</TD>
				</TR>
		     </CFOUTPUT> 
				</TABLE> 
  
</CFIF> 

</CFOUTPUT> 

</div>
</html>