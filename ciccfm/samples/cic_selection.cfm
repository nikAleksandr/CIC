<cfparam  name="Geography" default="">
<cfparam  name="Year" default="">
<cfparam  name="Selector" default="">
<cfparam  name="Indicator" default="">

<CFIF #Geography# NEQ "">
<cfquery datasource="naco_data" name="get_demographics">
Select state, company, Population2010, Population2000, Population1990, Population1980, SquareMiles
from client_naco_AMS_MAST
where orgtype = 'County' and State = '#Geography#' 
order by state, company
</cfquery>
</CFIF>






<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<link href="../../naco_default.css" rel="stylesheet" type="text/css">
<title>CIC Data Selections</title>
</head>

<body >


  

<TABLE align="center" width="860" bordercolor="1">
<TR bgcolor="#CCCCCC"><TD colspan="2" align="center"> <P><H1>NACo CIC EXTRACTION TOOL <em>(SAMPLE</em>)</H1></P></TD></TR>

<TR><TD class="2">&nbsp; </TD></TR>

<TR valign="TOP">
<TD width="20%">&nbsp; </TD>
<TD width="80%"><H3>2) Select Selectors</H3>    
     <FORM action="cic_selection.cfm" method="POST">    
	
    <SELECT NAME="Selector"  size=1> 
	<OPTION>Dataset Selectors...</OPTION>
    <OPTION VALUE="Population">&nbsp; Population &nbsp;
	<OPTION VALUE="PopulationChange">&nbsp; Population Change Components&nbsp;
    <OPTION VALUE="PopulationDensity">&nbsp; Population Density &nbsp;
    <OPTION VALUE="PopulationAge">&nbsp; Population by Age/Gender &nbsp;
    <OPTION VALUE="PopulationEthnicity">&nbsp; Population by Ethnicity &nbsp;
	</SELECT>

	<SELECT NAME="Indicator"  size=1> 
	<OPTION>Indicator Selectors...</OPTION>
	<OPTION VALUE="Growth">&nbsp; ?????&nbsp;
 
	</SELECT>

	<SELECT NAME="Geography"  size=1> 
	<OPTION>Geography Selectors...</OPTION>
	<OPTION VALUE="AL">&nbsp; Alabama&nbsp;
    <OPTION VALUE="AK">&nbsp; Alaska&nbsp;
    <OPTION VALUE="AZ">&nbsp; Arizona&nbsp;
    <OPTION VALUE="AR">&nbsp; Arkansas&nbsp;
    <OPTION VALUE="CA">&nbsp; California&nbsp;
	</SELECT>

	<SELECT NAME="Year"  size=1> 
	<OPTION>Year Selectors...</OPTION>
	<OPTION VALUE="2010">&nbsp; 2010 &nbsp;
    <OPTION VALUE="2000">&nbsp; 2000 &nbsp;
    <OPTION VALUE="1990">&nbsp; 1990&nbsp;
     <OPTION VALUE="1980">&nbsp; 1980&nbsp;
	</SELECT>
<BR />
<CENTER>
<input type="submit" value="Search">
</CENTER>
	

	</form>
</TD></TR>

<TR valign="top">
<TD>
            <H3>1) Select a Category</H3>
            <br>
            <strong>Categories:</strong><BR />
            
            <input type="radio" name="category" value="Demographics" checked="checked" /> Demograpics<BR />
            <input type="radio" name="category" value="Administration" /> Administration<BR />
            <input type="radio" name="category" value="Employment" /> County Employment<BR />
            <input type="radio" name="category" value="Finance" /> County Finance<BR />
            <input type="radio" name="category" value="Structure" /> County Structure<BR />
            <input type="radio" name="category" value="Economy" /> Economy<BR />
            <input type="radio" name="category" value="Federal" /> Federal Funding<BR />
            <input type="radio" name="category" value="Geography" /> Geography<BR />
            <input type="radio" name="category" value="Health" /> Health & Hospitals<BR />
            <input type="radio" name="category" value="Housing" /> Housing & Community Development<BR />
            <input type="radio" name="category" value="Juctice" /> Justice & Public Safety<BR />
            <input type="radio" name="category" value="Land" /> Land & Housing<BR />
            <input type="radio" name="category" value="Public Amenities" /> Public Amenities<BR />
            <input type="radio" name="category" value="Public Welfare" /> Public Welfare<BR />
            <input type="radio" name="category" value="Transportation" /> Transportation<BR />
            <input type="radio" name="category" value="Utility" /> Utility<BR />
</TD>


<TD>

				<!---Population Table --->

				<CFIF #Selector# EQ "Population">
                        <TABLE cellpadding="0" cellspacing="0" border="1" width="100%">
                        <TR bgcolor="silver"><TD>&nbsp;</TD><TD>&nbsp;</TD><TD align="center" colspan="4"><strong>Populations</strong></TD></TR>
                        <TR bgcolor="silver"><TD><strong>State</strong></TD>
                        <TD><strong>County</strong></TD>
                        <TD align="right"><strong>2010</strong>&nbsp;</TD>
                        <TD align="right"><strong>2000</strong>&nbsp;</TD>
                        <TD align="right"><strong>1990</strong>&nbsp;</TD>
                        <TD align="right"><strong>1980</strong>&nbsp;</TD>
                        </TR>
                        <cfoutput query="get_demographics">
                        <TR><TD>#state#</TD><TD>#company#</TD>
                        <TD align="right"> #population2010# &nbsp;</TD>
                        <TD align="right"> <CFIF #population2000# EQ "">n/a<CFELSE>#population2000#</CFIF>&nbsp;</TD>
                        <TD align="right"> <CFIF #population1990# EQ "">n/a<CFELSE>#population1990#</CFIF> &nbsp;</TD>
                        <TD align="right"> <CFIF #population1980# EQ "">n/a<CFELSE>#population1980#</CFIF> &nbsp;</TD>
                                  </TR>
                        </cfoutput>
                        </TABLE>
				</CFIF>



				<CFIF #Selector# EQ "SquareMiles">
                        <TABLE cellpadding="0" cellspacing="0" border="1" width="100%">
                         <TR bgcolor="silver"><TD><strong>State</strong></TD>
                        <TD><strong>County</strong></TD>
                        <TD align="right"><strong>Square Miles</strong></TD>
                        </TR>
                        <cfoutput query="get_demographics">
                        <TR><TD>#state#</TD><TD>#company#</TD>
                        <TD align="right"> #SquareMiles# &nbsp;</TD>
                        </TR>
                        </cfoutput>
                        </TABLE>
				</CFIF>

</TD>
</TR>
</TABLE>

</body>
</html>