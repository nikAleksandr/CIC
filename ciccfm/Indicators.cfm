<CFPARAM name="tablename1" default="">
<CFPARAM name="tablename2" default="">

<CFPARAM name="value1" default="">
<CFPARAM name="field1" default="">

<CFPARAM name="exportfield1" default="">
<CFPARAM name="exportfield2" default="">
<CFPARAM name="exportfield3" default="">

<CFPARAM name="col1" default="">


<cfquery name="get_data" datasource="naco_cic">
select *
 from #tablename1#
where #field1# = '#value1#'
order by fips
</cfquery>




<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CIC Public Data</title>
</head>

<body>

<CFOUTPUT>
<strong>Results For: #field1#  = #value1#</strong><P>

<strong>FIPS, State, County, #exportfield1#, #exportfield2#, #exportfield3#</strong><BR />
</CFOUTPUT>

<CFOUTPUT query="get_data">
#FIPS#, #State#, #County_Name#,  #evaluate(evaluate("exportfield1"))#, #evaluate(evaluate("exportfield2"))# , #evaluate(evaluate("exportfield3"))# <BR />
</CFOUTPUT>



</body>
</html>