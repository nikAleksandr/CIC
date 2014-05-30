<!--- Listing of Counties for Selected State --->

<CFPARAM NAME="statecode" DEFAULT="">

        <CFQUERY NAME="getstate" datasource="naco_cic">
		SELECT *
		FROM States (NOLOCK)
		WHERE Statecode =  '#statecode#'
		</CFQUERY> 
			
		<CFQUERY NAME="getcounties" datasource="naco_cic">
		SELECT FIPS,   CountyName, State, countyseat, MemberStatus,  OrgType,
		Population2010, SquareMiles, founded,  boardsize, GovType
		FROM  County_Data  (NOLOCK)
		WHERE State='#statecode#' and OrgType in ('County', 'Independent City', 'County W/o Govt Structure', 'Geographical Census Area') 
		ORDER BY OrgType
		</CFQUERY> 
     

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Find a County</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body class="body">



<CFOUTPUT QUERY="getcounties" group="orgtype">
<strong>#getstate.StateName#</strong><P>

<CFIF orgtype NEQ 'County'>
               
                <TABLE WIDTH="75%" BORDER="1" cellspacing="0" cellpadding="0">
                <TR><TD>#orgtype#</TD>
                <TD align="right">2010 Population</TD>
                <TD align="right">Square Miles</TD></TR>
                    <CFOUTPUT>
                    <TR>
                    <TD>#CountyName#</TD>
                    <TD align="right">#NumberFormat(Population2010)#</TD><TD align="right">#NumberFormat(SquareMiles)#</TD></TR>
                    </CFOUTPUT>
                </TABLE>
               
 <CFELSE>
    			<TABLE WIDTH="95%" BORDER="1" cellspacing="0" cellpadding="2">
				<TR>
                    <TH>
                    <CFIF #state# EQ 'LA'>Parish</CFIF>
                    <CFIF #state# EQ 'AK'>Borough</CFIF>
                    <CFIF #state# NEQ 'LA' AND #state# NEQ 'AK' >County</CFIF>
                    </TH>
					<TH>NACo<BR>Member</TH>
					<TH>2010<BR>Population</a></TH>
					<TH>Square<BR>Miles</TH> 
					<TH>County Seat</TH>
					<TH>Board<BR>Size</TH>
					<TH>Founded</TH>
					</TR>
		
		      <CFOUTPUT>
				<TR>
				<TD><a href="http://www.uscounties.org/cffiles_web/counties/county.cfm?id=#FIPS#" >#CountyName#</a>
				 <CFIF GovType EQ  "Consolidated">*</CFIF>
                </TD>
				<TD ALIGN="CENTER"><CFIF MemberStatus EQ  'Active'><IMG SRC="images/check2.gif"><CFELSE>&nbsp;</CFIF></TD>
				<TD ALIGN="RIGHT"><CFIF Population2010 GT 0>#NumberFormat(Population2010)#<CFELSE><em>N/A</em></CFIF> </TD>
				<TD ALIGN="RIGHT"><CFIF SquareMiles GT 0>#NumberFormat(SquareMiles)#  <CFELSE><em>N/A</em></CFIF> </TD> 
				<TD ALIGN="LEFT"> #countyseat#&nbsp;</TD> 
				<TD align="right"> #boardsize#&nbsp;</TD> 
				<TD ALIGN="CENTER">#founded#&nbsp;</TD>
				</TR>
		     </CFOUTPUT>
				</TABLE> 
  
</CFIF>

</CFOUTPUT>





</body>
</html>