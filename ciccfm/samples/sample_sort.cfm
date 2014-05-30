<!--- Population Search --->
<cfparam name="search_by_pop" default="">
<cfparam name="search_by_state" default="">
<cfparam name="OrderbyPop" default="">
<cfparam name="OrderbyState" default="">
<cfparam name="AD" default="">
<cfparam name="PAD" default="">  <!--- Population --->
<cfparam name="UAD" default="">  <!--- US COMM Savings --->
<cfparam name="RAD" default="">  <!--- RX SAvings --->
<cfparam name="CAD" default="">  <!---County Name --->
<cfparam name="SAD" default="">  <!--- STATE  --->
<cfparam name="LCAD" default="">   <!---  Leg Conf --->
<cfparam name="ACAD" default="">   <!---  Ann Conf --->
<cfparam name="CMAD" default="">   <!---  Comm Members --->
<cfparam name="NMAD" default="">   <!---  NACo Member--->


<!--- Order by Population Column--->
<CFIF #PAD# EQ "" OR #PAD# EQ "D"  >
   <CFSET OrderbyPop = "Population2010 DESC">
   <CFSET OrderbyState = "Population2010 DESC">
</CFIF> 

<CFIF #PAD# EQ "A" >
   <CFSET OrderbyPop = "Population2010">
   <CFSET OrderbyState = "Population2010">
</CFIF> 



<!--- Order by County Name --->

<CFIF  #CAD# EQ "D"  >
   <CFSET OrderbyPop = "countynameshort DESC">
   <CFSET OrderbyState = "countynameshort DESC">
</CFIF> 

<CFIF #CAD# EQ "A" >
   <CFSET OrderbyPop = "countynameshort">
    <CFSET OrderbyState = "countynameshort">
</CFIF>



<!--- Order by State then County Name --->

<CFIF  #SAD# EQ "D"  >
   <CFSET OrderbyPop = "State DESC, countynameshort ">
   <CFSET OrderbyState = "State DESC, countynameshort ">
</CFIF> 

<CFIF #SAD# EQ "A" >
   <CFSET OrderbyPop = "state, countynameshort">
    <CFSET OrderbyState = "state, countynameshort">
</CFIF>



<!--- Order by US COMM SVGS --->

<CFIF  #UAD# EQ "D"  >
   <CFSET OrderbyPop = "USCSVG_2013 DESC">
   <CFSET OrderbyState = "USCSVG_2013 DESC">
</CFIF> 

<CFIF #UAD# EQ "A" >
   <CFSET OrderbyPop = "USCSVG_2013">
    <CFSET OrderbyState = "USCSVG_2013">
</CFIF> 



<!--- Order by rX SVGS --->

<CFIF #RAD# EQ "D"  >
   <CFSET OrderbyPop = "pdcp_svgs DESC">
   <CFSET OrderbyState = "pdcp_svgs DESC">
</CFIF> 

<CFIF #RAD# EQ "A" >
   <CFSET OrderbyPop = "pdcp_svgs">
   <CFSET OrderbyState = "pdcp_svgs">
</CFIF> 


<!--- Order by NACo Member --->
<CFIF #NMAD# EQ "D"  >
   <CFSET OrderbyPop = "MemberStatus DESC, state, countynameshort">
   <CFSET OrderbyState = "MemberStatus DESC, state, countynameshort">
</CFIF> 

<CFIF #NMAD# EQ "A" >
   <CFSET OrderbyPop = "MemberStatus, state, countynameshort">
   <CFSET OrderbyState = "MemberStatus, state, countynameshort">
</CFIF> 



<!--- Order by Leg Conf --->

<CFIF #LCAD# EQ "D"  >
   <CFSET OrderbyPop = "LEG2014_Attendees DESC">
   <CFSET OrderbyState = "LEG2014_Attendees DESC">
</CFIF> 

<CFIF #LCAD# EQ "A" >
   <CFSET OrderbyPop = "LEG2014_Attendees">
   <CFSET OrderbyState = "LEG2014_Attendees">
</CFIF> 




<!--- Order by Annual Conf --->

<CFIF #ACAD# EQ "D"  >
   <CFSET OrderbyPop = "ANN2013_Attendees DESC">
   <CFSET OrderbyState = "ANN2013_Attendees DESC">
</CFIF> 

