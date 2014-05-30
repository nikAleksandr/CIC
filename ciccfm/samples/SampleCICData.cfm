<CFQUERY name="getdata" datasource="naco_cic">
select [fips text], [fips and years_year], [PILT Allocation]
from [Federal funding] where [fips and years_year] > 2010 and [fips and years_year] < 2014
order by [fips and years_year], [fips text]
</CFQUERY>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>
<CENTER>
<H2>PILT Allocation figures for 2011, 2012, 2013</H2>
Total Records: <cfoutput>#Numberformat(getdata.recordcount, "999,999,999")#</cfoutput>
</CENTER>
<P>
<TABLE width="40%" cellpadding="0" cellspacing="0" border="0" align="center">
<TR><TD width="25%" align="right"><strong>fips text</strong></TD><TD width="25%" align="right"><strong>fips and years_year</strong></TD>
<TD  align="right" width="50%"><strong>PILT Allocation</strong></TD></TD></TR>
<CFOUTPUT query="getdata">
<TR><TD align="right">#getdata['fips text'][CurrentRow]#</TD>
<TD align="right">#getdata['fips and years_year'][CurrentRow]#</TD>
<TD align="right">#getdata['PILT Allocation'][CurrentRow]# </TD></TR> 
</CFOUTPUT>
</TR>
</TABLE>

</body>
</html>