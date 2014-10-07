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


<!--Script to limit the number of selections in the selection box-->
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>

<script src="http://www.google.com/jsapi"></script>
    <script type="text/javascript">
    google.load("jquery", "1");

    $(document).ready(function() {

      var last_valid_selection = null;

      $('#catlist').change(function(event) {
        if ($(this).val().length > 2) {
          alert('Sorry, you can only choose 2!');
          $(this).val(last_valid_selection);
        } else {
          last_valid_selection = $(this).val();
        }
      });
    });
</script>

</head>


<body >

<div id="extraction-header">
<div>
<img id="nacoLogo" alt="National Association of Counties Logo" src="../img/NACoLogo_NoTagBLACK_tm.png" />	
<div><h1>NACo CIC Extraction Tool</h1></div>
</div>
<A HREF="cic_extraction_help.cfm"> CIC Extraction Tool Help</a> 
</div>



<!--class="extraction-form"  class="form-control extraction-multiple" -->
<DIV>
<H3><em>Choose One or Two Categories</em></H3>
         <form  class="extraction-form"  action="cic_extraction_2.cfm" method="post">
          <select id="catlist" name="Category_List" multiple  size="17"  >
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
    
      <div class="extraction-help-box">
      	<span class="extraction-help-text">Hold the CTRL key and click, to select multiple indicators.</span><input class="btn btn-info" type="submit"  value="Next...">
      </div>
    
       

</form>
</DIV>


	


</body>
</html>