<CFIF #ACAD# EQ "A" >
   <CFSET OrderbyPop = "ANN2013_Attendees">
   <CFSET OrderbyState = "ANN2013_Attendees">
</CFIF> 


<!--- Order by Committee Members --->

<CFIF #CMAD# EQ "D"  >
   <CFSET OrderbyPop = "committee_members DESC">
   <CFSET OrderbyState = "committee_members DESC">
</CFIF> 

<CFIF #CMAD# EQ "A" >
   <CFSET OrderbyPop = "committee_members">
   <CFSET OrderbyState = "committee_members">
</CFIF> 




<!--- ------------------------------ --->


<CFIF #OrderbyState# EQ "">
<CFSET OrderbyState = "countynameshort ASC">
</CFIF> 


<!---Initial Search --->
<CFIF #search_by_pop# EQ "" AND #search_by_state# EQ "">
<CFSET search_by_pop = "Population2010 >= 1000000">
</CFIF>




<!---<CFOUTPUT>
Search By Pop: #search_by_pop#<BR>
Search By State: #search_by_state#<BR>
Order By Pop: #OrderbyPop#<BR>
Order By State: #OrderByState#<BR>
AD: #AD#
</CFOUTPUT> --->


<CFQUERY NAME="get_states" DATASOURCE="naco_data">
SELECT Code, Name
FROM STATES
WHERE CountryCode = 'USA'
ORDER BY Name
</CFQUERY>



<!---Population Search --->

<CFIF #search_by_pop# NEQ "">
    <CFQUERY NAME="getdata" DATASOURCE="naco_data">
 SELECT org_cst_key, FIPS, CompanyID, OrgType, MemberStatus, State, company, countynameshort,
 Population2010, Dues, Participating_County, dental_discount_participant, PILT_FY_2013,  SCAAP_2013, LUCC, USCSVG_2013, LEG2014_Attendees, ANN2013_Attendees,  committee_members,  pdcp_svgs
FROM client_naco_AMS_MAST
    WHERE  #search_by_pop# and OrgType = 'County'
     ORDER BY #OrderbyPop#
    </CFQUERY>
</CFIF>

<CFIF #PAD# EQ ""><CFSET PAD="A"></CFIF>
<CFIF #PAD# EQ "A"><CFSET PAD="D"><CFELSE><CFSET PAD="A"></CFIF>

<CFIF #UAD# EQ ""><CFSET UAD="A"></CFIF>
<CFIF #UAD# EQ "A"><CFSET UAD="D"><CFELSE><CFSET UAD="A"></CFIF>

<CFIF #RAD# EQ ""><CFSET RAD="A"></CFIF>
<CFIF #RAD# EQ "A"><CFSET RAD="D"><CFELSE><CFSET RAD="A"></CFIF>

<CFIF #LCAD# EQ ""><CFSET LCAD="A"></CFIF>
<CFIF #LCAD# EQ "A"><CFSET LCAD="D"><CFELSE><CFSET LCAD="A"></CFIF>

<CFIF #ACAD# EQ ""><CFSET ACAD="A"></CFIF>
<CFIF #ACAD# EQ "A"><CFSET ACAD="D"><CFELSE><CFSET ACAD="A"></CFIF>

<CFIF #CMAD# EQ ""><CFSET CMAD="A"></CFIF>
<CFIF #CMAD# EQ "A"><CFSET CMAD="D"><CFELSE><CFSET CMAD="A"></CFIF>

<CFIF #NMAD# EQ ""><CFSET NMAD="A"></CFIF>
<CFIF #NMAD# EQ "A"><CFSET NMAD="D"><CFELSE><CFSET NMAD="A"></CFIF>

<CFIF #CAD# EQ ""><CFSET CAD="D"></CFIF>
<CFIF #CAD# EQ "D"><CFSET CAD="A"><CFELSE><CFSET CAD="D"></CFIF>

<CFIF #SAD# EQ ""><CFSET SAD="D"></CFIF>
<CFIF #SAD# EQ "D"><CFSET SAD="A"><CFELSE><CFSET SAD="D"></CFIF>


    
<!---State Search --->    
    
