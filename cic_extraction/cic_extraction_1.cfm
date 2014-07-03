<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title>CIC Extraction Tool</title>

<link rel="stylesheet" href="../css/normalize.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
<link href='http://fonts.googleapis.com/css?family=Roboto+Condensed:300,400' rel='stylesheet' type='text/css'>
<link href='http://fonts.googleapis.com/css?family=Arvo' rel='stylesheet' type='text/css'>
<link rel="stylesheet" href="../css/main.css">

</head>
<body>
<div id="extraction-header">
	<div class="row" >
		<div class="col-md-10">
			<h1>NACo CIC Extraction Tool</h1>
			
			<H3><em>Choose One or Two Categories</em></H3>
		</div>
		<div class="col-md-2">
			<img id="nacoLogo" alt="National Association of Counties Logo" src="../img/NACoLogo_NoTagBLACK_tm.png" />
		</div>
	</div>
	<a href="http://cic.naco.org">Return to Interactive Map</a>
</div>

<form class="extraction-form" action="cic_extraction_2.cfm" method="post">
    <select id="catlist" name="Category_List" multiple class="form-control extraction-multiple" size="17"  >
          <option value="ADMIN">Administration</option>
          <option value="EMPLO">County Employment</option>
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
<p>Hold the <i>Ctrl</i> key and click a second category if desired. <input class="btn btn-info" type="submit"  value="Next..."></p>

</form>



	


</body>
</html>