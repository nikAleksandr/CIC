<CFPARAM name="tablename" default="">
<CFPARAM name="filedname" default="">




<cfquery name="get_data" datasource="naco_cic">
select * from #tablename#
where fips = 19001

</cfquery>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>
<CFOUTPUT query="get_data">
#countyname# #state#
</CFOUTPUT>

</body>
</html>