<CFIF #search_by_state# NEQ "">
    <CFQUERY NAME="getdata" DATASOURCE="naco_data">
    SELECT org_cst_key, FIPS, CompanyID, OrgType, MemberStatus,State, company,countynameshort,
 Population2010, Dues, Participating_County, dental_discount_participant, PILT_FY_2013,
 SCAAP_2013, LUCC , USCSVG_2013, LEG2014_Attendees, ANN2013_Attendees,  committee_members,  pdcp_svgs
FROM client_naco_AMS_MAST 
    WHERE  state = '#search_by_state#' and OrgType = 'County'
     ORDER BY #OrderbyState# 
     </CFQUERY>
</CFIF>


<!--- Initial Display no search/no select --->
<CFIF #search_by_pop# EQ "" and #search_by_state# EQ "">
    <CFQUERY NAME="getdata" DATASOURCE="naco_data">
    SELECT org_cst_key, FIPS, CompanyID, OrgType, MemberStatus,State, company,countynameshort,
 Population2010, Dues, Participating_County, dental_discount_participant, PILT_FY_2013,
 SCAAP_2013, LUCC , USCSVG_2013, LEG2014_Attendees, ANN2013_Attendees,  committee_members,  pdcp_svgs
FROM client_naco_AMS_MAST 
    WHERE  Population2010 >= 1000000 and OrgType = 'County'
     ORDER BY Population2010 DESC
     </CFQUERY>
</CFIF>




<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>NACo County Data</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link href="../../naco_default.css" rel="stylesheet" type="text/css">




</head>
<body class="body">
<P>
<TABLE width="80%" cellpadding="0" cellspacing="0" border="0" align="center" >
<TR><TD>



<P></P>

<FORM ACTION="county_data.cfm" METHOD="POST">
	<TABLE  width="100%"align="center" border="0"  cellpadding="7" cellspacing="5">
	<tr>
	<TD  align="left" width="50%"  >
		<strong><font color="#666699">Select Counties By Population Ranges </font></strong><BR>
		<SELECT NAME="search_by_pop" SIZE="1">
          <Option value="" > ... Select a Range</Option>
          
		  <option value="Population2010 >= 1000000"> 1 million +
		  <option value="Population2010 >= 500000 and Population2010 < 999999"> 500K - 1 million
		  <option value="Population2010 >= 250000 and Population2010 < 499999"> 250K - 500K
		  <option value="Population2010 >= 100000 and Population2010 < 249999"> 100K - 250K
		  <option value="Population2010 >= 50000 and Population2010 < 99999"> 50K - 100K
		  <option value="Population2010 >= 25000 and Population2010 < 49999"> 25K - 50K
		  <option value="Population2010 < 25000"> 25K and below
          
          <option value="Population2010 >= 0"> ---  ALL 3,069 Counties
		</SELECT>
        <INPUT TYPE="Submit" VALUE="Search">
		</TD>
	
		<TD  width="50%"  >
		 <strong><font color="#666699">Select Counties By State </font></strong><BR>
		<SELECT NAME="search_by_state" SIZE="1">
          <Option value=""> ... Select a State</Option>
          <CFOUTPUT query="get_states">
		  <option value="#code#"> #code# -  #name#          </option>
          </CFOUTPUT>
		</SELECT>
        
        <INPUT TYPE="Submit" VALUE="Search"> 
		</TD>
        </TR>
	
		</TABLE>
