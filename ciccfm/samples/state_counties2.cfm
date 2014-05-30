<CFPARAM name="getstate" default="">

<cfparam name="search_by_state" default="">
<cfparam name="OrderBy" default="">
<cfparam name="PAD" default=""> 


<!--- Order by Population Column--->
<CFIF #PAD# EQ "D"  >
   <CFSET OrderBy = "Population2010 DESC">
</CFIF> 

<CFIF #PAD# EQ "A" >
   <CFSET Orderby = "Population2010">
</CFIF> 

<!--- ------------------------------ --->
<CFIF #OrderBy# EQ "">
<CFSET OrderBy = "company">
</CFIF>



<cfquery name="getstates" datasource="naco_cic">
select * from states
order by statename
</cfquery>


        <cfquery datasource="naco_cic" name="getcounties">
        Select *
         from County_data
        where 
         state = '#getstate#'
        order by #orderby#
        </cfquery> 


 
<CFIF #PAD# EQ ""><CFSET PAD="A"></CFIF>
<CFIF #PAD# EQ "A"><CFSET PAD="D"><CFELSE><CFSET PAD="A"></CFIF>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body leftmargin="50" >

<TABLE width="100%"><TR><TD>
<H1>NACo County Intelligence Connection (CIC)</H1>
</TD><TD align="right"><img src="../images/NACO_Logo.png"  /></TD></TR>
</TABLE>

<script language="JavaScript">
                   <!-- Hide the script from old browsers --
                    function surfto(form) {
                     var myindex=form.getstate.selectedIndex
                     if (form.getstate.options[myindex].value != 0) {
                     location=form.getstate.options[myindex].value;}

                     }
                     //-->
                     </script> 




<FORM NAME="form1"  >

See all Counties in your state: 
	<SELECT NAME="getstate" onChange="surfto(this.form)" size="1"  dir="ltr" title="State Selection"> 
     <option> Select a state</option> 
		
        <cfoutput query="getstates">
        <option value="state_counties2.cfm?getstate=#statecode#">#statename#</option> 
        </CFOUTPUT>
        </SELECT>
        </FORM>


<HR />


<P>
<TABLE width="70%" cellpadding="1" cellspacing="0" border="0">
<CFOUTPUT>
<TR bgcolor="##CCCCCC" valign="bottom">
<TD width="20%"><strong>County</strong></TD>
<TD align="center"><strong>NACo<BR />Member</strong></TD>
<TD align="right"><strong><A HREF="state_counties.cfm?PAD=#PAD#&getstate=#getstate#">2010<BR />Population</A></strong></TD>
<TD align="right"><strong>Square<BR />Miles</strong></TD>
<TD width="2%">&nbsp;</TD>
<TD><strong>County<BR />Seat</strong></TD>
<TD align="right"><strong>Board<BR />Size</strong></TD>
<TD align="right"><strong>Founded</strong></TD>
</TR>
</CFOUTPUT>


<CFoutput query="getcounties">
<TR>
<TD><A HREF="http://www.uscounties.org/cffiles_web/counties/county.cfm?id=#fips#">#company#</A></TD>
<TD align="center"><CFIF  #MemberStatus# EQ "Active">X</CFIF></TD>
<TD align="right">#NumberFormat(Population2010,"999,999,999")#</TD>
<TD align="right">#NumberFormat(SquareMiles,"999,999,999.99")#</TD>
<TD>&nbsp; </TD>
<TD>#countyseat#</TD>
<TD align="right">#boardsize#</TD>
<TD align="right">#founded#</TD>
</TR>
</CFoutput> 
</TABLE>




</body>
</html>