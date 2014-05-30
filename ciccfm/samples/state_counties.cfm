<CFPARAM name="getstate" default="">

<cfparam name="search_by_state" default="">
<cfparam name="OrderBy" default="">
<cfparam name="CAD" default=""> <!--- County --->
<cfparam name="PAD" default="">  <!--- Population --->
<cfparam name="MAD" default="">  <!--- Square Miles --->
<cfparam name="SAD" default="">  <!--- Seat --->
<cfparam name="BAD" default="">  <!--- Board Size --->
<cfparam name="FAD" default="">  <!--- Founded --->
<cfparam name="DAD" default="">  <!--- Density --->



<!--- Order by County Column--->
<CFIF #CAD# EQ "D"  >
   <CFSET OrderBy = "company DESC">
</CFIF> 

<CFIF #CAD# EQ "A" >
   <CFSET Orderby = "company">
</CFIF> 


<!--- Order by Population Column--->
<CFIF #PAD# EQ "D"  >
   <CFSET OrderBy = "Population2010 DESC">
</CFIF> 

<CFIF #PAD# EQ "A" >
   <CFSET Orderby = "Population2010">
</CFIF> 


<!--- Order by Square Miles Column--->
<CFIF #MAD# EQ "D"  >
   <CFSET OrderBy = "SquareMiles DESC">
</CFIF> 

<CFIF #MAD# EQ "A" >
   <CFSET Orderby = "SquareMiles">
</CFIF> 



<!--- Order by Square Miles Column--->
<CFIF #SAD# EQ "D"  >
   <CFSET OrderBy = "countyseat DESC">
</CFIF> 

<CFIF #SAD# EQ "A" >
   <CFSET Orderby = "countyseat">
</CFIF> 


<!--- Order by Board Size Column--->
<CFIF #BAD# EQ "D"  >
   <CFSET OrderBy = "boardsize DESC">
</CFIF> 

<CFIF #BAD# EQ "A" >
   <CFSET Orderby = "boardsize">
</CFIF> 


<!--- Order by Year Founded Column--->
<CFIF #FAD# EQ "D"  >
   <CFSET OrderBy = "founded DESC">
</CFIF> 

<CFIF #FAD# EQ "A" >
   <CFSET Orderby = "founded">
</CFIF> 


<!--- Order by Persons per Square Miles Column--->
<CFIF #DAD# EQ "D"  >
   <CFSET OrderBy = "density DESC">
</CFIF> 

<CFIF #DAD# EQ "A" >
   <CFSET Orderby = "density">
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
        Select *, (population2010 / squaremiles) as Density
         from County_data
        where 
         state = '#getstate#'
        order by #orderby#
        </cfquery> 



<CFIF #CAD# EQ ""><CFSET CAD="A"></CFIF>
<CFIF #CAD# EQ "A"><CFSET CAD="D"><CFELSE><CFSET CAD="A"></CFIF>
 
<CFIF #PAD# EQ ""><CFSET PAD="A"></CFIF>
<CFIF #PAD# EQ "A"><CFSET PAD="D"><CFELSE><CFSET PAD="A"></CFIF>


<CFIF #MAD# EQ ""><CFSET MAD="A"></CFIF>
<CFIF #MAD# EQ "A"><CFSET MAD="D"><CFELSE><CFSET MAD="A"></CFIF>

<CFIF #SAD# EQ ""><CFSET SAD="A"></CFIF>
<CFIF #SAD# EQ "A"><CFSET SAD="D"><CFELSE><CFSET SAD="A"></CFIF>

<CFIF #BAD# EQ ""><CFSET BAD="A"></CFIF>
<CFIF #BAD# EQ "A"><CFSET BAD="D"><CFELSE><CFSET BAD="A"></CFIF>

<CFIF #FAD# EQ ""><CFSET FAD="A"></CFIF>
<CFIF #FAD# EQ "A"><CFSET FAD="D"><CFELSE><CFSET FAD="A"></CFIF>


<CFIF #DAD# EQ ""><CFSET DAD="A"></CFIF>
<CFIF #DAD# EQ "A"><CFSET DAD="D"><CFELSE><CFSET DAD="A"></CFIF>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="site.css" rel="stylesheet" type="text/css">
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
        <option value="state_counties.cfm?getstate=#statecode#">#statename#</option> 
        </CFOUTPUT>
        </SELECT>
        </FORM>


<HR />


<P>
<TABLE width="70%" cellpadding="1" cellspacing="0" border="0">
<CFOUTPUT>
    <TR bgcolor="##CCCCCC" valign="bottom">
    <TD width="20%"><strong><A HREF="state_counties.cfm?CAD=#CAD#&getstate=#getstate#" title="Sort by County">County</A></strong></TD>
    <TD align="center"><strong>NACo<BR />Member</strong></TD>
    <TD align="right"><strong><A HREF="state_counties.cfm?PAD=#PAD#&getstate=#getstate#" title="Sort by Population">2010<BR />Population</A></strong></TD>
    <TD align="right"><strong><A HREF="state_counties.cfm?MAD=#MAD#&getstate=#getstate#" title="Sort by Square Miles">Square<BR />Miles</A></strong></TD>
    <TD align="right"><strong><A HREF="state_counties.cfm?DAD=#DAD#&getstate=#getstate#" title="Sort by Peersons Per Square Mile">Persons Per<BR />Sq. Mile</A></strong></TD>
    <TD width="2%">&nbsp;</TD>
    <TD><strong><A HREF="state_counties.cfm?SAD=#SAD#&getstate=#getstate#" title="Sort by County Seat">County Seat</strong></strong></TD>
    <TD align="right"><strong><A HREF="state_counties.cfm?BAD=#BAD#&getstate=#getstate#" title="Sort by Board Size">County<BR />Board Size</A></strong></TD>
    <TD align="right"><strong><A HREF="state_counties.cfm?FAD=#FAD#&getstate=#getstate#" title="Sort by Year Founded">Year<BR />Founded</A></strong></TD>
    </TR>
</CFOUTPUT>


<CFoutput query="getcounties">
<TR>
<TD><A HREF="http://www.uscounties.org/cffiles_web/counties/county.cfm?id=#fips#">#company#</A></TD>
<TD align="center"><CFIF  #MemberStatus# EQ "Active">X</CFIF></TD>
<TD align="right">#NumberFormat(Population2010,"999,999,999")#</TD>
<TD align="right">#NumberFormat(SquareMiles,"999,999,999.99")#</TD>
<TD align="right">#NumberFormat(Density,"999,999,999.99")#</TD>
<TD>&nbsp; </TD>
<TD>#countyseat#</TD>
<TD align="right">#boardsize#</TD>
<TD align="right">#founded#</TD>
</TR>
</CFoutput> 
</TABLE>




</body>
</html>