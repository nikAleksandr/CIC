<cfparam name="Category_List" default="">

       <cfquery datasource="naco_cic" name="get_sub_category">
        select * from crosswalk
        where cat_ID_FK = '#Category_List#' 
        and sub_type is not null
        order by sub_type
        </cfquery>
 


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title>CIC Extraction Tool</title>

<link rel="stylesheet" href="../css/normalize.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
<link href='http://fonts.googleapis.com/css?family=Roboto+Condensed:300,400' rel='stylesheet' type='text/css'>
<link href='http://fonts.googleapis.com/css?family=Arvo' rel='stylesheet' type='text/css'>
<link rel="stylesheet" href="../css/extraction.css">
<link rel="stylesheet" href="../css/main.css">

<!--Google Analytics NACo -->
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-53704295-1', 'auto');
  ga('send', 'pageview');

</script>

</head>



<body>
<div id="extraction-header">
	<div class="row" >
		<div class="col-md-10">	<h1>NACo CIC Extraction Tool Help</h1></div>
		<!--<div class="col-md-2">	<img id="nacoLogo" alt="National Association of Counties Logo" src="../img/NACoLogo_NoTagBLACK_tm.png" />	</div> -->
    </div>
	  <a href="cic_extraction_1.cfm">Return to CIC Extraction Tool</a> &nbsp;   &nbsp;   &nbsp; &nbsp;   &nbsp;   
</div>
<HR />
<DIV>

<H2>Having trouble finding what you need?</H2>


		<H3><em>Choose a Category</em></H3>
          <form  action="cic_extraction_help.cfm" method="post" >
          <select  name="Category_List" size="1"  >
          <option value="ADMIN">Administration</option>
          <option value="EMPL">County Employment</option>
          <option value="FINAN">County Finance</option>
          <option value="STRUC">County Structure</option>
          <option value="DEMO">Demographics</option>
          <option value="ECON">Economy</option>
          <option value="EDUC">Education</option>
          <option value="FUND">Federal Funding</option>
          <option value="GEO">Geography</option>
          <option value="HEALT">Health & Hospitals</option>
          <option value="HOUS">Housing & Community Development</option>
          <option value="JUST">Justice & Public Safety</option>
          <option value="AMEN">Public Amenity</option>
          <option value="WELF">Public Welfare</option>
          <option value="TRANS">Transportation</option>
          <option value="UTIL">Utility</option>
          <option value="WSSW">Water, Sewage & Solid Waste</option>
    </select> 
    <P>
<input class="btn btn-info extraction-help-button" type="submit"  value="Get Help" />
</form>
</DIV>

<DIV align="left">

<P >
<CFIF get_sub_category.recordcount GT 0>
    <TABLE width="85%" align="center" cellpadding="0" cellspacing="0" border="0">
    <TR><TD>
    <CFOUTPUT><H1><font color="##5BC0DE">#get_sub_category.cat_Name#</font></H1></CFOUTPUT>
            <CFOUTPUT query="get_sub_category" group="sub_type">
            <H3><font color="##5BC0DE">#sub_type#</font></H3>
            <CFOUTPUT><strong>#sub_cat#</strong><BR />#definition#<P></CFOUTPUT>
    </CFOUTPUT>
    </TD></TR></TABLE>
</CFIF>	
</DIV>

</body>
</html>