</FORM>
<P>



            <TABLE BORDER="1" cellspacing="0" cellpadding="1" width="100%">
            <CFOUTPUT>
            <TR BGCOLOR="##666699" valign="bottom">
            <Td width="4%" align="center"><strong><A HREF="county_data.cfm?SAD=#SAD#&search_by_pop=#search_by_pop#&search_by_state=#search_by_state#" title="Sort by State"><FONT color="##CCCCCC">State</font></A></strong></Td>
            <Td width="10%">
            <strong><A HREF="county_data.cfm?CAD=#CAD#&search_by_pop=#search_by_pop#&search_by_state=#search_by_state#" title="Sort by County Name"><FONT color="##CCCCCC">County</font></A></strong></Td>
            <Td align="center" width="5%">
            <strong><A HREF="county_data.cfm?NMAD=#NMAD#&search_by_pop=#search_by_pop#&search_by_state=#search_by_state#" title="Sort by Member Status"><FONT color="##CCCCCC">NACo<BR>Member</FONT></A></strong></Td>
            
            <TD align="center"><FONT color="##CCCCCC">MAP</FONT></TD>
            <Td width="7%" align="right">
            <strong><A HREF="county_data.cfm?PAD=#PAD#&search_by_pop=#search_by_pop#&search_by_state=#search_by_state#" title="Sort by Population"><FONT color="##CCCCCC">2010<BR>Population</font></A></strong>
            </Td>
            
            <Td align="center" width="5%"><strong><FONT color="##CCCCCC">LUCC<BR>or RAC</font></strong></Td>
            
            <Td valign="15%" align="right"><strong>
            <A HREF="county_data.cfm?UAD=#UAD#&search_by_pop=#search_by_pop#&search_by_state=#search_by_state#" title="Sort by Savings"><FONT color="##CCCCCC">2013<BR>US Communities<BR>Savings</font></A>
            </strong>
            </TD>
            
            <Td><strong><FONT color="##CCCCCC">NRS</font></strong></Td>
            
            <Td><strong><FONT color="##CCCCCC">Current<BR>Rx Program<BR>Participatant</font></strong></Td> 
            
            <Td align="right"><strong><A HREF="county_data.cfm?RAD=#RAD#&search_by_pop=#search_by_pop#&search_by_state=#search_by_state#" title="Sort by Rx Savings"><FONT color="##CCCCCC">Rx Savings</font></A></strong></Td>
            <Td>
            <strong><FONT color="##CCCCCC">Dental<BR>Program</font></strong></Td>
            <Td>
            <strong><A HREF="county_data.cfm?LCAD=#LCAD#&search_by_pop=#search_by_pop#&search_by_state=#search_by_state#" title="Sort by No. of Attendees"><FONT color="##CCCCCC">2014 Leg<BR>Conference<BR>Attendees</font></A></strong></td>
            <Td><strong><A HREF="county_data.cfm?ACAD=#ACAD#&search_by_pop=#search_by_pop#&search_by_state=#search_by_state#" title="Sort by No. of Attendees"><FONT color="##CCCCCC">2013 Annual<BR>Conference<BR>Attendees</font></A></strong></Td>
            <Td><strong><A HREF="county_data.cfm?CMAD=#CMAD#&search_by_pop=#search_by_pop#&search_by_state=#search_by_state#" title="Sort by No. of Members"><FONT color="##CCCCCC">Committee<BR>Members</font></A></strong></Td>
            
            </TR>
            </CFOUTPUT>
          
                <CFOUTPUT QUERY="getdata" >
                <TR>
                <TD ALIGN="CENTER">#state#</TD>
                <TD><A HREF="https://www.uscounties.org/cffiles/naco_data/county_template_new.cfm?key=#org_cst_key#&id=#FIPS#">#countynameshort#</A></TD>
                <TD  align="center"><CFIF #MemberStatus# EQ "Active">X<CFELSE>&nbsp;</CFIF></TD>
                <TD align="center"><A HREF="http://maps.google.com/maps?q=#company#,#state#" target="_blank"><img src="gm.jpg"></A></TD>
                <TD Align="RIGHT">#NumberFormat(Population2010)#</TD>
                
                <TD align="left"> 
				<CFIF #LUCC# EQ 'LUC' AND  #MemberSTatus# EQ "Active">&nbsp;  LUCC<CFELSE>&nbsp;</CFIF>
                <CFIF #Population2010# LT 200000 AND  #MemberSTatus# EQ "Active">&nbsp;  RAC<CFELSE>&nbsp;</CFIF>
                </TD>
                <TD align="right">#NumberFormat(USCSVG_2013, "$999,999,999,999")#</TD>
                <TD align="center"><em>?</em></TD>
                <TD align="center"><CFIF #Participating_County# EQ "YES">X<CFELSE>&nbsp;</CFIF></TD>
                <TD align="right">#NumberFormat(pdcp_svgs,"$999,999,999,999")# </TD>
                <TD align="center"><CFIF #dental_discount_participant# EQ "1">X<CFELSE>&nbsp;</CFIF></TD>
                <TD align="center">#LEG2014_Attendees#</TD>
                <TD align="center">#ANN2013_Attendees#</TD>
                <TD align="center">#committee_members#</Td>
            
                </TR>
                </CFOUTPUT> 
            
            <P>
            </TABLE> 




</TD></TR></TABLE>



</body>
</html>	

