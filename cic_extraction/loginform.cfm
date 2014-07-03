<!DOCTYPE html>
<html>
<head>

<title>CIC Extraction Tool</title>

<link rel="stylesheet" href="../css/normalize.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
<link href='http://fonts.googleapis.com/css?family=Roboto+Condensed:300,400' rel='stylesheet' type='text/css'>
<link href='http://fonts.googleapis.com/css?family=Arvo' rel='stylesheet' type='text/css'>
<link rel="stylesheet" href="../css/main.css">

</head>
<body >
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

<div class="container" style="background-color:#FFFFFF;margin:0 auto;">
    <p>Coming in September!  This tool is not yet available, but please check back shortly.  If you have any questions, please don't hesitate to <a href="mailto:research@naco.org">contact us</a>.</p>
    <p>Please Log In</p>
    
    <cfoutput> 
         <form class="extraction-form" action="#CGI.script_name#?#CGI.query_string#" method="Post">
              <div class="form-group">
              	<label for="inputName">User name:</label>
              	<input id="inputName" type="text" name="j_username" placeholder="Enter User name">
              </div>      
              <div class="form-group">
              	<label for="inputPass">Password:</label>
              	<input id="inputPass" type="password" name="j_password" placeholder="Enter Password">
              </div>    
              <input class="btn btn-info" type="submit" value="Log In">
           </form>   
    </cfoutput>
</div>

</body>
</html>