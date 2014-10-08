<!DOCTYPE html>
<html>
<head>

<title>CIC Extraction Tool</title>

<link rel="stylesheet" href="../css/normalize.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
<link href='http://fonts.googleapis.com/css?family=Roboto+Condensed:300,400' rel='stylesheet' type='text/css'>
<link href='http://fonts.googleapis.com/css?family=Arvo' rel='stylesheet' type='text/css'>
<link rel="stylesheet" href="../css/extraction.css">
<link rel="stylesheet" href="../css/main.css">


<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-53704295-1', 'auto');
  ga('send', 'pageview');

</script>

</head>
<body >
<div id="extraction-header">
	<div class="row" >
		<div class="col-md-10">
        <img id="nacoLogo" alt="National Association of Counties Logo" src="../img/NACoLogo_NoTagBLACK_tm.png" />
			<h1>NACo CIC Extraction Tool</h1>
			
			
		</div>
		
	</div>
	<a href="http://cic.naco.org">Return to Interactive Map</a>
</div>




<div class="container" style="background-color:#FFFFFF;margin:0 auto;">

        
 
    <p><strong>Please Log In</strong></p>
    
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
<P>&nbsp;  </P>
<P>  &nbsp </P>
  <A HREF="http://www.naco.org/research/Pages/CIC-Signup.aspx" target="_blank"><strong>Request an Account Now!</strong></A><BR>
  This is a paid subscription.

<P>&nbsp;   </P>
<!--- Send questions or comments regarding NACo's CIC Extraction Tool to  <a href="mailto:naco@naco.org">NACo</a>.</p> --->
</body>
</html>