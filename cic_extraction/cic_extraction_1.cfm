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
</div>

<form class="extraction-form" action="cic_extraction_2.cfm" method="post">

    <select id="catlist" name="Category_List" multiple class="form-control extraction-multiple" size="17"  >
          <option value="Administration">Administration</option>
          <option value="County_Employment">County Employment</option>
          <option value="County_Finance">County Finance</option>
          <option value="County_Structure">County Structure</option>
          <option value="Demographics">Demographics</option>
          <option value="Economy">Economy</option>
          <option value="Education">Education</option>
          <option value="Federal_Funding">Federal Funding</option>
          <option value="Geography">Geography</option>
          <option value="Health_Hospitals">Health & Hospitals</option>
          <option value="Housing_Community_Development">Housing & Community Development</option>
          <option value="Justice_Public_Safety">Justice & Public Safety</option>
          <option value="Public_Amenity">Public Amenity</option>
          <option value="Public_Welfare">Public Welfare</option>
          <option value="Transportation">Transportation</option>
          <option value="Utility">Utility</option>
          <option value="W_S_SW">Water, Sewage & Solid Waste</option>
    </select> 
<p>Hold the <i>Ctrl</i> key and click a second category if desired. <input class="btn btn-info" type="submit"  value="Next..."></p>

</form>



</body>
</html>