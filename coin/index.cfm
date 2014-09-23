<CFPARAM name="token" default="0">


<CFIF #token# EQ 0>
<CFLOCATION URL="invalid.html" >
<CFABORT>
</CFIF>

<CFIF  #CGI.HTTP_REFERER#  NEQ "https://www.countyinnovation.us/wapps/partners/cic/">
<CFLOCATION URL="invalid.html" >
<CFABORT>
<CFELSE>





<!DOCTYPE html>
<html class="no-js" itemscope itemtype="http://schema.org/Product">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>County Intelligence Connection (CIC)</title>
        <meta name="description" content="Explore your county through over 500 indicators and nearly 70 datasets.">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Place favicon.ico and apple-touch-icon(s) in the root directory -->
		<!-- Facebook sharing tags -->
    	<meta property="og:title" content="How much do you know about your county?"/>
		<meta property="og:image" content="http://cic.naco.org/img/CICFullThumb.png"/>
		<meta property="og:site_name" content="County Intelligence Connection 2.0"/>
		<meta property="og:description" content="Explore your county through over 500 indicators and nearly 70 datasets."/>
		<meta property="og:url" content="http://cic.naco.org"/>
		<!--Twitter Card tags -->
		<meta name="twitter:card" content="summary_large_image">
		<meta name="twitter:site" content="@NACoTweets">
		<meta name="twitter:title" content="NACo County Intelligence Connection (CIC) 2.0">
		<meta name="twitter:description" content="Explore your county through over 500 indicators and nearly 70 datasets.">
		<meta name="twitter:image:src" content="http://cic.naco.org/img/CICFullThumb.png">
		<!--Google +  Meta Tags-->
		<meta itemprop="name" content="County Intelligence Connection (CIC) 2.0">
		<meta itemprop="description" content="Explore your county through over 500 indicators and nearly 70 datasets.">
		<meta itemprop="image" content="http://cic.naco.org/CICFullThumb.png">
		
        <link rel="stylesheet" href="../css/normalize.css">
		<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" media="all">
		<link href='https://fonts.googleapis.com/css?family=Roboto+Condensed:300,400' rel='stylesheet' type='text/css'>
		<link href='https://fonts.googleapis.com/css?family=Arvo:400,700' rel='stylesheet' type='text/css'>
		<link rel="stylesheet" href="../css/main.css" media="all">
        <!-- SmartMenus jQuery Bootstrap Addon CSS -->
		<link href="../css/jquery.smartmenus.bootstrap.css" rel="stylesheet">
		<!--Rediculously Responsive Social Sharing Buttons-->
        <link rel="stylesheet" href="../css/rrssb.css" />
        <link rel='stylesheet' href='../css/nprogress.css' />
        <script src="../js/vendor/modernizr-2.7.1.min.js"></script>
        <script src="../js/vendor/d3.min.js"></script>
		<script src="../js/vendor/topojson.v1.min.js"></script>
    </head>
    <body>
    	<div id="header" class="navbar-fixed-top">
			<div class="row" >
			<div class="col-md-10">
				<h1>NACo County Intelligence Connection 2.0</h1>
				
				<p>Select a <i>Primary Indicator</i>&nbsp; below and click on a county to view more detailed information.  
					<br/>Double-click on a county to view basic information about it.
  				</p>
			</div>
			<div class="col-md-2">
				<img id="nacoLogo" alt="National Association of Counties Logo" src="../img/NACoLogo_NoTagBLACK_tm.png" />
			</div>
			</div>
				
				
			   <!-- Static navbar -->
				<div class="navbar-CIC navbar " role="navigation">
				  <div class="navbar-header">
				    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
				      <span class="sr-only">Toggle navigation</span>
				      <span class="icon-bar"></span>
				      <span class="icon-bar"></span>
				      <span class="icon-bar"></span>
				    </button>
				   <a class="navbar-brand" href="#">CIC 2.0</a>
				  </div>
				  <div class="navbar-collapse collapse">
				
				    <!-- Left nav -->
				    <ul class="nav navbar-nav">
						<li id="primeIndLi">
							<a id="primeIndText">Primary Indicator</a>
							<ul id="primeInd" class="dropdown-menu">
								<li class="category" name="Administration">
									<a>Administration</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Administration Expenditures">
											<a>Administration Expenditures<!-- <span class="badge">new</span> --></a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Administration" href="#">Total Administration</a>
												</li>
												<li>
													<a class="indicator" name="Financial Administration" href="#">Financial Administration</a>
												</li>
												<li>
													<a class="indicator" name="Other Governmental Administration" href="#">Other Governmental Administration</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Social Insurance Administration" href="#">Social Insurance Administration</a>
												</li> -->
												<!-- <li>
													<a class="indicator" name="Liquor Stores" href="#">Liquor Stores</a>
												</li> -->
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Administration Employment">
											<a>Administration Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Administration" href="#">Total Administration</a>
												</li>
												<li>
													<a class="indicator" name="Financial Administration" href="#">Financial Administration</a>
												</li>
												<li>
													<a class="indicator" name="Other Governmental Administration" href="#">Other Governmental Administration</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Social Insurance Administration" href="#">Social Insurance Administration</a>
												</li> -->
											</ul>
										</li>
										<li class="dataset" name="Administration Revenue">
											<a>Administration Revenue</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Administration" href="#">Total Administration</a>
												</li>
												<li>
													<a class="indicator" name="Charges" href="#">Charges</a>
												</li>
												<li>
													<a class="indicator" name="Misc. General Revenue" href="#">Misc. General Revenue</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Liquor Stores" href="#">Liquor Stores</a>
												</li> -->
												<li>
													<a class="indicator" name="Public Employee Retirement Systems" href="#">Public Employee Retirement Systems</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Unemployment Compensation Systems" href="#">Unemployment Compensation Systems</a>
												</li> -->
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="County Employment">
									<a>County Employment</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Administration Employment">
											<a>Administration Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Administration" href="#">Total Administration</a>
												</li>
												<li>
													<a class="indicator" name="Financial Administration" href="#">Financial Administration</a>
												</li>
												<li>
													<a class="indicator" name="Other Governmental Administration" href="#">Other Governmental Administration</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Social Insurance Administration" href="#">Social Insurance Administration</a>
												</li> -->
											</ul>
										</li>
										<li class="dataset" name="Public Amenity Employment">
											<a>Public Amenity Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Public Amenity" href="#">Total Public Amenity</a>
												</li>
												<li>
													<a class="indicator" name="Libraries" href="#">Libraries</a>
												</li>
												<li>
													<a class="indicator" name="Natural Resources" href="#">Natural Resources</a>
												</li>
												<li>
													<a class="indicator" name="Parks &amp; Recreation" href="#">Parks &amp; Recreation</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Education Employment">
											<a>Education Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Education" href="#">Total Education</a>
												</li>
												<li>
													<a class="indicator" name="Elementary &amp; Secondary Education" href="#">Elementary &amp; Secondary Education</a>
												</li>
												<li>
													<a class="indicator" name="Higher Education" href="#">Higher Education</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Housing &amp; Community Development Employment">
											<a>Housing &amp; Community Development Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Housing &amp; Community Development" href="#">Housing &amp; Community Development</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Health &amp; Hospitals Employment">
											<a>Health &amp; Hospitals Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Health &amp; Hospitals" href="#">Total Health &amp; Hospitals</a>
												</li>
												<li>
													<a class="indicator" name="Health" href="#">Health</a>
												</li>
												<li>
													<a class="indicator" name="Hospitals" href="#">Hospitals</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Justice &amp; Public Safety Employment">
											<a>Justice &amp; Public Safety Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Justice &amp; Public Safety" href="#">Total Justice &amp; Public Safety</a>
												</li>
												<li>
													<a class="indicator" name="Correction" href="#">Correction</a>
												</li>
												<li>
													<a class="indicator" name="Judicial &amp; Legal Services" href="#">Judicial &amp; Legal Services</a>
												</li>
												<li>
													<a class="indicator" name="Police Protection" href="#">Police Protection</a>
												</li>
												<li>
													<a class="indicator" name="Fire Protection" href="#">Fire Protection</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Public Welfare Employment">
											<a>Public Welfare Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Public Welfare" href="#">Public Welfare</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Transportation Employment">
											<a>Transportation Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Transportation" href="#">Total Transportation</a>
												</li>
												<li>
													<a class="indicator" name="Air Transportation" href="#">Air Transportation</a>
												</li>
												<li>
													<a class="indicator" name="Highways" href="#">Highways</a>
												</li>
												<li>
													<a class="indicator" name="Water Transport &amp; Terminals" href="#">Water Transport &amp; Terminals</a>
												</li>
												<li>
													<a class="indicator" name="Transit" href="#">Transit</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Utility Employment">
											<a>Utility Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Utility" href="#">Total Utility</a>
												</li>
												<li>
													<a class="indicator" name="Electric Utilities" href="#">Electric Utilities</a>
												</li>
												<li>
													<a class="indicator" name="Gas Utilities" href="#">Gas Utilities</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Water, Sewerage &amp; Solid Waste Employment">
											<a>Water, Sewerage &amp; Solid Waste Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Water, Sewerage &amp; Solid Waste" href="#">Total Water, Sewerage &amp; Solid Waste</a>
												</li>
												<li>
													<a class="indicator" name="Sewerage" href="#">Sewerage</a>
												</li>
												<li>
													<a class="indicator" name="Solid Waste" href="#">Solid Waste</a>
												</li>
												<li>
													<a class="indicator" name="Water Utilities" href="#">Water Utilities</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Other Employment">
											<a>Other Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Other &amp; Unallocable" href="#">Other &amp; Unallocable</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="County Finance">
									<a>County Finance</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Administration Revenue">
											<a>Administration Revenue</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Administration" href="#">Total Administration</a>
												</li>
												<li>
													<a class="indicator" name="Charges" href="#">Charges</a>
												</li>
												<li>
													<a class="indicator" name="Misc. General Revenue" href="#">Misc. General Revenue</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Liquor Stores" href="#">Liquor Stores</a>
												</li> -->
												<li>
													<a class="indicator" name="Public Employee Retirement Systems" href="#">Public Employee Retirement Systems</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Unemployment Compensation Systems" href="#">Unemployment Compensation Systems</a>
												</li> -->
											</ul>
										</li>
										<li class="dataset" name="Intergovernmental Revenue">
											<a>Intergovernmental Revenue</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Intergovernmental" href="#">Total Intergovernmental</a>
												</li>
												<li>
													<a class="indicator" name="From Federal Government" href="#">From Federal Government</a>
												</li>
												<li>
													<a class="indicator" name="From Local Government" href="#">From Local Government</a>
												</li>
												<li>
													<a class="indicator" name="From State Government" href="#">From State Government</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Tax Revenue">
											<a>Tax Revenue</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Taxes" href="#">Total Taxes</a>
												</li>
												<li>
													<a class="indicator" name="Income Taxes" href="#">Income Taxes</a>
												</li>
												<li>
													<a class="indicator" name="License Taxes" href="#">License Taxes</a>
												</li>
												<li>
													<a class="indicator" name="Other Taxes" href="#">Other Taxes</a>
												</li>
												<li>
													<a class="indicator" name="Property Taxes" href="#">Property Taxes</a>
												</li>
												<li>
													<a class="indicator" name="Sales &amp; Gross Receipts Taxes" href="#">Sales &amp; Gross Receipts Taxes</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Utility Revenue">
											<a>Utility Revenue</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Utility" href="#">Total Utility</a>
												</li>
												<li>
													<a class="indicator" name="Electric Power Systems" href="#">Electric Power Systems</a>
												</li>
												<li>
													<a class="indicator" name="Gas Supply Systems" href="#">Gas Supply Systems</a>
												</li>
												<li>
													<a class="indicator" name="Public Mass Transit Systems" href="#">Public Mass Transit Systems</a>
												</li>
												<li>
													<a class="indicator" name="Water Supply Systems" href="#">Water Supply Systems</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Administration Expenditures">
											<a>Administration Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Administration" href="#">Total Administration</a>
												</li>
												<li>
													<a class="indicator" name="Financial Administration" href="#">Financial Administration</a>
												</li>
												<li>
													<a class="indicator" name="Other Governmental Administration" href="#">Other Governmental Administration</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Social Insurance Administration" href="#">Social Insurance Administration</a>
												</li> -->
												<!-- <li>
													<a class="indicator" name="Liquor Stores" href="#">Liquor Stores</a>
												</li> -->
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Public Amenity Expenditures">
											<a>Public Amenity Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Public Amenity" href="#">Total Public Amenity</a>
												</li>
												<li>
													<a class="indicator" name="Libraries" href="#">Libraries</a>
												</li>
												<li>
													<a class="indicator" name="Natural Resources" href="#">Natural Resources</a>
												</li>
												<li>
													<a class="indicator" name="Parks &amp; Recreation" href="#">Parks &amp; Recreation</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Education Expenditures">
											<a>Education Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Education" href="#">Total Education</a>
												</li>
												<li>
													<a class="indicator" name="Elementary &amp; Secondary Education" href="#">Elementary &amp; Secondary Education</a>
												</li>
												<li>
													<a class="indicator" name="Higher Education" href="#">Higher Education</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Housing &amp; Community Development Expenditures">
											<a>Housing &amp; Community Development Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Housing &amp; Community Development" href="#">Total Housing &amp; Community Development</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Health &amp; Hospitals Expenditures">
											<a>Health &amp; Hospitals Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Health &amp; Hospitals" href="#">Total Health &amp; Hospitals</a>
												</li>
												<li>
													<a class="indicator" name="Health" href="#">Health</a>
												</li>
												<li>
													<a class="indicator" name="Hospitals" href="#">Hospitals</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Financial Expenditures">
											<a>Financial Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Financial" href="#">Total Financial</a>
												</li>
												<li>
													<a class="indicator" name="Interest on General Debt" href="#">Interest on General Debt</a>
												</li>
												<li>
													<a class="indicator" name="Insurance Trust - Employee Retirement" href="#">Insurance Trust - Employee Retirement</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Insurance Trust - Unemployment" href="#">Insurance Trust - Unemployment</a>
												</li> -->
											</ul>
										</li>
										<li class="dataset" name="Justice &amp; Public Safety Expenditures">
											<a>Justice &amp; Public Safety Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Justice &amp; Public Safety" href="#">Total Justice &amp; Public Safety</a>
												</li>
												<li>
													<a class="indicator" name="Correction" href="#">Correction</a>
												</li>
												<li>
													<a class="indicator" name="Judicial &amp; Legal Services" href="#">Judicial &amp; Legal Services</a>
												</li>
												<li>
													<a class="indicator" name="Police Protection" href="#">Police Protection</a>
												</li>
												<li>
													<a class="indicator" name="Fire Protection" href="#">Fire Protection</a>
												</li>
												<li>
													<a class="indicator" name="Protective Inspection" href="#">Protective Inspection</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Public Welfare Expenditures">
											<a>Public Welfare Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Public Welfare" href="#">Total Public Welfare</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Cash Assistance" href="#">Cash Assistance</a>
												</li>
												<li>
													<a class="indicator" name="Vendor Payments" href="#">Vendor Payments</a>
												</li> -->
												<li>
													<a class="indicator" name="Other Public Welfare" href="#">Other Public Welfare</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Assistance &amp; Subsidies" href="#">Assistance &amp; Subsidies</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Transportation Expenditures">
											<a>Transportation Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Transportation" href="#">Total Transportation</a>
												</li>
												<li>
													<a class="indicator" name="Air Transportation" href="#">Air Transportation</a>
												</li>
												<li>
													<a class="indicator" name="Highways" href="#">Highways</a>
												</li>
												<li>
													<a class="indicator" name="Parking Facilities" href="#">Parking Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Sea &amp; Inland Port" href="#">Sea &amp; Inland Port</a>
												</li>
												<li>
													<a class="indicator" name="Transit Utilities" href="#">Transit Utilities</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Interest on Debt" href="#">Interest on Debt</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Utility Expenditures">
											<a>Utility Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Utility" href="#">Total Utility</a>
												</li>
												<li>
													<a class="indicator" name="Electric Utilities" href="#">Electric Utilities</a>
												</li>
												<li>
													<a class="indicator" name="Gas Utilities" href="#">Gas Utilities</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Interest on Debt" href="#">Interest on Debt</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Water, Sewerage &amp; Solid Waste Expenditures">
											<a>Water, Sewerage &amp; Solid Waste Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Water, Sewerage &amp; Solid Waste Management" href="#">Total Water, Sewerage &amp; Solid Waste Management</a>
												</li>
												<li>
													<a class="indicator" name="Sewerage" href="#">Sewerage</a>
												</li>
												<li>
													<a class="indicator" name="Solid Waste" href="#">Solid Waste</a>
												</li>
												<li>
													<a class="indicator" name="Water Utilities" href="#">Water Utilities</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Interest on Debt" href="#">Interest on Debt</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Other Expenditures">
											<a>Other Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Other" href="#">Total Other</a>
												</li>
												<li>
													<a class="indicator" name="Misc. Commercial Activities" href="#">Misc. Commercial Activities</a>
												</li>
												<li>
													<a class="indicator" name="Other &amp; Unallocable" href="#">Other &amp; Unallocable</a>
												</li>
												<li>
													<a class="indicator" name="General Public Buildings" href="#">General Public Buildings</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Annual Financial Report - Revenue">
											<a>Annual Financial Report - Revenue</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Taxes" href="#">Total Taxes</a>
												</li>
												<li>
													<a class="indicator" name="Licenses and Permits" href="#">Licenses and Permits</a>
												</li>
												<li>
													<a class="indicator" name="Fines, Fees &amp; Forfeits" href="#">Fines, Fees &amp; Forfeits</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental" href="#">Intergovernmental</a>
												</li>
												<li>
													<a class="indicator" name="Use of Money &amp; Property" href="#">Use of Money &amp; Property</a>
												</li>
												<li>
													<a class="indicator" name="Investment Earnings" href="#">Investment Earnings</a>
												</li>
												<li>
													<a class="indicator" name="Charges for Services" href="#">Charges for Services</a>
												</li>
												<li>
													<a class="indicator" name="Other" href="#">Other</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Annual Financial Report - Expenses">
											<a>Annual Financial Report - Expenses</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="General Government" href="#">General Government</a>
												</li>
												<li>
													<a class="indicator" name="Public Works, Buildings &amp; Transportation" href="#">Public Works, Buildings &amp; Transportation</a>
												</li>
												<li>
													<a class="indicator" name="Public Safety &amp; Court Related" href="#">Public Safety &amp; Court Related</a>
												</li>
												<li>
													<a class="indicator" name="Health &amp; Human Services" href="#">Health &amp; Human Services</a>
												</li>
												<li>
													<a class="indicator" name="Education, Culture &amp; Recreation" href="#">Education, Culture &amp; Recreation</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental" href="#">Intergovernmental</a>
												</li>
												<li>
													<a class="indicator" name="Environmental Protection/Natural Resources" href="#">Environmental Protection/Natural Resources</a>
												</li>
												<li>
													<a class="indicator" name="Community &amp; Economic Development" href="#">Community &amp; Economic Development</a>
												</li>
												<li>
													<a class="indicator" name="Total Debt" href="#">Total Debt</a>
												</li>
												<li>
													<a class="indicator" name="Capital Projects" href="#">Capital Projects</a>
												</li>
												<li>
													<a class="indicator" name="Other" href="#">Other</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="County Tax Rates">
											<a>County Tax Rates</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Sales Tax" href="#">Sales Tax<span class="badge">new</span></a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="County Structure">
									<a>County Structure</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Government Structure">
											<a>Government Structure</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total Elected Officials" href="#">Total Elected Officials</a>
												</li>
												<li>
													<a class="indicator" name="Size of Board" href="#">Size of Board</a>
												</li>
												<!--<li>
													<a class="indicator" name="Elected Executive" href="#">Elected Executive</a>
												</li>-->
												<li>
													<a class="indicator" name="Number of Row Officers" href="#">Number of Row Officers</a>
												</li>
												<!--<li>
													<a class="indicator" name="County Administrator" href="#">County Administrator</a>
												</li>-->
											</ul>
										</li>
										<li class="dataset" name="City-County Consolidations">
											<a>City-County Consolidations</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Consolidation" href="#">Consolidation<span class="badge">new</span></a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Demographics">
									<a>Demographics</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Population Levels and Trends">
											<a>Population Levels and Trends</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Population Level" href="#">Population Level</a>
												</li>
												<li>
													<a class="indicator" name="Population Annual Growth Rate (from previous year)" href="#">Population Annual Growth Rate</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Population Change Components">
											<a>Population Change Components</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Population Level" href="#">Population Level</a>
												</li>
												<li>
													<a class="indicator" name="Change in Population (from previous year)" href="#">Change in Population</a>
												</li>
												<li>
													<a class="indicator" name="Births" href="#">Births</a>
												</li>
												<li>
													<a class="indicator" name="Deaths" href="#">Deaths</a>
												</li>
												<li>
													<a class="indicator" name="Natural Population Increase" href="#">Natural Population Increase</a>
												</li>
												<li>
													<a class="indicator" name="International Migration" href="#">International Migration</a>
												</li>
												<li>
													<a class="indicator" name="Domestic Migration" href="#">Domestic Migration</a>
												</li>
												<li>
													<a class="indicator" name="Net Migration" href="#">Net Migration</a>
												</li>
												<li>
													<a class="indicator" name="Birth Rate" href="#">Birth Rate</a>
												</li>
												<li>
													<a class="indicator" name="Death Rate" href="#">Death Rate</a>
												</li>
												<li>
													<a class="indicator" name="Natural Population Increase Rate" href="#">Natural Population Increase Rate</a>
												</li>
												<li>
													<a class="indicator" name="International Migration Rate" href="#">International Migration Rate</a>
												</li>
												<li>
													<a class="indicator" name="Domestic Migration Rate" href="#">Domestic Migration Rate</a>
												</li>
												<li>
													<a class="indicator" name="Net Migration Rate" href="#">Net Migration Rate</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Population Density">
											<a>Population Density</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Population Level" href="#">Population Level</a>
												</li>
												<li>
													<a class="indicator" name="Population Density" href="#">Population Density</a>
												</li>
												<li>
													<a class="indicator" name="Population Density Growth Rate (from previous year)" href="#">Population Density Growth Rate</a>
												</li>
												<li>
													<a class="indicator" name="Total Land Area" href="#">Total Land Area</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Population by Age/Gender">
											<a>Population by Age/Gender</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total Population Level" href="#">Total Population Level</a>
												</li>
												<li>
													<a class="indicator" name="Male Population" href="#">Male Population</a>
												</li>
												<li>
													<a class="indicator" name="Percent Male" href="#">Percent Male</a>
												</li>
												<li>
													<a class="indicator" name="Female Population" href="#">Female Population</a>
												</li>
												<li>
													<a class="indicator" name="Percent Female" href="#">Percent Female</a>
												</li>
												<li>
													<a class="indicator" name="Under 5 years old Population" href="#">Under 5 years old Population</a>
												</li>
												<li>
													<a class="indicator" name="Percent Under 5 years old" href="#">Percent Under 5 years old</a>
												</li>
												<li>
													<a class="indicator" name="5-14 years old Population" href="#">5-14 years old Population</a>
												</li>
												<li>
													<a class="indicator" name="Percent 5-14 years old" href="#">Percent 5-14 years old</a>
												</li>
												<li>
													<a class="indicator" name="15-24 years old Population" href="#">15-24 years old Population</a>
												</li>
												<li>
													<a class="indicator" name="Percent 15-24 years old" href="#">Percent 15-24 years old</a>
												</li>
												<li>
													<a class="indicator" name="25-64 years old Population" href="#">25-64 years old Population</a>
												</li>
												<li>
													<a class="indicator" name="Percent 25-64 years old" href="#">Percent 25-64 years old</a>
												</li>
												<li>
													<a class="indicator" name="65 years and older Population" href="#">65 years and older Population</a>
												</li>
												<li>
													<a class="indicator" name="Percent 65 years and older" href="#">Percent 65 years and older</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Population by Ethnicity">
											<a>Population by Ethnicity</a>
											<ul class="dropdown-menu">
												<!-- <li>
													<a class="indicator" name="Total Population" href="#">Total Population</a>
												</li> -->
												<li>
													<a class="indicator" name="White Population" href="#">White Population</a>
												</li>
												<li>
													<a class="indicator" name="Black or African American Population" href="#">Black or African American Population</a>
												</li>
												<li>
													<a class="indicator" name="American Indian and Alaskan Native Population" href="#">American Indian and Alaskan Native Population</a>
												</li>
												<li>
													<a class="indicator" name="Asian Population" href="#">Asian Population</a>
												</li>
												<li>
													<a class="indicator" name="Native Hawaiian and Other Pacific Islander Population" href="#">Native Hawaiian and Other Pacific Islander Population</a>
												</li>
												<li>
													<a class="indicator" name="Two or More Races Population" href="#">Two or More Races Population</a>
												</li>
												<li>
													<a class="indicator" name="Hispanic or Latino Origin Population" href="#">Hispanic or Latino Origin Population</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Economy">
									<a>Economy</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Household Income">
											<a>Household Income</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total Households" href="#">Total Households</a>
												</li>
												<li>
													<a class="indicator" name="Per Capita Income" href="#">Per Capita Income</a>
												</li>
												<li>
													<a class="indicator" name="Median Household Income" href="#">Median Household Income</a>
												</li>
												<li>
													<a class="indicator" name="Number of Households with Income Less than $10,000" href="#">Number of Households with Income Less than $10,000</a>
												</li>
												<li>
													<a class="indicator" name="Percent of Households with Income Less than $10,000" href="#">Percent of Households with Income Less than $10,000</a>
												</li>
												<li>
													<a class="indicator" name="Number of Households with Income Between $10,000 - $24,999" href="#">Number of Households with Income Between $10,000 - $24,999</a>
												</li>
												<li>
													<a class="indicator" name="Percent of Households with Income Between $10,000 - $24,999" href="#">Percent of Households with Income Between $10,000 - $24,999</a>
												</li>
												<li>
													<a class="indicator" name="Number of Households with Income Between $25,000 - $49,999" href="#">Number of Households with Income Between $25,000 - $49,999</a>
												</li>
												<li>
													<a class="indicator" name="Percent of Households with Income Between $25,000 - $49,999" href="#">Percent of Households with Income Between $25,000 - $49,999</a>
												</li>
												<li>
													<a class="indicator" name="Number of Households with Income Between $50,000 - $99,999" href="#">Number of Households with Income Between $50,000 - $99,999</a>
												</li>
												<li>
													<a class="indicator" name="Percent of Households with Income Between $50,000 - $99,999" href="#">Percent of Households with Income Between $50,000 - $99,999</a>
												</li>
												<li>
													<a class="indicator" name="Number of Households with Income Between $100,000 - $199,999" href="#">Number of Households with Income Between $100,000 - $199,999</a>
												</li>
												<li>
													<a class="indicator" name="Percent of Households with Income Between $100,000 - $199,999" href="#">Percent of Households with Income Between $100,000 - $199,999</a>
												</li>
												<li>
													<a class="indicator" name="Number of Households with Income of $200,000 or more" href="#">Number of Households with Income of $200,000 or more</a>
												</li>
												<li>
													<a class="indicator" name="Percent of Households with Income of $200,000 or more" href="#">Percent of Households with Income of $200,000 or more</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Labor Force">
											<a>Labor Force</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Civilian Labor Force Population" href="#">Civilian Labor Force Population</a>
												</li>
												<li>
													<a class="indicator" name="Number Employed" href="#">Number Employed</a>
												</li>
												<li>
													<a class="indicator" name="Number Unemployed" href="#">Number Unemployed</a>
												</li>
												<li>
													<a class="indicator" name="Unemployment Rate" href="#">Unemployment Rate</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Education">
									<a>Education</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Education Employment">
											<a>Education Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Education" href="#">Total Education</a>
												</li>
												<li>
													<a class="indicator" name="Elementary &amp; Secondary Education" href="#">Elementary &amp; Secondary Education</a>
												</li>
												<li>
													<a class="indicator" name="Higher Education" href="#">Higher Education</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Education Expenditures">
											<a>Education Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Education" href="#">Total Education</a>
												</li>
												<li>
													<a class="indicator" name="Elementary &amp; Secondary Education" href="#">Elementary &amp; Secondary Education</a>
												</li>
												<li>
													<a class="indicator" name="Higher Education" href="#">Higher Education</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Public Elementary &amp; Secondary Schools">
											<a>Public Elementary &amp; Secondary Schools</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Number of Districts" href="#">Number of Districts</a>
												</li>
												<li>
													<a class="indicator" name="Number Operational Schools" href="#">Number Operational Schools</a>
												</li>
												<li>
													<a class="indicator" name="Number of Local School Districts" href="#">Number of Local School Districts</a>
												</li>
												<li>
													<a class="indicator" name="Number of Federally-operated Institutions" href="#">Number of Federally-operated Institutions</a>
												</li>
												<li>
													<a class="indicator" name="Number of State-operated Institutions" href="#">Number of State-operated Institutions</a>
												</li>
												<li>
													<a class="indicator" name="Number of Charter School Agencies" href="#">Number of Charter School Agencies</a>
												</li>
												<li>
													<a class="indicator" name="Number of Other School Agencies" href="#">Number of Other School Agencies</a>
												</li>
												<li>
													<a class="indicator" name="Total Students" href="#">Total Students</a>
												</li>
												<li>
													<a class="indicator" name="FTE Teachers" href="#">FTE Teachers</a>
												</li>
												<li>
													<a class="indicator" name="Pupil/Teacher Ratio" href="#">Pupil/Teacher Ratio</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Colleges &amp; Universities">
											<a>Colleges &amp; Universities</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Number of Institutions" href="#">Number of Institutions</a>
												</li>
												<li>
													<a class="indicator" name="Number of Public Institutions" href="#">Number of Public Institutions</a>
												</li>
												<li>
													<a class="indicator" name="Number of less than 4 year Institutions" href="#">Number of less than 4 year Institutions</a>
												</li>
												<li>
													<a class="indicator" name="Number of 4 year or Higher Institutions" href="#">Number of 4 year or Higher Institutions</a>
												</li>
												<li>
													<a class="indicator" name="Total Enrollment" href="#">Total Enrollment</a>
												</li>
												<li>
													<a class="indicator" name="Male Enrollment" href="#">Male Enrollment</a>
												</li>
												<li>
													<a class="indicator" name="Female Enrollment" href="#">Female Enrollment</a>
												</li>
												<li>
													<a class="indicator" name="Average In-State Tuition" href="#">Average In-State Tuition</a>
												</li>
												<li>
													<a class="indicator" name="Average Out-of-State Tuition" href="#">Average Out-of-State Tuition</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Federal Funding">
									<a>Federal Funding</a>
									<ul class="dropdown-menu">
										<!-- <li class="dataset" name="American Dream Downpayment Initiative (ADDI)">
											<a>American Dream Downpayment Initiative (ADDI)</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="ADDI Amount" href="#">ADDI Amount</a>
												</li>
												<li>
													<a class="indicator" name="ADDI Annual Growth Rate (from previous year)" href="#">ADDI Annual Growth Rate</a>
												</li>
											</ul>
										</li> -->
										<li class="dataset" name="Community Development Block Grants (CDBG)">
											<a>Community Development Block Grants (CDBG)</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="CDBG Amount" href="#">CDBG Amount</a>
												</li>
												<li>
													<a class="indicator" name="CDBG Annual Growth Rate (from previous year)" href="#">CDBG Annual Growth Rate</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Emergency Shelter Grants (ESG)">
											<a>Emergency Shelter Grants (ESG)</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="ESG Amount" href="#">ESG Amount</a>
												</li>
												<li>
													<a class="indicator" name="ESG Annual Growth Rate (from previous year)" href="#">ESG Annual Growth Rate</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="HOME Investment Partnership Program">
											<a>HOME Investment Partnership Program</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="HOME Amount" href="#">HOME Amount</a>
												</li>
												<li>
													<a class="indicator" name="HOME Annual Growth Rate (from previous year)" href="#">HOME Annual Growth Rate</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Housing &amp; Urban Development Grants">
											<a>Housing &amp; Urban Development Grants</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total HUD Amount" href="#">Total HUD Amount</a>
												</li>
												<li>
													<a class="indicator" name="HUD Annual Growth Rate (from previous year)" href="#">HUD Annual Growth Rate</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Housing Opportunities for Persons with AIDS (HOPWA)">
											<a>Housing Opportunities for Persons with AIDS (HOPWA)</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="HOPWA Amount" href="#">HOPWA Amount</a>
												</li>
												<li>
													<a class="indicator" name="HOPWA Annual Growth Rate (from previous year)" href="#">HOPWA Annual Growth Rate</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Payment in Lieu of Taxes (PILT)">
											<a>Payment in Lieu of Taxes (PILT)</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="PILT Amount" href="#">PILT Amount</a>
												</li>
												<li>
													<a class="indicator" name="PILT Annual Growth Rate (from previous year)" href="#">PILT Annual Growth Rate</a>
												</li>
												<li>
													<a class="indicator" name="Total Federal Land Area" href="#">Total Federal Land Area</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Total County Area" href="#">Total County Area</a>
												</li> -->
												<li>
													<a class="indicator" name="Percent of Federal Land" href="#">Percent of Federal Land</a>
												</li>
												<li>
													<a class="indicator" name="PILT per Square Mile" href="#">PILT per Square Mile</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Secure Rural Schools (SRS)">
											<a>Secure Rural Schools (SRS)</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="SRS Amount" href="#">SRS Amount</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="State Criminal Alien Assistance Program (SCAAP)">
											<a>State Criminal Alien Assistance Program (SCAAP)</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="SCAAP Amount" href="#">SCAAP Amount</a>
												</li>
												<li>
													<a class="indicator" name="SCAAP Annual Growth Rate (from previous year)" href="#">SCAAP Annual Growth Rate</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="USDA Rural Development">
											<a>USDA Rural Development</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="USDA Total Amount" href="#">USDA Total Amount</a>
												</li>
												<li>
													<a class="indicator" name="USDA Total Annual Growth Rate (from previous year)" href="#">USDA Total Annual Growth Rate</a>
												</li>
												<li>
													<a class="indicator" name="USDA Grant Amount" href="#">USDA Grant Amount</a>
												</li>
												<li>
													<a class="indicator" name="USDA Loan Amount" href="#">USDA Loan Amount</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Geography">
									<a>Geography</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="County Profile">
											<a>County Profile</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Census Region" href="#">Census Region</a>
												</li>
												<li>
													<a class="indicator" name="County Seat" href="#">County Seat</a>
												</li>
												<li>
													<a class="indicator" name="Year Founded" href="#">Year Founded</a>
												</li>
												<li>
													<a class="indicator" name="Year Consolidated" href="#">Year Consolidated</a>
												</li>
												<li>
													<a class="indicator" name="Board Size" href="#">Board Size</a>
												</li>
												<li>
													<a class="indicator" name="County Square Mileage" href="#">County Square Mileage</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Fiscal Year End Date" href="#">Fiscal Year End Date</a>
												</li> -->
												<!-- <li>
													<a class="indicator" name="State Capitol" href="#">State Capitol</a>
												</li> -->
												<li>
													<a class="indicator" name="CBSA Title" href="#">CBSA Title</a>
												</li>
												<li>
													<a class="indicator" name="CBSA Code" href="#">CBSA Code</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Land &amp; Water Area">
											<a>Land &amp; Water Area</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total Square Miles" href="#">Total Square Miles</a>
												</li>
												<li>
													<a class="indicator" name="Total Land Square Miles" href="#">Total Land Square Miles</a>
												</li>
												<li>
													<a class="indicator" name="Total Water Square Miles" href="#">Total Water Square Miles</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Coastal Status" href="#">Coastal Status</a>
												</li> -->
												<li>
													<a class="indicator" name="Body of Water" href="#">Body of Water</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Metro-Micro Areas (MSA)">
											<a>Metro-Micro Areas (MSA)</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="CBSA Code" href="#">CBSA Code</a>
												</li>
												<li>
													<a class="indicator" name="CSA Code" href="#">CSA Code</a>
												</li>
												<li>
													<a class="indicator" name="CBSA Title" href="#">CBSA Title</a>
												</li>
												<li>
													<a class="indicator" name="CSA Title" href="#">CSA Title</a>
												</li>
												<li>
													<a class="indicator" name="Level of CBSA" href="#">Level of CBSA</a>
												</li>
												<li>
													<a class="indicator" name="County Status" href="#">County Status</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Health &amp; Hospitals">
									<a>Health &amp; Hospitals</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Health &amp; Hospitals Employment">
											<a>Health &amp; Hospitals Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Health &amp; Hospitals" href="#">Total Health &amp; Hospitals</a>
												</li>
												<li>
													<a class="indicator" name="Health" href="#">Health</a>
												</li>
												<li>
													<a class="indicator" name="Hospitals" href="#">Hospitals</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Health &amp; Hospitals Expenditures">
											<a>Health &amp; Hospitals Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Health &amp; Hospitals" href="#">Total Health &amp; Hospitals</a>
												</li>
												<li>
													<a class="indicator" name="Health" href="#">Health</a>
												</li>
												<li>
													<a class="indicator" name="Hospitals" href="#">Hospitals</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Hospitals">
											<a>Hospitals</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Number of Hospitals" href="#">Number of Hospitals</a>
												</li>
												<li>
													<a class="indicator" name="Number of City Facilities" href="#">Number of City Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of County Facilities" href="#">Number of County Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of City-County Facilities" href="#">Number of City-County Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of Hospital District Facilities" href="#">Number of Hospital District Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of Other Government Facilities" href="#">Number of Other Government Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of Proprietary Facilities" href="#">Number of Proprietary Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of Nonprofit Facilities" href="#">Number of Nonprofit Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of Beds" href="#">Number of Beds</a>
												</li>
												<li>
													<a class="indicator" name="Number of Employees" href="#">Number of Employees</a>
												</li>
												<li>
													<a class="indicator" name="Gross Revenue" href="#">Gross Revenue</a>
												</li>
												<li>
													<a class="indicator" name="Medicare Revenue" href="#">Medicare Revenue</a>
												</li>
												<li>
													<a class="indicator" name="Medicaid Revenue" href="#">Medicaid Revenue</a>
												</li>
												<li>
													<a class="indicator" name="Patient Days" href="#">Patient Days</a>
												</li>
												<li>
													<a class="indicator" name="Revenue per Bed" href="#">Revenue per Bed</a>
												</li>
												<li>
													<a class="indicator" name="Revenue per Patient Day" href="#">Revenue per Patient Day</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Nursing Homes">
											<a>Nursing Homes</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Number of Nursing Homes" href="#">Number of Nursing Homes</a>
												</li>
												<li>
													<a class="indicator" name="Number of City Facilities" href="#">Number of City Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of County Facilities" href="#">Number of County Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of City-County Facilities" href="#">Number of City-County Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of Hospital District Facilities" href="#">Number of Hospital District Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of Other Government Facilities" href="#">Number of Other Government Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of For Profit Facilities" href="#">Number of For Profit Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of Nonprofit Facilities" href="#">Number of Nonprofit Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of Certified Beds" href="#">Number of Certified Beds</a>
												</li>
												<li>
													<a class="indicator" name="Number of Residents" href="#">Number of Residents</a>
												</li>
												<li>
													<a class="indicator" name="Percent of Occupied Beds" href="#">Percent of Occupied Beds</a>
												</li>
												<li>
													<a class="indicator" name="Number of Continuing Care Retirement Facilities" href="#">Number of Continuing Care Retirement Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of Special Focus Facilities" href="#">Number of Special Focus Facilities</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Health Insurance">
											<a>Health Insurance</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Population Level" href="#">Population Level</a>
												</li>
												<li>
													<a class="indicator" name="Population Insured" href="#">Population Insured</a>
												</li>
												<li>
													<a class="indicator" name="Percent Insured" href="#">Percent Insured</a>
												</li>
												<li>
													<a class="indicator" name="Population Uninsured" href="#">Population Uninsured</a>
												</li>
												<li>
													<a class="indicator" name="Population with Private Health Insurance" href="#">Population with Private Health Insurance</a>
												</li>
												<li>
													<a class="indicator" name="Population with Public Health Insurance" href="#">Population with Public Health Insurance</a>
												</li>
												<li>
													<a class="indicator" name="Population Under 6" href="#">Population Under 6</a>
												</li>
												<li>
													<a class="indicator" name="Population Under 6 Insured" href="#">Population Under 6 Insured</a>
												</li>
												<li>
													<a class="indicator" name="Population Under 6 Uninsured" href="#">Population Under 6 Uninsured</a>
												</li>
												<li>
													<a class="indicator" name="Percent Under 6 Insured" href="#">Percent Under 6 Insured</a>
												</li>
												<li>
													<a class="indicator" name="Population 6-24" href="#">Population 6-24</a>
												</li>
												<li>
													<a class="indicator" name="Population 6-24 Insured" href="#">Population 6-24 Insured</a>
												</li>
												<li>
													<a class="indicator" name="Population 6-24 Uninsured" href="#">Population 6-24 Uninsured</a>
												</li>
												<li>
													<a class="indicator" name="Percent 6-24 Insured" href="#">Percent 6-24 Insured</a>
												</li>
												<li>
													<a class="indicator" name="Population 25-64" href="#">Population 25-64</a>
												</li>
												<li>
													<a class="indicator" name="Population 25-64 Insured" href="#">Population 25-64 Insured</a>
												</li>
												<li>
													<a class="indicator" name="Population 25-64 Uninsured" href="#">Population 25-64 Uninsured</a>
												</li>
												<li>
													<a class="indicator" name="Percent 25-64 Insured" href="#">Percent 25-64 Insured</a>
												</li>
												<li>
													<a class="indicator" name="Population 65 and Over" href="#">Population 65 and Over</a>
												</li>
												<li>
													<a class="indicator" name="Population 65 and Over Insured" href="#">Population 65 and Over Insured</a>
												</li>
												<li>
													<a class="indicator" name="Population 65 and Over Uninsured" href="#">Population 65 and Over Uninsured</a>
												</li>
												<li>
													<a class="indicator" name="Percent 65 and Over Insured" href="#">Percent 65 and Over Insured</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Housing &amp; Community Development">
									<a>Housing &amp; Community Development</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Housing &amp; Community Development Employment">
											<a>Housing &amp; Community Development Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Housing &amp; Community Development" href="#">Housing &amp; Community Development</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Housing &amp; Community Development Expenditures">
											<a>Housing &amp; Community Development Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Housing &amp; Community Development" href="#">Total Housing &amp; Community Development</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Housing Units">
											<a>Housing Units</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Population" href="#">Population</a>
												</li>
												<li>
													<a class="indicator" name="Number of Housing Units" href="#">Number of Housing Units</a>
												</li>
												<li>
													<a class="indicator" name="Average Household Size" href="#">Average Household Size</a>
												</li>
												<li>
													<a class="indicator" name="Occupied Housing Units" href="#">Occupied Housing Units</a>
												</li>
												<li>
													<a class="indicator" name="Owner-Occupied Housing Units" href="#">Owner-Occupied Housing Units</a>
												</li>
												<li>
													<a class="indicator" name="Percent of Owner-Occupied Housing Units" href="#">Percent of Owner-Occupied Housing Units</a>
												</li>
												<li>
													<a class="indicator" name="Renter-Occupied Housing Units" href="#">Renter-Occupied Housing Units</a>
												</li>
												<li>
													<a class="indicator" name="Percent of Renter-Occupied Housing Units" href="#">Percent of Renter-Occupied Housing Units</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" title="Justice & Public Safety">
									<a>Justice &amp; Public Safety</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Justice & Public Safety Employment">
											<a>Justice &amp; Public Safety Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Justice & Public Safety" href="#">Total Justice &amp; Public Safety</a>
												</li>
												<li>
													<a class="indicator" name="Correction" href="#">Correction</a>
												</li>
												<li>
													<a class="indicator" name="Judicial &amp; Legal Services" href="#">Judicial &amp; Legal Services</a>
												</li>
												<li>
													<a class="indicator" name="Police Protection" href="#">Police Protection</a>
												</li>
												<li>
													<a class="indicator" name="Fire Protection" href="#">Fire Protection</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Justice & Public Safety Expenditures">
											<a>Justice &amp; Public Safety Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Justice & Public Safety" href="#">Total Justice &amp; Public Safety</a>
												</li>
												<li>
													<a class="indicator" name="Correction" href="#">Correction</a>
												</li>
												<li>
													<a class="indicator" name="Judicial &amp; Legal Services" href="#">Judicial &amp; Legal Services</a>
												</li>
												<li>
													<a class="indicator" name="Police Protection" href="#">Police Protection</a>
												</li>
												<li>
													<a class="indicator" name="Fire Protection" href="#">Fire Protection</a>
												</li>
												<li>
													<a class="indicator" name="Protective Inspection" href="#">Protective Inspection</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Jails - Supervised Population">
											<a>Jails - Supervised Population</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total Jail Population" href="#">Total Jail Population</a>
												</li>
												<li>
													<a class="indicator" name="Jail Capacity" href="#">Jail Capacity</a>
												</li>
												<li>
													<a class="indicator" name="Confined Persons" href="#">Confined Persons</a>
												</li>
												<li>
													<a class="indicator" name="Nonconfined Persons" href="#">Nonconfined Persons</a>
												</li>
												<li>
													<a class="indicator" name="Non US Citizens" href="#">Non US Citizens</a>
												</li>
												<li>
													<a class="indicator" name="Weekenders" href="#">Weekenders</a>
												</li>
												<li>
													<a class="indicator" name="Average Daily Population" href="#">Average Daily Population</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Jails - Supervised Population by Agency">
											<a>Jails - Supervised Population by Agency</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total Jail Population" href="#">Total Jail Population</a>
												</li>
												<li>
													<a class="indicator" name="Jail Capacity" href="#">Jail Capacity</a>
												</li>
												<li>
													<a class="indicator" name="Held for US Marshals Service" href="#">Held for US Marshals Service</a>
												</li>
												<li>
													<a class="indicator" name="Held for Federal Bureau of Prisons" href="#">Held for Federal Bureau of Prisons</a>
												</li>
												<li>
													<a class="indicator" name="Held for Immigration &amp; Customs" href="#">Held for Immigration &amp; Customs</a>
												</li>
												<li>
													<a class="indicator" name="Held for Bureau of Indian Affairs" href="#">Held for Bureau of Indian Affairs</a>
												</li>
												<li>
													<a class="indicator" name="Held for Other Federal Authorities" href="#">Held for Other Federal Authorities</a>
												</li>
												<li>
													<a class="indicator" name="Held for Own State" href="#">Held for Own State</a>
												</li>
												<li>
													<a class="indicator" name="Held for Other State" href="#">Held for Other State</a>
												</li>
												<li>
													<a class="indicator" name="Held for Local Jurisdiction in State" href="#">Held for Local Jurisdiction in State</a>
												</li>
												<li>
													<a class="indicator" name="Held for Local Jurisdiction outside the State" href="#">Held for Local Jurisdiction outside the State</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Jails - Inmate Demographics">
											<a>Jails - Inmate Demographics</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total Jail Population" href="#">Total Jail Population</a>
												</li>
												<li>
													<a class="indicator" name="Adult Males" href="#">Adult Males</a>
												</li>
												<li>
													<a class="indicator" name="Adult Females" href="#">Adult Females</a>
												</li>
												<li>
													<a class="indicator" name="Total Juveniles" href="#">Total Juveniles</a>
												</li>
												<li>
													<a class="indicator" name="Total Convicted" href="#">Total Convicted</a>
												</li>
												<li>
													<a class="indicator" name="Total Unconvicted" href="#">Total Unconvicted</a>
												</li>
												<li>
													<a class="indicator" name="White" href="#">White</a>
												</li>
												<li>
													<a class="indicator" name="Black or African American" href="#">Black or African American</a>
												</li>
												<li>
													<a class="indicator" name="Hispanic or Latino" href="#">Hispanic or Latino</a>
												</li>
												<li>
													<a class="indicator" name="Asian" href="#">Asian</a>
												</li>
												<li>
													<a class="indicator" name="American Indian or Alaskan Native" href="#">American Indian or Alaskan Native</a>
												</li>
												<li>
													<a class="indicator" name="Native Hawaiian or Other Pacific Islander" href="#">Native Hawaiian or Other Pacific Islander</a>
												</li>
												<li>
													<a class="indicator" name="Two or More Races" href="#">Two or More Races</a>
												</li>
												<li>
													<a class="indicator" name="Other Inmate Races" href="#">Other Inmate Races</a>
												</li>
												<li>
													<a class="indicator" name="Race Not Known" href="#">Race Not Known</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Jails - Community Supervision">
											<a>Jails - Community Supervision</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total Jail Population" href="#">Total Jail Population</a>
												</li>
												<li>
													<a class="indicator" name="Jail Capacity" href="#">Jail Capacity</a>
												</li>
												<li>
													<a class="indicator" name="Confined Persons" href="#">Confined Persons</a>
												</li>
												<li>
													<a class="indicator" name="Nonconfined Persons" href="#">Nonconfined Persons</a>
												</li>
												<li>
													<a class="indicator" name="Electronic Monitoring Program" href="#">Electronic Monitoring Program</a>
												</li>
												<li>
													<a class="indicator" name="Home Detention" href="#">Home Detention</a>
												</li>
												<li>
													<a class="indicator" name="Community Service" href="#">Community Service</a>
												</li>
												<li>
													<a class="indicator" name="Day Reporting" href="#">Day Reporting</a>
												</li>
												<li>
													<a class="indicator" name="Other Pretrial Supervision" href="#">Other Pretrial Supervision</a>
												</li>
												<li>
													<a class="indicator" name="Other Alternative Work Programs" href="#">Other Alternative Work Programs</a>
												</li>
												<li>
													<a class="indicator" name="Alcohol/Drug Treatment Programs" href="#">Alcohol/Drug Treatment Programs</a>
												</li>
												<li>
													<a class="indicator" name="Other Nonconfined Programs" href="#">Other Nonconfined Programs</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Public Safety Structure">
											<a>Public Safety Structure</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Elected Sheriff" href="#">Elected Sheriff</a>
												</li>
												<li>
													<a class="indicator" name="County Funded Sheriff Department" href="#">County Funded Sheriff Department</a>
												</li>
												<li>
													<a class="indicator" name="County Operated Sheriff Department" href="#">County Operated Sheriff Department</a>
												</li>
												<li>
													<a class="indicator" name="Elected Police Chief" href="#">Elected Police Chief</a>
												</li>
												<li>
													<a class="indicator" name="County Funded Police Department" href="#">County Funded Police Department</a>
												</li>
												<li>
													<a class="indicator" name="County Operated Police Department" href="#">County Operated Police Department</a>
												</li>
												<li>
													<a class="indicator" name="County Funded Jails" href="#">County Funded Jails</a>
												</li>
												<li>
													<a class="indicator" name="County Operated Jails" href="#">County Operated Jails</a>
												</li>
												<li>
													<a class="indicator" name="County Funded Courts - Salaries" href="#">County Funded Courts - Salaries</a>
												</li>
												<li>
													<a class="indicator" name="County Funded Courts - Buildings/Real Property" href="#">County Funded Courts - Buildings/Real Property</a>
												</li>
												<li>
													<a class="indicator" name="County Funded Courts - General Operating Expenses" href="#">County Funded Courts - General Operating Expenses</a>
												</li>
												<li>
													<a class="indicator" name="County Operated Courts" href="#">County Operated Courts</a>
												</li>
												<li>
													<a class="indicator" name="Elected Judges" href="#">Elected Judges</a>
												</li>
												<li>
													<a class="indicator" name="Elected Clerks of Court" href="#">Elected Clerks of Court</a>
												</li>
												<li>
													<a class="indicator" name="Elected District Attorney" href="#">Elected District Attorney</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Public Amenities">
									<a>Public Amenities</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Public Amenity Employment">
											<a>Public Amenity Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Public Amenity" href="#">Total Public Amenity</a>
												</li>
												<li>
													<a class="indicator" name="Libraries" href="#">Libraries</a>
												</li>
												<li>
													<a class="indicator" name="Natural Resources" href="#">Natural Resources</a>
												</li>
												<li>
													<a class="indicator" name="Parks &amp; Recreation" href="#">Parks &amp; Recreation</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Public Amenity Expenditures">
											<a>Public Amenity Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Public Amenity" href="#">Total Public Amenity</a>
												</li>
												<li>
													<a class="indicator" name="Libraries" href="#">Libraries</a>
												</li>
												<li>
													<a class="indicator" name="Natural Resources" href="#">Natural Resources</a>
												</li>
												<li>
													<a class="indicator" name="Parks &amp; Recreation" href="#">Parks &amp; Recreation</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Libraries">
											<a>Libraries</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Number of Central Service Outlets" href="#">Number of Central Service Outlets</a>
												</li>
												<li>
													<a class="indicator" name="Number of Branches" href="#">Number of Branches</a>
												</li>
												<li>
													<a class="indicator" name="Number of Bookmobiles" href="#">Number of Bookmobiles</a>
												</li>
												<li>
													<a class="indicator" name="Population of Local Service Area" href="#">Population of Local Service Area</a>
												</li>
												<li>
													<a class="indicator" name="Full Time Librarians" href="#">Full Time Librarians</a>
												</li>
												<li>
													<a class="indicator" name="Total FTE Staff" href="#">Total FTE Staff</a>
												</li>
												<li>
													<a class="indicator" name="Annual Hours - All Outlets" href="#">Annual Hours - All Outlets</a>
												</li>
												<li>
													<a class="indicator" name="Total Operating Revenue" href="#">Total Operating Revenue</a>
												</li>
												<li>
													<a class="indicator" name="Operating Revenue from Local Government" href="#">Operating Revenue from Local Government</a>
												</li>
												<li>
													<a class="indicator" name="Operating Revenue from State Government" href="#">Operating Revenue from State Government</a>
												</li>
												<li>
													<a class="indicator" name="Operating Revenue from Federal Government" href="#">Operating Revenue from Federal Government</a>
												</li>
												<li>
													<a class="indicator" name="Other Operating Revenue" href="#">Other Operating Revenue</a>
												</li>
												<li>
													<a class="indicator" name="Operating Expenditures Salaries and Benefits" href="#">Operating Expenditures Salaries and Benefits</a>
												</li>
												<li>
													<a class="indicator" name="Operating Expenditures Library Collections" href="#">Operating Expenditures Library Collections</a>
												</li>
												<li>
													<a class="indicator" name="Other Operating Expenditures" href="#">Other Operating Expenditures</a>
												</li>
												<li>
													<a class="indicator" name="Total Operating Expenditures" href="#">Total Operating Expenditures</a>
												</li>
												<li>
													<a class="indicator" name="Total Capital Revenue" href="#">Total Capital Revenue</a>
												</li>
												<li>
													<a class="indicator" name="Total Capital Expenditures" href="#">Total Capital Expenditures</a>
												</li>
												<li>
													<a class="indicator" name="Library Collections - Number of Print Materials" href="#">Library Collections - Number of Print Materials</a>
												</li>
												<li>
													<a class="indicator" name="Library Collections - Number of Electronic Books" href="#">Library Collections - Number of Electronic Books</a>
												</li>
												<li>
													<a class="indicator" name="Library Collections - Number of Audio Materials" href="#">Library Collections - Number of Audio Materials</a>
												</li>
												<li>
													<a class="indicator" name="Library Collections - Number of Video Materials" href="#">Library Collections - Number of Video Materials</a>
												</li>
												<li>
													<a class="indicator" name="Total Annual Visits" href="#">Total Annual Visits</a>
												</li>
												<li>
													<a class="indicator" name="Total Annual Circulation" href="#">Total Annual Circulation</a>
												</li>
												<li>
													<a class="indicator" name="Number of Computers Available" href="#">Number of Computers Available</a>
												</li>
												<li>
													<a class="indicator" name="Number of Computer Users" href="#">Number of Computer Users</a>
												</li>
												<li>
													<a class="indicator" name="Number of Licensed Databases" href="#">Number of Licensed Databases</a>
												</li>
												<li>
													<a class="indicator" name="Registered Borrowers" href="#">Registered Borrowers</a>
												</li>
												<li>
													<a class="indicator" name="Total Programs" href="#">Total Programs</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Public Welfare">
									<a>Public Welfare</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Public Welfare Employment">
											<a>Public Welfare Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Public Welfare" href="#">Public Welfare</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Public Welfare Expenditures">
											<a>Public Welfare Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Public Welfare" href="#">Total Public Welfare</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Cash Assistance" href="#">Cash Assistance</a>
												</li>
												<li>
													<a class="indicator" name="Vendor Payments" href="#">Vendor Payments</a>
												</li> -->
												<li>
													<a class="indicator" name="Other Public Welfare" href="#">Other Public Welfare</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Assistance &amp; Subsidies" href="#">Assistance &amp; Subsidies</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Transportation">
									<a>Transportation</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Transportation Employment">
											<a>Transportation Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Transportation" href="#">Total Transportation</a>
												</li>
												<li>
													<a class="indicator" name="Air Transportation" href="#">Air Transportation</a>
												</li>
												<li>
													<a class="indicator" name="Highways" href="#">Highways</a>
												</li>
												<li>
													<a class="indicator" name="Water Transport &amp; Terminals" href="#">Water Transport &amp; Terminals</a>
												</li>
												<li>
													<a class="indicator" name="Transit" href="#">Transit</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Transportation Expenditures">
											<a>Transportation Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Transportation" href="#">Total Transportation</a>
												</li>
												<li>
													<a class="indicator" name="Air Transportation" href="#">Air Transportation</a>
												</li>
												<li>
													<a class="indicator" name="Highways" href="#">Highways</a>
												</li>
												<li>
													<a class="indicator" name="Parking Facilities" href="#">Parking Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Sea &amp; Inland Port" href="#">Sea &amp; Inland Port</a>
												</li>
												<li>
													<a class="indicator" name="Transit Utilities" href="#">Transit Utilities</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Interest on Debt" href="#">Interest on Debt</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Airports">
											<a>Airports</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Number of Airports" href="#">Number of Airports</a>
												</li>
												<li>
													<a class="indicator" name="Number of Publicly Owned Airports" href="#">Number of Publicly Owned Airports</a>
												</li>
												<li>
													<a class="indicator" name="Number of Privately Owned Airports" href="#">Number of Privately Owned Airports</a>
												</li>
												<li>
													<a class="indicator" name="Number of Military Owned Airports" href="#">Number of Military Owned Airports</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Bridges">
											<a>Bridges</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="All Bridges - Total Bridges" href="#">All Bridges - Total Bridges</a>
												</li>
												<li>
													<a class="indicator" name="All Bridges - City/Town Owned" href="#">All Bridges - City/Town Owned</a>
												</li>
												<li>
													<a class="indicator" name="All Bridges - County Owned" href="#">All Bridges - County Owned</a>
												</li>
												<li>
													<a class="indicator" name="All Bridges - Federal Owned" href="#">All Bridges - Federal Owned</a>
												</li>
												<li>
													<a class="indicator" name="All Bridges - Privately Owned" href="#">All Bridges - Privately Owned</a>
												</li>
												<li>
													<a class="indicator" name="All Bridges - State Owned" href="#">All Bridges - State Owned</a>
												</li>
												<!-- <li>
													<a class="indicator" name="All Bridges - Local Owned" href="#">All Bridges - Local Owned</a>
												</li> -->
												<li>
													<a class="indicator" name="Structurally Deficient Bridges - Total Bridges" href="#">Structurally Deficient Bridges - Total Bridges</a>
												</li>
												<li>
													<a class="indicator" name="Structurally Deficient Bridges - City/Town Owned" href="#">Structurally Deficient Bridges - City/Town Owned</a>
												</li>
												<li>
													<a class="indicator" name="Structurally Deficient Bridges - County Owned" href="#">Structurally Deficient Bridges - County Owned</a>
												</li>
												<li>
													<a class="indicator" name="Structurally Deficient Bridges - Federal Owned" href="#">Structurally Deficient Bridges - Federal Owned</a>
												</li>
												<li>
													<a class="indicator" name="Structurally Deficient Bridges - Privately Owned" href="#">Structurally Deficient Bridges - Privately Owned</a>
												</li>
												<li>
													<a class="indicator" name="Structurally Deficient Bridges - State Owned" href="#">Structurally Deficient Bridges - State Owned</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Structurally Deficient Bridges - Local Owned" href="#">Structurally Deficient Bridges - Local Owned</a>
												</li> -->
												<li>
													<a class="indicator" name="Functionally Obsolete Bridges - Total Bridges" href="#">Functionally Obsolete Bridges - Total Bridges</a>
												</li>
												<li>
													<a class="indicator" name="Functionally Obsolete Bridges - City/Town Owned" href="#">Functionally Obsolete Bridges - City/Town Owned</a>
												</li>
												<li>
													<a class="indicator" name="Functionally Obsolete Bridges - County Owned" href="#">Functionally Obsolete Bridges - County Owned</a>
												</li>
												<li>
													<a class="indicator" name="Functionally Obsolete Bridges - Federal Owned" href="#">Functionally Obsolete Bridges - Federal Owned</a>
												</li>
												<li>
													<a class="indicator" name="Functionally Obsolete Bridges - Privately Owned" href="#">Functionally Obsolete Bridges - Privately Owned</a>
												</li>
												<li>
													<a class="indicator" name="Functionally Obsolete Bridges - State Owned" href="#">Functionally Obsolete Bridges - State Owned</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Functionally Obsolete Bridges - Local Owned" href="#">Functionally Obsolete Bridges - Local Owned</a>
												</li> -->
											</ul>
										</li>
										<li class="dataset" name="Road Classification">
											<a>Road Classification</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total Public Road Miles" href="#">Total Public Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Interstate Road Miles" href="#">Interstate Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Other Freeway/Expressway Road Miles" href="#">Other Freeway/Expressway Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Other Principle Arterial Road Miles" href="#">Other Principle Arterial Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Minor Arterial Road Miles" href="#">Minor Arterial Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Major Collector Road Miles" href="#">Major Collector Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Urban Minor Collector Road Miles" href="#">Urban Minor Collector Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Local Road Miles" href="#">Local Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Share Interstate" href="#">Share Interstate</a>
												</li>
												<li>
													<a class="indicator" name="Share Other Freeway/Expressway" href="#">Share Other Freeway/Expressway</a>
												</li>
												<li>
													<a class="indicator" name="Share Other Principle Arterial" href="#">Share Other Principle Arterial</a>
												</li>
												<li>
													<a class="indicator" name="Share Minor Arterial" href="#">Share Minor Arterial</a>
												</li>
												<li>
													<a class="indicator" name="Share Major Collector" href="#">Share Major Collector</a>
												</li>
												<li>
													<a class="indicator" name="Share Urban Minor Collector" href="#">Share Urban Minor Collector</a>
												</li>
												<li>
													<a class="indicator" name="Share Local" href="#">Share Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Road Ownership">
											<a>Road Ownership</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total Public Road Miles" href="#">Total Public Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="State Highway Agency Road Miles" href="#">State Highway Agency Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="County Highway Agency Road Miles" href="#">County Highway Agency Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Other State Agency Road Miles" href="#">Other State Agency Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Other Local Agency Road Miles" href="#">Other Local Agency Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Privately Owned Road Miles" href="#">Privately Owned Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Town or Township Highway Agency Road Miles" href="#">Town or Township Highway Agency Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="City or Municipal Highway Agency Road Miles" href="#">City or Municipal Highway Agency Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Other Public Instrumentality Road Miles" href="#">Other Public Instrumentality Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Indian Tribe/Nation Road Miles" href="#">Indian Tribe/Nation Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Federal Agency Road Miles" href="#">Federal Agency Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="County Land Square Miles" href="#">County Land Square Miles</a>
												</li>
												<li>
													<a class="indicator" name="Total Road Miles per Square Mile" href="#">Total Road Miles per Square Mile</a>
												</li>
												<li>
													<a class="indicator" name="Total County Road Miles per Square Mile" href="#">Total County Road Miles per Square Mile</a>
												</li>
												<li>
													<a class="indicator" name="Unknown Road Miles" href="#">Unknown Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Share State Highway Agency" href="#">Share State Highway Agency</a>
												</li>
												<li>
													<a class="indicator" name="Share County Highway Agency" href="#">Share County Highway Agency</a>
												</li>
												<li>
													<a class="indicator" name="Share Other State Agencies" href="#">Share Other State Agencies</a>
												</li>
												<li>
													<a class="indicator" name="Share Other Local Agencies" href="#">Share Other Local Agencies</a>
												</li>
												<li>
													<a class="indicator" name="Share Private" href="#">Share Private</a>
												</li>
												<li>
													<a class="indicator" name="Share Town or Township Highway Agency" href="#">Share Town or Township Highway Agency</a>
												</li>
												<li>
													<a class="indicator" name="Share City or Municipal Highway Agency" href="#">Share City or Municipal Highway Agency</a>
												</li>
												<li>
													<a class="indicator" name="Share Other Public Instrumentality" href="#">Share Other Public Instrumentality</a>
												</li>
												<li>
													<a class="indicator" name="Share Indian Tribe/Nation" href="#">Share Indian Tribe/Nation</a>
												</li>
												<li>
													<a class="indicator" name="Share Federal Agency" href="#">Share Federal Agency</a>
												</li>
												<li>
													<a class="indicator" name="Share Unknown" href="#">Share Unknown</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Utility">
									<a>Utility</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Utility Employment">
											<a>Utility Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Utility" href="#">Total Utility</a>
												</li>
												<li>
													<a class="indicator" name="Electric Utilities" href="#">Electric Utilities</a>
												</li>
												<li>
													<a class="indicator" name="Gas Utilities" href="#">Gas Utilities</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Utility Revenue">
											<a>Utility Revenue</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Utility" href="#">Total Utility</a>
												</li>
												<li>
													<a class="indicator" name="Electric Power Systems" href="#">Electric Power Systems</a>
												</li>
												<li>
													<a class="indicator" name="Gas Supply Systems" href="#">Gas Supply Systems</a>
												</li>
												<li>
													<a class="indicator" name="Public Mass Transit Systems" href="#">Public Mass Transit Systems</a>
												</li>
												<li>
													<a class="indicator" name="Water Supply Systems" href="#">Water Supply Systems</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Utility Expenditures">
											<a>Utility Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Utility" href="#">Total Utility</a>
												</li>
												<li>
													<a class="indicator" name="Electric Utilities" href="#">Electric Utilities</a>
												</li>
												<li>
													<a class="indicator" name="Gas Utilities" href="#">Gas Utilities</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Interest on Debt" href="#">Interest on Debt</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Water, Sewerage &amp; Solid Waste Management">
									<a>Water, Sewerage &amp; Solid Waste Management</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Water, Sewerage &amp; Solid Waste Employment">
											<a>Water, Sewerage &amp; Solid Waste Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Water, Sewerage &amp; Solid Waste" href="#">Total Water, Sewerage &amp; Solid Waste</a>
												</li>
												<li>
													<a class="indicator" name="Sewerage" href="#">Sewerage</a>
												</li>
												<li>
													<a class="indicator" name="Solid Waste" href="#">Solid Waste</a>
												</li>
												<li>
													<a class="indicator" name="Water Utilities" href="#">Water Utilities</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Water, Sewerage &amp; Solid Waste Expenditures">
											<a>Water, Sewerage &amp; Solid Waste Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Water, Sewerage &amp; Solid Waste Management" href="#">Total Water, Sewerage &amp; Solid Waste Management</a>
												</li>
												<li>
													<a class="indicator" name="Sewerage" href="#">Sewerage</a>
												</li>
												<li>
													<a class="indicator" name="Solid Waste" href="#">Solid Waste</a>
												</li>
												<li>
													<a class="indicator" name="Water Utilities" href="#">Water Utilities</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Interest on Debt" href="#">Interest on Debt</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
							</ul>
						</li>
				    </ul>
				    <ul class="nav navbar-nav">
						<li id="secondIndLi">
							<a id="secondIndText">Secondary Indicator</a>
							<ul id="secondInd" class="dropdown-menu">
								<li class="category" name="Administration">
									<a>Administration</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Administration Expenditures">
											<a>Administration Expenditures<!-- <span class="badge">new</span> --></a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Administration" href="#">Total Administration</a>
												</li>
												<li>
													<a class="indicator" name="Financial Administration" href="#">Financial Administration</a>
												</li>
												<li>
													<a class="indicator" name="Other Governmental Administration" href="#">Other Governmental Administration</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Social Insurance Administration" href="#">Social Insurance Administration</a>
												</li> -->
												<!-- <li>
													<a class="indicator" name="Liquor Stores" href="#">Liquor Stores</a>
												</li> -->
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Administration Employment">
											<a>Administration Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Administration" href="#">Total Administration</a>
												</li>
												<li>
													<a class="indicator" name="Financial Administration" href="#">Financial Administration</a>
												</li>
												<li>
													<a class="indicator" name="Other Governmental Administration" href="#">Other Governmental Administration</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Social Insurance Administration" href="#">Social Insurance Administration</a>
												</li> -->
											</ul>
										</li>
										<li class="dataset" name="Administration Revenue">
											<a>Administration Revenue</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Administration" href="#">Total Administration</a>
												</li>
												<li>
													<a class="indicator" name="Charges" href="#">Charges</a>
												</li>
												<li>
													<a class="indicator" name="Misc. General Revenue" href="#">Misc. General Revenue</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Liquor Stores" href="#">Liquor Stores</a>
												</li> -->
												<li>
													<a class="indicator" name="Public Employee Retirement Systems" href="#">Public Employee Retirement Systems</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Unemployment Compensation Systems" href="#">Unemployment Compensation Systems</a>
												</li> -->
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="County Employment">
									<a>County Employment</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Administration Employment">
											<a>Administration Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Administration" href="#">Total Administration</a>
												</li>
												<li>
													<a class="indicator" name="Financial Administration" href="#">Financial Administration</a>
												</li>
												<li>
													<a class="indicator" name="Other Governmental Administration" href="#">Other Governmental Administration</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Social Insurance Administration" href="#">Social Insurance Administration</a>
												</li> -->
											</ul>
										</li>
										<li class="dataset" name="Public Amenity Employment">
											<a>Public Amenity Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Public Amenity" href="#">Total Public Amenity</a>
												</li>
												<li>
													<a class="indicator" name="Libraries" href="#">Libraries</a>
												</li>
												<li>
													<a class="indicator" name="Natural Resources" href="#">Natural Resources</a>
												</li>
												<li>
													<a class="indicator" name="Parks &amp; Recreation" href="#">Parks &amp; Recreation</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Education Employment">
											<a>Education Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Education" href="#">Total Education</a>
												</li>
												<li>
													<a class="indicator" name="Elementary &amp; Secondary Education" href="#">Elementary &amp; Secondary Education</a>
												</li>
												<li>
													<a class="indicator" name="Higher Education" href="#">Higher Education</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Housing &amp; Community Development Employment">
											<a>Housing &amp; Community Development Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Housing &amp; Community Development" href="#">Housing &amp; Community Development</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Health &amp; Hospitals Employment">
											<a>Health &amp; Hospitals Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Health &amp; Hospitals" href="#">Total Health &amp; Hospitals</a>
												</li>
												<li>
													<a class="indicator" name="Health" href="#">Health</a>
												</li>
												<li>
													<a class="indicator" name="Hospitals" href="#">Hospitals</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Justice &amp; Public Safety Employment">
											<a>Justice &amp; Public Safety Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Justice &amp; Public Safety" href="#">Total Justice &amp; Public Safety</a>
												</li>
												<li>
													<a class="indicator" name="Correction" href="#">Correction</a>
												</li>
												<li>
													<a class="indicator" name="Judicial &amp; Legal Services" href="#">Judicial &amp; Legal Services</a>
												</li>
												<li>
													<a class="indicator" name="Police Protection" href="#">Police Protection</a>
												</li>
												<li>
													<a class="indicator" name="Fire Protection" href="#">Fire Protection</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Public Welfare Employment">
											<a>Public Welfare Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Public Welfare" href="#">Public Welfare</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Transportation Employment">
											<a>Transportation Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Transportation" href="#">Total Transportation</a>
												</li>
												<li>
													<a class="indicator" name="Air Transportation" href="#">Air Transportation</a>
												</li>
												<li>
													<a class="indicator" name="Highways" href="#">Highways</a>
												</li>
												<li>
													<a class="indicator" name="Water Transport &amp; Terminals" href="#">Water Transport &amp; Terminals</a>
												</li>
												<li>
													<a class="indicator" name="Transit" href="#">Transit</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Utility Employment">
											<a>Utility Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Utility" href="#">Total Utility</a>
												</li>
												<li>
													<a class="indicator" name="Electric Utilities" href="#">Electric Utilities</a>
												</li>
												<li>
													<a class="indicator" name="Gas Utilities" href="#">Gas Utilities</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Water, Sewerage &amp; Solid Waste Employment">
											<a>Water, Sewerage &amp; Solid Waste Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Water, Sewerage &amp; Solid Waste" href="#">Total Water, Sewerage &amp; Solid Waste</a>
												</li>
												<li>
													<a class="indicator" name="Sewerage" href="#">Sewerage</a>
												</li>
												<li>
													<a class="indicator" name="Solid Waste" href="#">Solid Waste</a>
												</li>
												<li>
													<a class="indicator" name="Water Utilities" href="#">Water Utilities</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Other Employment">
											<a>Other Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Other &amp; Unallocable" href="#">Other &amp; Unallocable</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="County Finance">
									<a>County Finance</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Administration Revenue">
											<a>Administration Revenue</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Administration" href="#">Total Administration</a>
												</li>
												<li>
													<a class="indicator" name="Charges" href="#">Charges</a>
												</li>
												<li>
													<a class="indicator" name="Misc. General Revenue" href="#">Misc. General Revenue</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Liquor Stores" href="#">Liquor Stores</a>
												</li> -->
												<li>
													<a class="indicator" name="Public Employee Retirement Systems" href="#">Public Employee Retirement Systems</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Unemployment Compensation Systems" href="#">Unemployment Compensation Systems</a>
												</li> -->
											</ul>
										</li>
										<li class="dataset" name="Intergovernmental Revenue">
											<a>Intergovernmental Revenue</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Intergovernmental" href="#">Total Intergovernmental</a>
												</li>
												<li>
													<a class="indicator" name="From Federal Government" href="#">From Federal Government</a>
												</li>
												<li>
													<a class="indicator" name="From Local Government" href="#">From Local Government</a>
												</li>
												<li>
													<a class="indicator" name="From State Government" href="#">From State Government</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Tax Revenue">
											<a>Tax Revenue</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Taxes" href="#">Total Taxes</a>
												</li>
												<li>
													<a class="indicator" name="Income Taxes" href="#">Income Taxes</a>
												</li>
												<li>
													<a class="indicator" name="License Taxes" href="#">License Taxes</a>
												</li>
												<li>
													<a class="indicator" name="Other Taxes" href="#">Other Taxes</a>
												</li>
												<li>
													<a class="indicator" name="Property Taxes" href="#">Property Taxes</a>
												</li>
												<li>
													<a class="indicator" name="Sales &amp; Gross Receipts Taxes" href="#">Sales &amp; Gross Receipts Taxes</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Utility Revenue">
											<a>Utility Revenue</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Utility" href="#">Total Utility</a>
												</li>
												<li>
													<a class="indicator" name="Electric Power Systems" href="#">Electric Power Systems</a>
												</li>
												<li>
													<a class="indicator" name="Gas Supply Systems" href="#">Gas Supply Systems</a>
												</li>
												<li>
													<a class="indicator" name="Public Mass Transit Systems" href="#">Public Mass Transit Systems</a>
												</li>
												<li>
													<a class="indicator" name="Water Supply Systems" href="#">Water Supply Systems</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Administration Expenditures">
											<a>Administration Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Administration" href="#">Total Administration</a>
												</li>
												<li>
													<a class="indicator" name="Financial Administration" href="#">Financial Administration</a>
												</li>
												<li>
													<a class="indicator" name="Other Governmental Administration" href="#">Other Governmental Administration</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Social Insurance Administration" href="#">Social Insurance Administration</a>
												</li> -->
												<!-- <li>
													<a class="indicator" name="Liquor Stores" href="#">Liquor Stores</a>
												</li> -->
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Public Amenity Expenditures">
											<a>Public Amenity Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Public Amenity" href="#">Total Public Amenity</a>
												</li>
												<li>
													<a class="indicator" name="Libraries" href="#">Libraries</a>
												</li>
												<li>
													<a class="indicator" name="Natural Resources" href="#">Natural Resources</a>
												</li>
												<li>
													<a class="indicator" name="Parks &amp; Recreation" href="#">Parks &amp; Recreation</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Education Expenditures">
											<a>Education Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Education" href="#">Total Education</a>
												</li>
												<li>
													<a class="indicator" name="Elementary &amp; Secondary Education" href="#">Elementary &amp; Secondary Education</a>
												</li>
												<li>
													<a class="indicator" name="Higher Education" href="#">Higher Education</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Housing &amp; Community Development Expenditures">
											<a>Housing &amp; Community Development Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Housing &amp; Community Development" href="#">Total Housing &amp; Community Development</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Health &amp; Hospitals Expenditures">
											<a>Health &amp; Hospitals Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Health &amp; Hospitals" href="#">Total Health &amp; Hospitals</a>
												</li>
												<li>
													<a class="indicator" name="Health" href="#">Health</a>
												</li>
												<li>
													<a class="indicator" name="Hospitals" href="#">Hospitals</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Financial Expenditures">
											<a>Financial Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Financial" href="#">Total Financial</a>
												</li>
												<li>
													<a class="indicator" name="Interest on General Debt" href="#">Interest on General Debt</a>
												</li>
												<li>
													<a class="indicator" name="Insurance Trust - Employee Retirement" href="#">Insurance Trust - Employee Retirement</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Insurance Trust - Unemployment" href="#">Insurance Trust - Unemployment</a>
												</li> -->
											</ul>
										</li>
										<li class="dataset" name="Justice &amp; Public Safety Expenditures">
											<a>Justice &amp; Public Safety Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Justice &amp; Public Safety" href="#">Total Justice &amp; Public Safety</a>
												</li>
												<li>
													<a class="indicator" name="Correction" href="#">Correction</a>
												</li>
												<li>
													<a class="indicator" name="Judicial &amp; Legal Services" href="#">Judicial &amp; Legal Services</a>
												</li>
												<li>
													<a class="indicator" name="Police Protection" href="#">Police Protection</a>
												</li>
												<li>
													<a class="indicator" name="Fire Protection" href="#">Fire Protection</a>
												</li>
												<li>
													<a class="indicator" name="Protective Inspection" href="#">Protective Inspection</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Public Welfare Expenditures">
											<a>Public Welfare Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Public Welfare" href="#">Total Public Welfare</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Cash Assistance" href="#">Cash Assistance</a>
												</li>
												<li>
													<a class="indicator" name="Vendor Payments" href="#">Vendor Payments</a>
												</li> -->
												<li>
													<a class="indicator" name="Other Public Welfare" href="#">Other Public Welfare</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Assistance &amp; Subsidies" href="#">Assistance &amp; Subsidies</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Transportation Expenditures">
											<a>Transportation Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Transportation" href="#">Total Transportation</a>
												</li>
												<li>
													<a class="indicator" name="Air Transportation" href="#">Air Transportation</a>
												</li>
												<li>
													<a class="indicator" name="Highways" href="#">Highways</a>
												</li>
												<li>
													<a class="indicator" name="Parking Facilities" href="#">Parking Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Sea &amp; Inland Port" href="#">Sea &amp; Inland Port</a>
												</li>
												<li>
													<a class="indicator" name="Transit Utilities" href="#">Transit Utilities</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Interest on Debt" href="#">Interest on Debt</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Utility Expenditures">
											<a>Utility Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Utility" href="#">Total Utility</a>
												</li>
												<li>
													<a class="indicator" name="Electric Utilities" href="#">Electric Utilities</a>
												</li>
												<li>
													<a class="indicator" name="Gas Utilities" href="#">Gas Utilities</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Interest on Debt" href="#">Interest on Debt</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Water, Sewerage &amp; Solid Waste Expenditures">
											<a>Water, Sewerage &amp; Solid Waste Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Water, Sewerage &amp; Solid Waste Management" href="#">Total Water, Sewerage &amp; Solid Waste Management</a>
												</li>
												<li>
													<a class="indicator" name="Sewerage" href="#">Sewerage</a>
												</li>
												<li>
													<a class="indicator" name="Solid Waste" href="#">Solid Waste</a>
												</li>
												<li>
													<a class="indicator" name="Water Utilities" href="#">Water Utilities</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Interest on Debt" href="#">Interest on Debt</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Other Expenditures">
											<a>Other Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Other" href="#">Total Other</a>
												</li>
												<li>
													<a class="indicator" name="Misc. Commercial Activities" href="#">Misc. Commercial Activities</a>
												</li>
												<li>
													<a class="indicator" name="Other &amp; Unallocable" href="#">Other &amp; Unallocable</a>
												</li>
												<li>
													<a class="indicator" name="General Public Buildings" href="#">General Public Buildings</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Annual Financial Report - Revenue">
											<a>Annual Financial Report - Revenue</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Taxes" href="#">Total Taxes</a>
												</li>
												<li>
													<a class="indicator" name="Licenses and Permits" href="#">Licenses and Permits</a>
												</li>
												<li>
													<a class="indicator" name="Fines, Fees &amp; Forfeits" href="#">Fines, Fees &amp; Forfeits</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental" href="#">Intergovernmental</a>
												</li>
												<li>
													<a class="indicator" name="Use of Money &amp; Property" href="#">Use of Money &amp; Property</a>
												</li>
												<li>
													<a class="indicator" name="Investment Earnings" href="#">Investment Earnings</a>
												</li>
												<li>
													<a class="indicator" name="Charges for Services" href="#">Charges for Services</a>
												</li>
												<li>
													<a class="indicator" name="Other" href="#">Other</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Annual Financial Report - Expenses">
											<a>Annual Financial Report - Expenses</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="General Government" href="#">General Government</a>
												</li>
												<li>
													<a class="indicator" name="Public Works, Buildings &amp; Transportation" href="#">Public Works, Buildings &amp; Transportation</a>
												</li>
												<li>
													<a class="indicator" name="Public Safety &amp; Court Related" href="#">Public Safety &amp; Court Related</a>
												</li>
												<li>
													<a class="indicator" name="Health &amp; Human Services" href="#">Health &amp; Human Services</a>
												</li>
												<li>
													<a class="indicator" name="Education, Culture &amp; Recreation" href="#">Education, Culture &amp; Recreation</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental" href="#">Intergovernmental</a>
												</li>
												<li>
													<a class="indicator" name="Environmental Protection/Natural Resources" href="#">Environmental Protection/Natural Resources</a>
												</li>
												<li>
													<a class="indicator" name="Community &amp; Economic Development" href="#">Community &amp; Economic Development</a>
												</li>
												<li>
													<a class="indicator" name="Total Debt" href="#">Total Debt</a>
												</li>
												<li>
													<a class="indicator" name="Capital Projects" href="#">Capital Projects</a>
												</li>
												<li>
													<a class="indicator" name="Other" href="#">Other</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="County Tax Rates">
											<a>County Tax Rates</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Sales Tax" href="#">Sales Tax<span class="badge">new</span></a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="County Structure">
									<a>County Structure</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Government Structure">
											<a>Government Structure</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total Elected Officials" href="#">Total Elected Officials</a>
												</li>
												<li>
													<a class="indicator" name="Size of Board" href="#">Size of Board</a>
												</li>
												<!--<li>
													<a class="indicator" name="Elected Executive" href="#">Elected Executive</a>
												</li>-->
												<li>
													<a class="indicator" name="Number of Row Officers" href="#">Number of Row Officers</a>
												</li>
												<!--<li>
													<a class="indicator" name="County Administrator" href="#">County Administrator</a>
												</li>-->
											</ul>
										</li>
										<li class="dataset" name="City-County Consolidations">
											<a>City-County Consolidations</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Consolidation" href="#">Consolidation<span class="badge">new</span></a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Demographics">
									<a>Demographics</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Population Levels and Trends">
											<a>Population Levels and Trends</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Population Level" href="#">Population Level</a>
												</li>
												<li>
													<a class="indicator" name="Population Annual Growth Rate (from previous year)" href="#">Population Annual Growth Rate</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Population Change Components">
											<a>Population Change Components</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Population Level" href="#">Population Level</a>
												</li>
												<li>
													<a class="indicator" name="Change in Population (from previous year)" href="#">Change in Population</a>
												</li>
												<li>
													<a class="indicator" name="Births" href="#">Births</a>
												</li>
												<li>
													<a class="indicator" name="Deaths" href="#">Deaths</a>
												</li>
												<li>
													<a class="indicator" name="Natural Population Increase" href="#">Natural Population Increase</a>
												</li>
												<li>
													<a class="indicator" name="International Migration" href="#">International Migration</a>
												</li>
												<li>
													<a class="indicator" name="Domestic Migration" href="#">Domestic Migration</a>
												</li>
												<li>
													<a class="indicator" name="Net Migration" href="#">Net Migration</a>
												</li>
												<li>
													<a class="indicator" name="Birth Rate" href="#">Birth Rate</a>
												</li>
												<li>
													<a class="indicator" name="Death Rate" href="#">Death Rate</a>
												</li>
												<li>
													<a class="indicator" name="Natural Population Increase Rate" href="#">Natural Population Increase Rate</a>
												</li>
												<li>
													<a class="indicator" name="International Migration Rate" href="#">International Migration Rate</a>
												</li>
												<li>
													<a class="indicator" name="Domestic Migration Rate" href="#">Domestic Migration Rate</a>
												</li>
												<li>
													<a class="indicator" name="Net Migration Rate" href="#">Net Migration Rate</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Population Density">
											<a>Population Density</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Population Level" href="#">Population Level</a>
												</li>
												<li>
													<a class="indicator" name="Population Density" href="#">Population Density</a>
												</li>
												<li>
													<a class="indicator" name="Population Density Growth Rate (from previous year)" href="#">Population Density Growth Rate</a>
												</li>
												<li>
													<a class="indicator" name="Total Land Area" href="#">Total Land Area</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Population by Age/Gender">
											<a>Population by Age/Gender</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total Population Level" href="#">Total Population Level</a>
												</li>
												<li>
													<a class="indicator" name="Male Population" href="#">Male Population</a>
												</li>
												<li>
													<a class="indicator" name="Percent Male" href="#">Percent Male</a>
												</li>
												<li>
													<a class="indicator" name="Female Population" href="#">Female Population</a>
												</li>
												<li>
													<a class="indicator" name="Percent Female" href="#">Percent Female</a>
												</li>
												<li>
													<a class="indicator" name="Under 5 years old Population" href="#">Under 5 years old Population</a>
												</li>
												<li>
													<a class="indicator" name="Percent Under 5 years old" href="#">Percent Under 5 years old</a>
												</li>
												<li>
													<a class="indicator" name="5-14 years old Population" href="#">5-14 years old Population</a>
												</li>
												<li>
													<a class="indicator" name="Percent 5-14 years old" href="#">Percent 5-14 years old</a>
												</li>
												<li>
													<a class="indicator" name="15-24 years old Population" href="#">15-24 years old Population</a>
												</li>
												<li>
													<a class="indicator" name="Percent 15-24 years old" href="#">Percent 15-24 years old</a>
												</li>
												<li>
													<a class="indicator" name="25-64 years old Population" href="#">25-64 years old Population</a>
												</li>
												<li>
													<a class="indicator" name="Percent 25-64 years old" href="#">Percent 25-64 years old</a>
												</li>
												<li>
													<a class="indicator" name="65 years and older Population" href="#">65 years and older Population</a>
												</li>
												<li>
													<a class="indicator" name="Percent 65 years and older" href="#">Percent 65 years and older</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Population by Ethnicity">
											<a>Population by Ethnicity</a>
											<ul class="dropdown-menu">
												<!-- <li>
													<a class="indicator" name="Total Population" href="#">Total Population</a>
												</li> -->
												<li>
													<a class="indicator" name="White Population" href="#">White Population</a>
												</li>
												<li>
													<a class="indicator" name="Black or African American Population" href="#">Black or African American Population</a>
												</li>
												<li>
													<a class="indicator" name="American Indian and Alaskan Native Population" href="#">American Indian and Alaskan Native Population</a>
												</li>
												<li>
													<a class="indicator" name="Asian Population" href="#">Asian Population</a>
												</li>
												<li>
													<a class="indicator" name="Native Hawaiian and Other Pacific Islander Population" href="#">Native Hawaiian and Other Pacific Islander Population</a>
												</li>
												<li>
													<a class="indicator" name="Two or More Races Population" href="#">Two or More Races Population</a>
												</li>
												<li>
													<a class="indicator" name="Hispanic or Latino Origin Population" href="#">Hispanic or Latino Origin Population</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Economy">
									<a>Economy</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Household Income">
											<a>Household Income</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total Households" href="#">Total Households</a>
												</li>
												<li>
													<a class="indicator" name="Per Capita Income" href="#">Per Capita Income</a>
												</li>
												<li>
													<a class="indicator" name="Median Household Income" href="#">Median Household Income</a>
												</li>
												<li>
													<a class="indicator" name="Number of Households with Income Less than $10,000" href="#">Number of Households with Income Less than $10,000</a>
												</li>
												<li>
													<a class="indicator" name="Percent of Households with Income Less than $10,000" href="#">Percent of Households with Income Less than $10,000</a>
												</li>
												<li>
													<a class="indicator" name="Number of Households with Income Between $10,000 - $24,999" href="#">Number of Households with Income Between $10,000 - $24,999</a>
												</li>
												<li>
													<a class="indicator" name="Percent of Households with Income Between $10,000 - $24,999" href="#">Percent of Households with Income Between $10,000 - $24,999</a>
												</li>
												<li>
													<a class="indicator" name="Number of Households with Income Between $25,000 - $49,999" href="#">Number of Households with Income Between $25,000 - $49,999</a>
												</li>
												<li>
													<a class="indicator" name="Percent of Households with Income Between $25,000 - $49,999" href="#">Percent of Households with Income Between $25,000 - $49,999</a>
												</li>
												<li>
													<a class="indicator" name="Number of Households with Income Between $50,000 - $99,999" href="#">Number of Households with Income Between $50,000 - $99,999</a>
												</li>
												<li>
													<a class="indicator" name="Percent of Households with Income Between $50,000 - $99,999" href="#">Percent of Households with Income Between $50,000 - $99,999</a>
												</li>
												<li>
													<a class="indicator" name="Number of Households with Income Between $100,000 - $199,999" href="#">Number of Households with Income Between $100,000 - $199,999</a>
												</li>
												<li>
													<a class="indicator" name="Percent of Households with Income Between $100,000 - $199,999" href="#">Percent of Households with Income Between $100,000 - $199,999</a>
												</li>
												<li>
													<a class="indicator" name="Number of Households with Income of $200,000 or more" href="#">Number of Households with Income of $200,000 or more</a>
												</li>
												<li>
													<a class="indicator" name="Percent of Households with Income of $200,000 or more" href="#">Percent of Households with Income of $200,000 or more</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Labor Force">
											<a>Labor Force</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Civilian Labor Force Population" href="#">Civilian Labor Force Population</a>
												</li>
												<li>
													<a class="indicator" name="Number Employed" href="#">Number Employed</a>
												</li>
												<li>
													<a class="indicator" name="Number Unemployed" href="#">Number Unemployed</a>
												</li>
												<li>
													<a class="indicator" name="Unemployment Rate" href="#">Unemployment Rate</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Education">
									<a>Education</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Education Employment">
											<a>Education Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Education" href="#">Total Education</a>
												</li>
												<li>
													<a class="indicator" name="Elementary &amp; Secondary Education" href="#">Elementary &amp; Secondary Education</a>
												</li>
												<li>
													<a class="indicator" name="Higher Education" href="#">Higher Education</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Education Expenditures">
											<a>Education Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Education" href="#">Total Education</a>
												</li>
												<li>
													<a class="indicator" name="Elementary &amp; Secondary Education" href="#">Elementary &amp; Secondary Education</a>
												</li>
												<li>
													<a class="indicator" name="Higher Education" href="#">Higher Education</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Public Elementary &amp; Secondary Schools">
											<a>Public Elementary &amp; Secondary Schools</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Number of Districts" href="#">Number of Districts</a>
												</li>
												<li>
													<a class="indicator" name="Number Operational Schools" href="#">Number Operational Schools</a>
												</li>
												<li>
													<a class="indicator" name="Number of Local School Districts" href="#">Number of Local School Districts</a>
												</li>
												<li>
													<a class="indicator" name="Number of Federally-operated Institutions" href="#">Number of Federally-operated Institutions</a>
												</li>
												<li>
													<a class="indicator" name="Number of State-operated Institutions" href="#">Number of State-operated Institutions</a>
												</li>
												<li>
													<a class="indicator" name="Number of Charter School Agencies" href="#">Number of Charter School Agencies</a>
												</li>
												<li>
													<a class="indicator" name="Number of Other School Agencies" href="#">Number of Other School Agencies</a>
												</li>
												<li>
													<a class="indicator" name="Total Students" href="#">Total Students</a>
												</li>
												<li>
													<a class="indicator" name="FTE Teachers" href="#">FTE Teachers</a>
												</li>
												<li>
													<a class="indicator" name="Pupil/Teacher Ratio" href="#">Pupil/Teacher Ratio</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Colleges &amp; Universities">
											<a>Colleges &amp; Universities</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Number of Institutions" href="#">Number of Institutions</a>
												</li>
												<li>
													<a class="indicator" name="Number of Public Institutions" href="#">Number of Public Institutions</a>
												</li>
												<li>
													<a class="indicator" name="Number of less than 4 year Institutions" href="#">Number of less than 4 year Institutions</a>
												</li>
												<li>
													<a class="indicator" name="Number of 4 year or Higher Institutions" href="#">Number of 4 year or Higher Institutions</a>
												</li>
												<li>
													<a class="indicator" name="Total Enrollment" href="#">Total Enrollment</a>
												</li>
												<li>
													<a class="indicator" name="Male Enrollment" href="#">Male Enrollment</a>
												</li>
												<li>
													<a class="indicator" name="Female Enrollment" href="#">Female Enrollment</a>
												</li>
												<li>
													<a class="indicator" name="Average In-State Tuition" href="#">Average In-State Tuition</a>
												</li>
												<li>
													<a class="indicator" name="Average Out-of-State Tuition" href="#">Average Out-of-State Tuition</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Federal Funding">
									<a>Federal Funding</a>
									<ul class="dropdown-menu">
										<!-- <li class="dataset" name="American Dream Downpayment Initiative (ADDI)">
											<a>American Dream Downpayment Initiative (ADDI)</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="ADDI Amount" href="#">ADDI Amount</a>
												</li>
												<li>
													<a class="indicator" name="ADDI Annual Growth Rate (from previous year)" href="#">ADDI Annual Growth Rate</a>
												</li>
											</ul>
										</li> -->
										<li class="dataset" name="Community Development Block Grants (CDBG)">
											<a>Community Development Block Grants (CDBG)</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="CDBG Amount" href="#">CDBG Amount</a>
												</li>
												<li>
													<a class="indicator" name="CDBG Annual Growth Rate (from previous year)" href="#">CDBG Annual Growth Rate</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Emergency Shelter Grants (ESG)">
											<a>Emergency Shelter Grants (ESG)</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="ESG Amount" href="#">ESG Amount</a>
												</li>
												<li>
													<a class="indicator" name="ESG Annual Growth Rate (from previous year)" href="#">ESG Annual Growth Rate</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="HOME Investment Partnership Program">
											<a>HOME Investment Partnership Program</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="HOME Amount" href="#">HOME Amount</a>
												</li>
												<li>
													<a class="indicator" name="HOME Annual Growth Rate (from previous year)" href="#">HOME Annual Growth Rate</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Housing &amp; Urban Development Grants">
											<a>Housing &amp; Urban Development Grants</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total HUD Amount" href="#">Total HUD Amount</a>
												</li>
												<li>
													<a class="indicator" name="HUD Annual Growth Rate (from previous year)" href="#">HUD Annual Growth Rate</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Housing Opportunities for Persons with AIDS (HOPWA)">
											<a>Housing Opportunities for Persons with AIDS (HOPWA)</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="HOPWA Amount" href="#">HOPWA Amount</a>
												</li>
												<li>
													<a class="indicator" name="HOPWA Annual Growth Rate (from previous year)" href="#">HOPWA Annual Growth Rate</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Payment in Lieu of Taxes (PILT)">
											<a>Payment in Lieu of Taxes (PILT)</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="PILT Amount" href="#">PILT Amount</a>
												</li>
												<li>
													<a class="indicator" name="PILT Annual Growth Rate (from previous year)" href="#">PILT Annual Growth Rate</a>
												</li>
												<li>
													<a class="indicator" name="Total Federal Land Area" href="#">Total Federal Land Area</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Total County Area" href="#">Total County Area</a>
												</li> -->
												<li>
													<a class="indicator" name="Percent of Federal Land" href="#">Percent of Federal Land</a>
												</li>
												<li>
													<a class="indicator" name="PILT per Square Mile" href="#">PILT per Square Mile</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Secure Rural Schools (SRS)">
											<a>Secure Rural Schools (SRS)</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="SRS Amount" href="#">SRS Amount</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="State Criminal Alien Assistance Program (SCAAP)">
											<a>State Criminal Alien Assistance Program (SCAAP)</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="SCAAP Amount" href="#">SCAAP Amount</a>
												</li>
												<li>
													<a class="indicator" name="SCAAP Annual Growth Rate (from previous year)" href="#">SCAAP Annual Growth Rate</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="USDA Rural Development">
											<a>USDA Rural Development</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="USDA Total Amount" href="#">USDA Total Amount</a>
												</li>
												<li>
													<a class="indicator" name="USDA Total Annual Growth Rate (from previous year)" href="#">USDA Total Annual Growth Rate</a>
												</li>
												<li>
													<a class="indicator" name="USDA Grant Amount" href="#">USDA Grant Amount</a>
												</li>
												<li>
													<a class="indicator" name="USDA Loan Amount" href="#">USDA Loan Amount</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Geography">
									<a>Geography</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="County Profile">
											<a>County Profile</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Census Region" href="#">Census Region</a>
												</li>
												<li>
													<a class="indicator" name="County Seat" href="#">County Seat</a>
												</li>
												<li>
													<a class="indicator" name="Year Founded" href="#">Year Founded</a>
												</li>
												<li>
													<a class="indicator" name="Year Consolidated" href="#">Year Consolidated</a>
												</li>
												<li>
													<a class="indicator" name="Board Size" href="#">Board Size</a>
												</li>
												<li>
													<a class="indicator" name="County Square Mileage" href="#">County Square Mileage</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Fiscal Year End Date" href="#">Fiscal Year End Date</a>
												</li> -->
												<!-- <li>
													<a class="indicator" name="State Capitol" href="#">State Capitol</a>
												</li> -->
												<li>
													<a class="indicator" name="CBSA Title" href="#">CBSA Title</a>
												</li>
												<li>
													<a class="indicator" name="CBSA Code" href="#">CBSA Code</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Land &amp; Water Area">
											<a>Land &amp; Water Area</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total Square Miles" href="#">Total Square Miles</a>
												</li>
												<li>
													<a class="indicator" name="Total Land Square Miles" href="#">Total Land Square Miles</a>
												</li>
												<li>
													<a class="indicator" name="Total Water Square Miles" href="#">Total Water Square Miles</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Coastal Status" href="#">Coastal Status</a>
												</li> -->
												<li>
													<a class="indicator" name="Body of Water" href="#">Body of Water</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Metro-Micro Areas (MSA)">
											<a>Metro-Micro Areas (MSA)</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="CBSA Code" href="#">CBSA Code</a>
												</li>
												<li>
													<a class="indicator" name="CSA Code" href="#">CSA Code</a>
												</li>
												<li>
													<a class="indicator" name="CBSA Title" href="#">CBSA Title</a>
												</li>
												<li>
													<a class="indicator" name="CSA Title" href="#">CSA Title</a>
												</li>
												<li>
													<a class="indicator" name="Level of CBSA" href="#">Level of CBSA</a>
												</li>
												<li>
													<a class="indicator" name="County Status" href="#">County Status</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Health &amp; Hospitals">
									<a>Health &amp; Hospitals</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Health &amp; Hospitals Employment">
											<a>Health &amp; Hospitals Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Health &amp; Hospitals" href="#">Total Health &amp; Hospitals</a>
												</li>
												<li>
													<a class="indicator" name="Health" href="#">Health</a>
												</li>
												<li>
													<a class="indicator" name="Hospitals" href="#">Hospitals</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Health &amp; Hospitals Expenditures">
											<a>Health &amp; Hospitals Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Health &amp; Hospitals" href="#">Total Health &amp; Hospitals</a>
												</li>
												<li>
													<a class="indicator" name="Health" href="#">Health</a>
												</li>
												<li>
													<a class="indicator" name="Hospitals" href="#">Hospitals</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Hospitals">
											<a>Hospitals</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Number of Hospitals" href="#">Number of Hospitals</a>
												</li>
												<li>
													<a class="indicator" name="Number of City Facilities" href="#">Number of City Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of County Facilities" href="#">Number of County Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of City-County Facilities" href="#">Number of City-County Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of Hospital District Facilities" href="#">Number of Hospital District Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of Other Government Facilities" href="#">Number of Other Government Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of Proprietary Facilities" href="#">Number of Proprietary Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of Nonprofit Facilities" href="#">Number of Nonprofit Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of Beds" href="#">Number of Beds</a>
												</li>
												<li>
													<a class="indicator" name="Number of Employees" href="#">Number of Employees</a>
												</li>
												<li>
													<a class="indicator" name="Gross Revenue" href="#">Gross Revenue</a>
												</li>
												<li>
													<a class="indicator" name="Medicare Revenue" href="#">Medicare Revenue</a>
												</li>
												<li>
													<a class="indicator" name="Medicaid Revenue" href="#">Medicaid Revenue</a>
												</li>
												<li>
													<a class="indicator" name="Patient Days" href="#">Patient Days</a>
												</li>
												<li>
													<a class="indicator" name="Revenue per Bed" href="#">Revenue per Bed</a>
												</li>
												<li>
													<a class="indicator" name="Revenue per Patient Day" href="#">Revenue per Patient Day</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Nursing Homes">
											<a>Nursing Homes</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Number of Nursing Homes" href="#">Number of Nursing Homes</a>
												</li>
												<li>
													<a class="indicator" name="Number of City Facilities" href="#">Number of City Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of County Facilities" href="#">Number of County Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of City-County Facilities" href="#">Number of City-County Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of Hospital District Facilities" href="#">Number of Hospital District Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of Other Government Facilities" href="#">Number of Other Government Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of For Profit Facilities" href="#">Number of For Profit Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of Nonprofit Facilities" href="#">Number of Nonprofit Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of Certified Beds" href="#">Number of Certified Beds</a>
												</li>
												<li>
													<a class="indicator" name="Number of Residents" href="#">Number of Residents</a>
												</li>
												<li>
													<a class="indicator" name="Percent of Occupied Beds" href="#">Percent of Occupied Beds</a>
												</li>
												<li>
													<a class="indicator" name="Number of Continuing Care Retirement Facilities" href="#">Number of Continuing Care Retirement Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Number of Special Focus Facilities" href="#">Number of Special Focus Facilities</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Health Insurance">
											<a>Health Insurance</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Population Level" href="#">Population Level</a>
												</li>
												<li>
													<a class="indicator" name="Population Insured" href="#">Population Insured</a>
												</li>
												<li>
													<a class="indicator" name="Percent Insured" href="#">Percent Insured</a>
												</li>
												<li>
													<a class="indicator" name="Population Uninsured" href="#">Population Uninsured</a>
												</li>
												<li>
													<a class="indicator" name="Population with Private Health Insurance" href="#">Population with Private Health Insurance</a>
												</li>
												<li>
													<a class="indicator" name="Population with Public Health Insurance" href="#">Population with Public Health Insurance</a>
												</li>
												<li>
													<a class="indicator" name="Population Under 6" href="#">Population Under 6</a>
												</li>
												<li>
													<a class="indicator" name="Population Under 6 Insured" href="#">Population Under 6 Insured</a>
												</li>
												<li>
													<a class="indicator" name="Population Under 6 Uninsured" href="#">Population Under 6 Uninsured</a>
												</li>
												<li>
													<a class="indicator" name="Percent Under 6 Insured" href="#">Percent Under 6 Insured</a>
												</li>
												<li>
													<a class="indicator" name="Population 6-24" href="#">Population 6-24</a>
												</li>
												<li>
													<a class="indicator" name="Population 6-24 Insured" href="#">Population 6-24 Insured</a>
												</li>
												<li>
													<a class="indicator" name="Population 6-24 Uninsured" href="#">Population 6-24 Uninsured</a>
												</li>
												<li>
													<a class="indicator" name="Percent 6-24 Insured" href="#">Percent 6-24 Insured</a>
												</li>
												<li>
													<a class="indicator" name="Population 25-64" href="#">Population 25-64</a>
												</li>
												<li>
													<a class="indicator" name="Population 25-64 Insured" href="#">Population 25-64 Insured</a>
												</li>
												<li>
													<a class="indicator" name="Population 25-64 Uninsured" href="#">Population 25-64 Uninsured</a>
												</li>
												<li>
													<a class="indicator" name="Percent 25-64 Insured" href="#">Percent 25-64 Insured</a>
												</li>
												<li>
													<a class="indicator" name="Population 65 and Over" href="#">Population 65 and Over</a>
												</li>
												<li>
													<a class="indicator" name="Population 65 and Over Insured" href="#">Population 65 and Over Insured</a>
												</li>
												<li>
													<a class="indicator" name="Population 65 and Over Uninsured" href="#">Population 65 and Over Uninsured</a>
												</li>
												<li>
													<a class="indicator" name="Percent 65 and Over Insured" href="#">Percent 65 and Over Insured</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Housing &amp; Community Development">
									<a>Housing &amp; Community Development</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Housing &amp; Community Development Employment">
											<a>Housing &amp; Community Development Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Housing &amp; Community Development" href="#">Housing &amp; Community Development</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Housing &amp; Community Development Expenditures">
											<a>Housing &amp; Community Development Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Housing &amp; Community Development" href="#">Total Housing &amp; Community Development</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Housing Units">
											<a>Housing Units</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Population" href="#">Population</a>
												</li>
												<li>
													<a class="indicator" name="Number of Housing Units" href="#">Number of Housing Units</a>
												</li>
												<li>
													<a class="indicator" name="Average Household Size" href="#">Average Household Size</a>
												</li>
												<li>
													<a class="indicator" name="Occupied Housing Units" href="#">Occupied Housing Units</a>
												</li>
												<li>
													<a class="indicator" name="Owner-Occupied Housing Units" href="#">Owner-Occupied Housing Units</a>
												</li>
												<li>
													<a class="indicator" name="Percent of Owner-Occupied Housing Units" href="#">Percent of Owner-Occupied Housing Units</a>
												</li>
												<li>
													<a class="indicator" name="Renter-Occupied Housing Units" href="#">Renter-Occupied Housing Units</a>
												</li>
												<li>
													<a class="indicator" name="Percent of Renter-Occupied Housing Units" href="#">Percent of Renter-Occupied Housing Units</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" title="Justice & Public Safety">
									<a>Justice &amp; Public Safety</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Justice & Public Safety Employment">
											<a>Justice &amp; Public Safety Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Justice & Public Safety" href="#">Total Justice &amp; Public Safety</a>
												</li>
												<li>
													<a class="indicator" name="Correction" href="#">Correction</a>
												</li>
												<li>
													<a class="indicator" name="Judicial &amp; Legal Services" href="#">Judicial &amp; Legal Services</a>
												</li>
												<li>
													<a class="indicator" name="Police Protection" href="#">Police Protection</a>
												</li>
												<li>
													<a class="indicator" name="Fire Protection" href="#">Fire Protection</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Justice & Public Safety Expenditures">
											<a>Justice &amp; Public Safety Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Justice & Public Safety" href="#">Total Justice &amp; Public Safety</a>
												</li>
												<li>
													<a class="indicator" name="Correction" href="#">Correction</a>
												</li>
												<li>
													<a class="indicator" name="Judicial &amp; Legal Services" href="#">Judicial &amp; Legal Services</a>
												</li>
												<li>
													<a class="indicator" name="Police Protection" href="#">Police Protection</a>
												</li>
												<li>
													<a class="indicator" name="Fire Protection" href="#">Fire Protection</a>
												</li>
												<li>
													<a class="indicator" name="Protective Inspection" href="#">Protective Inspection</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Jails - Supervised Population">
											<a>Jails - Supervised Population</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total Jail Population" href="#">Total Jail Population</a>
												</li>
												<li>
													<a class="indicator" name="Jail Capacity" href="#">Jail Capacity</a>
												</li>
												<li>
													<a class="indicator" name="Confined Persons" href="#">Confined Persons</a>
												</li>
												<li>
													<a class="indicator" name="Nonconfined Persons" href="#">Nonconfined Persons</a>
												</li>
												<li>
													<a class="indicator" name="Non US Citizens" href="#">Non US Citizens</a>
												</li>
												<li>
													<a class="indicator" name="Weekenders" href="#">Weekenders</a>
												</li>
												<li>
													<a class="indicator" name="Average Daily Population" href="#">Average Daily Population</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Jails - Supervised Population by Agency">
											<a>Jails - Supervised Population by Agency</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total Jail Population" href="#">Total Jail Population</a>
												</li>
												<li>
													<a class="indicator" name="Jail Capacity" href="#">Jail Capacity</a>
												</li>
												<li>
													<a class="indicator" name="Held for US Marshals Service" href="#">Held for US Marshals Service</a>
												</li>
												<li>
													<a class="indicator" name="Held for Federal Bureau of Prisons" href="#">Held for Federal Bureau of Prisons</a>
												</li>
												<li>
													<a class="indicator" name="Held for Immigration &amp; Customs" href="#">Held for Immigration &amp; Customs</a>
												</li>
												<li>
													<a class="indicator" name="Held for Bureau of Indian Affairs" href="#">Held for Bureau of Indian Affairs</a>
												</li>
												<li>
													<a class="indicator" name="Held for Other Federal Authorities" href="#">Held for Other Federal Authorities</a>
												</li>
												<li>
													<a class="indicator" name="Held for Own State" href="#">Held for Own State</a>
												</li>
												<li>
													<a class="indicator" name="Held for Other State" href="#">Held for Other State</a>
												</li>
												<li>
													<a class="indicator" name="Held for Local Jurisdiction in State" href="#">Held for Local Jurisdiction in State</a>
												</li>
												<li>
													<a class="indicator" name="Held for Local Jurisdiction outside the State" href="#">Held for Local Jurisdiction outside the State</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Jails - Inmate Demographics">
											<a>Jails - Inmate Demographics</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total Jail Population" href="#">Total Jail Population</a>
												</li>
												<li>
													<a class="indicator" name="Adult Males" href="#">Adult Males</a>
												</li>
												<li>
													<a class="indicator" name="Adult Females" href="#">Adult Females</a>
												</li>
												<li>
													<a class="indicator" name="Total Juveniles" href="#">Total Juveniles</a>
												</li>
												<li>
													<a class="indicator" name="Total Convicted" href="#">Total Convicted</a>
												</li>
												<li>
													<a class="indicator" name="Total Unconvicted" href="#">Total Unconvicted</a>
												</li>
												<li>
													<a class="indicator" name="White" href="#">White</a>
												</li>
												<li>
													<a class="indicator" name="Black or African American" href="#">Black or African American</a>
												</li>
												<li>
													<a class="indicator" name="Hispanic or Latino" href="#">Hispanic or Latino</a>
												</li>
												<li>
													<a class="indicator" name="Asian" href="#">Asian</a>
												</li>
												<li>
													<a class="indicator" name="American Indian or Alaskan Native" href="#">American Indian or Alaskan Native</a>
												</li>
												<li>
													<a class="indicator" name="Native Hawaiian or Other Pacific Islander" href="#">Native Hawaiian or Other Pacific Islander</a>
												</li>
												<li>
													<a class="indicator" name="Two or More Races" href="#">Two or More Races</a>
												</li>
												<li>
													<a class="indicator" name="Other Inmate Races" href="#">Other Inmate Races</a>
												</li>
												<li>
													<a class="indicator" name="Race Not Known" href="#">Race Not Known</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Jails - Community Supervision">
											<a>Jails - Community Supervision</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total Jail Population" href="#">Total Jail Population</a>
												</li>
												<li>
													<a class="indicator" name="Jail Capacity" href="#">Jail Capacity</a>
												</li>
												<li>
													<a class="indicator" name="Confined Persons" href="#">Confined Persons</a>
												</li>
												<li>
													<a class="indicator" name="Nonconfined Persons" href="#">Nonconfined Persons</a>
												</li>
												<li>
													<a class="indicator" name="Electronic Monitoring Program" href="#">Electronic Monitoring Program</a>
												</li>
												<li>
													<a class="indicator" name="Home Detention" href="#">Home Detention</a>
												</li>
												<li>
													<a class="indicator" name="Community Service" href="#">Community Service</a>
												</li>
												<li>
													<a class="indicator" name="Day Reporting" href="#">Day Reporting</a>
												</li>
												<li>
													<a class="indicator" name="Other Pretrial Supervision" href="#">Other Pretrial Supervision</a>
												</li>
												<li>
													<a class="indicator" name="Other Alternative Work Programs" href="#">Other Alternative Work Programs</a>
												</li>
												<li>
													<a class="indicator" name="Alcohol/Drug Treatment Programs" href="#">Alcohol/Drug Treatment Programs</a>
												</li>
												<li>
													<a class="indicator" name="Other Nonconfined Programs" href="#">Other Nonconfined Programs</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Public Safety Structure">
											<a>Public Safety Structure</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Elected Sheriff" href="#">Elected Sheriff</a>
												</li>
												<li>
													<a class="indicator" name="County Funded Sheriff Department" href="#">County Funded Sheriff Department</a>
												</li>
												<li>
													<a class="indicator" name="County Operated Sheriff Department" href="#">County Operated Sheriff Department</a>
												</li>
												<li>
													<a class="indicator" name="Elected Police Chief" href="#">Elected Police Chief</a>
												</li>
												<li>
													<a class="indicator" name="County Funded Police Department" href="#">County Funded Police Department</a>
												</li>
												<li>
													<a class="indicator" name="County Operated Police Department" href="#">County Operated Police Department</a>
												</li>
												<li>
													<a class="indicator" name="County Funded Jails" href="#">County Funded Jails</a>
												</li>
												<li>
													<a class="indicator" name="County Operated Jails" href="#">County Operated Jails</a>
												</li>
												<li>
													<a class="indicator" name="County Funded Courts - Salaries" href="#">County Funded Courts - Salaries</a>
												</li>
												<li>
													<a class="indicator" name="County Funded Courts - Buildings/Real Property" href="#">County Funded Courts - Buildings/Real Property</a>
												</li>
												<li>
													<a class="indicator" name="County Funded Courts - General Operating Expenses" href="#">County Funded Courts - General Operating Expenses</a>
												</li>
												<li>
													<a class="indicator" name="County Operated Courts" href="#">County Operated Courts</a>
												</li>
												<li>
													<a class="indicator" name="Elected Judges" href="#">Elected Judges</a>
												</li>
												<li>
													<a class="indicator" name="Elected Clerks of Court" href="#">Elected Clerks of Court</a>
												</li>
												<li>
													<a class="indicator" name="Elected District Attorney" href="#">Elected District Attorney</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Public Amenities">
									<a>Public Amenities</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Public Amenity Employment">
											<a>Public Amenity Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Public Amenity" href="#">Total Public Amenity</a>
												</li>
												<li>
													<a class="indicator" name="Libraries" href="#">Libraries</a>
												</li>
												<li>
													<a class="indicator" name="Natural Resources" href="#">Natural Resources</a>
												</li>
												<li>
													<a class="indicator" name="Parks &amp; Recreation" href="#">Parks &amp; Recreation</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Public Amenity Expenditures">
											<a>Public Amenity Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Public Amenity" href="#">Total Public Amenity</a>
												</li>
												<li>
													<a class="indicator" name="Libraries" href="#">Libraries</a>
												</li>
												<li>
													<a class="indicator" name="Natural Resources" href="#">Natural Resources</a>
												</li>
												<li>
													<a class="indicator" name="Parks &amp; Recreation" href="#">Parks &amp; Recreation</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Libraries">
											<a>Libraries</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Number of Central Service Outlets" href="#">Number of Central Service Outlets</a>
												</li>
												<li>
													<a class="indicator" name="Number of Branches" href="#">Number of Branches</a>
												</li>
												<li>
													<a class="indicator" name="Number of Bookmobiles" href="#">Number of Bookmobiles</a>
												</li>
												<li>
													<a class="indicator" name="Population of Local Service Area" href="#">Population of Local Service Area</a>
												</li>
												<li>
													<a class="indicator" name="Full Time Librarians" href="#">Full Time Librarians</a>
												</li>
												<li>
													<a class="indicator" name="Total FTE Staff" href="#">Total FTE Staff</a>
												</li>
												<li>
													<a class="indicator" name="Annual Hours - All Outlets" href="#">Annual Hours - All Outlets</a>
												</li>
												<li>
													<a class="indicator" name="Total Operating Revenue" href="#">Total Operating Revenue</a>
												</li>
												<li>
													<a class="indicator" name="Operating Revenue from Local Government" href="#">Operating Revenue from Local Government</a>
												</li>
												<li>
													<a class="indicator" name="Operating Revenue from State Government" href="#">Operating Revenue from State Government</a>
												</li>
												<li>
													<a class="indicator" name="Operating Revenue from Federal Government" href="#">Operating Revenue from Federal Government</a>
												</li>
												<li>
													<a class="indicator" name="Other Operating Revenue" href="#">Other Operating Revenue</a>
												</li>
												<li>
													<a class="indicator" name="Operating Expenditures Salaries and Benefits" href="#">Operating Expenditures Salaries and Benefits</a>
												</li>
												<li>
													<a class="indicator" name="Operating Expenditures Library Collections" href="#">Operating Expenditures Library Collections</a>
												</li>
												<li>
													<a class="indicator" name="Other Operating Expenditures" href="#">Other Operating Expenditures</a>
												</li>
												<li>
													<a class="indicator" name="Total Operating Expenditures" href="#">Total Operating Expenditures</a>
												</li>
												<li>
													<a class="indicator" name="Total Capital Revenue" href="#">Total Capital Revenue</a>
												</li>
												<li>
													<a class="indicator" name="Total Capital Expenditures" href="#">Total Capital Expenditures</a>
												</li>
												<li>
													<a class="indicator" name="Library Collections - Number of Print Materials" href="#">Library Collections - Number of Print Materials</a>
												</li>
												<li>
													<a class="indicator" name="Library Collections - Number of Electronic Books" href="#">Library Collections - Number of Electronic Books</a>
												</li>
												<li>
													<a class="indicator" name="Library Collections - Number of Audio Materials" href="#">Library Collections - Number of Audio Materials</a>
												</li>
												<li>
													<a class="indicator" name="Library Collections - Number of Video Materials" href="#">Library Collections - Number of Video Materials</a>
												</li>
												<li>
													<a class="indicator" name="Total Annual Visits" href="#">Total Annual Visits</a>
												</li>
												<li>
													<a class="indicator" name="Total Annual Circulation" href="#">Total Annual Circulation</a>
												</li>
												<li>
													<a class="indicator" name="Number of Computers Available" href="#">Number of Computers Available</a>
												</li>
												<li>
													<a class="indicator" name="Number of Computer Users" href="#">Number of Computer Users</a>
												</li>
												<li>
													<a class="indicator" name="Number of Licensed Databases" href="#">Number of Licensed Databases</a>
												</li>
												<li>
													<a class="indicator" name="Registered Borrowers" href="#">Registered Borrowers</a>
												</li>
												<li>
													<a class="indicator" name="Total Programs" href="#">Total Programs</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Public Welfare">
									<a>Public Welfare</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Public Welfare Employment">
											<a>Public Welfare Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Public Welfare" href="#">Public Welfare</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Public Welfare Expenditures">
											<a>Public Welfare Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Public Welfare" href="#">Total Public Welfare</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Cash Assistance" href="#">Cash Assistance</a>
												</li>
												<li>
													<a class="indicator" name="Vendor Payments" href="#">Vendor Payments</a>
												</li> -->
												<li>
													<a class="indicator" name="Other Public Welfare" href="#">Other Public Welfare</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Assistance &amp; Subsidies" href="#">Assistance &amp; Subsidies</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Transportation">
									<a>Transportation</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Transportation Employment">
											<a>Transportation Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Transportation" href="#">Total Transportation</a>
												</li>
												<li>
													<a class="indicator" name="Air Transportation" href="#">Air Transportation</a>
												</li>
												<li>
													<a class="indicator" name="Highways" href="#">Highways</a>
												</li>
												<li>
													<a class="indicator" name="Water Transport &amp; Terminals" href="#">Water Transport &amp; Terminals</a>
												</li>
												<li>
													<a class="indicator" name="Transit" href="#">Transit</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Transportation Expenditures">
											<a>Transportation Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Transportation" href="#">Total Transportation</a>
												</li>
												<li>
													<a class="indicator" name="Air Transportation" href="#">Air Transportation</a>
												</li>
												<li>
													<a class="indicator" name="Highways" href="#">Highways</a>
												</li>
												<li>
													<a class="indicator" name="Parking Facilities" href="#">Parking Facilities</a>
												</li>
												<li>
													<a class="indicator" name="Sea &amp; Inland Port" href="#">Sea &amp; Inland Port</a>
												</li>
												<li>
													<a class="indicator" name="Transit Utilities" href="#">Transit Utilities</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Interest on Debt" href="#">Interest on Debt</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Airports">
											<a>Airports</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Number of Airports" href="#">Number of Airports</a>
												</li>
												<li>
													<a class="indicator" name="Number of Publicly Owned Airports" href="#">Number of Publicly Owned Airports</a>
												</li>
												<li>
													<a class="indicator" name="Number of Privately Owned Airports" href="#">Number of Privately Owned Airports</a>
												</li>
												<li>
													<a class="indicator" name="Number of Military Owned Airports" href="#">Number of Military Owned Airports</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Bridges">
											<a>Bridges</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="All Bridges - Total Bridges" href="#">All Bridges - Total Bridges</a>
												</li>
												<li>
													<a class="indicator" name="All Bridges - City/Town Owned" href="#">All Bridges - City/Town Owned</a>
												</li>
												<li>
													<a class="indicator" name="All Bridges - County Owned" href="#">All Bridges - County Owned</a>
												</li>
												<li>
													<a class="indicator" name="All Bridges - Federal Owned" href="#">All Bridges - Federal Owned</a>
												</li>
												<li>
													<a class="indicator" name="All Bridges - Privately Owned" href="#">All Bridges - Privately Owned</a>
												</li>
												<li>
													<a class="indicator" name="All Bridges - State Owned" href="#">All Bridges - State Owned</a>
												</li>
												<!-- <li>
													<a class="indicator" name="All Bridges - Local Owned" href="#">All Bridges - Local Owned</a>
												</li> -->
												<li>
													<a class="indicator" name="Structurally Deficient Bridges - Total Bridges" href="#">Structurally Deficient Bridges - Total Bridges</a>
												</li>
												<li>
													<a class="indicator" name="Structurally Deficient Bridges - City/Town Owned" href="#">Structurally Deficient Bridges - City/Town Owned</a>
												</li>
												<li>
													<a class="indicator" name="Structurally Deficient Bridges - County Owned" href="#">Structurally Deficient Bridges - County Owned</a>
												</li>
												<li>
													<a class="indicator" name="Structurally Deficient Bridges - Federal Owned" href="#">Structurally Deficient Bridges - Federal Owned</a>
												</li>
												<li>
													<a class="indicator" name="Structurally Deficient Bridges - Privately Owned" href="#">Structurally Deficient Bridges - Privately Owned</a>
												</li>
												<li>
													<a class="indicator" name="Structurally Deficient Bridges - State Owned" href="#">Structurally Deficient Bridges - State Owned</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Structurally Deficient Bridges - Local Owned" href="#">Structurally Deficient Bridges - Local Owned</a>
												</li> -->
												<li>
													<a class="indicator" name="Functionally Obsolete Bridges - Total Bridges" href="#">Functionally Obsolete Bridges - Total Bridges</a>
												</li>
												<li>
													<a class="indicator" name="Functionally Obsolete Bridges - City/Town Owned" href="#">Functionally Obsolete Bridges - City/Town Owned</a>
												</li>
												<li>
													<a class="indicator" name="Functionally Obsolete Bridges - County Owned" href="#">Functionally Obsolete Bridges - County Owned</a>
												</li>
												<li>
													<a class="indicator" name="Functionally Obsolete Bridges - Federal Owned" href="#">Functionally Obsolete Bridges - Federal Owned</a>
												</li>
												<li>
													<a class="indicator" name="Functionally Obsolete Bridges - Privately Owned" href="#">Functionally Obsolete Bridges - Privately Owned</a>
												</li>
												<li>
													<a class="indicator" name="Functionally Obsolete Bridges - State Owned" href="#">Functionally Obsolete Bridges - State Owned</a>
												</li>
												<!-- <li>
													<a class="indicator" name="Functionally Obsolete Bridges - Local Owned" href="#">Functionally Obsolete Bridges - Local Owned</a>
												</li> -->
											</ul>
										</li>
										<li class="dataset" name="Road Classification">
											<a>Road Classification</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total Public Road Miles" href="#">Total Public Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Interstate Road Miles" href="#">Interstate Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Other Freeway/Expressway Road Miles" href="#">Other Freeway/Expressway Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Other Principle Arterial Road Miles" href="#">Other Principle Arterial Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Minor Arterial Road Miles" href="#">Minor Arterial Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Major Collector Road Miles" href="#">Major Collector Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Urban Minor Collector Road Miles" href="#">Urban Minor Collector Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Local Road Miles" href="#">Local Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Share Interstate" href="#">Share Interstate</a>
												</li>
												<li>
													<a class="indicator" name="Share Other Freeway/Expressway" href="#">Share Other Freeway/Expressway</a>
												</li>
												<li>
													<a class="indicator" name="Share Other Principle Arterial" href="#">Share Other Principle Arterial</a>
												</li>
												<li>
													<a class="indicator" name="Share Minor Arterial" href="#">Share Minor Arterial</a>
												</li>
												<li>
													<a class="indicator" name="Share Major Collector" href="#">Share Major Collector</a>
												</li>
												<li>
													<a class="indicator" name="Share Urban Minor Collector" href="#">Share Urban Minor Collector</a>
												</li>
												<li>
													<a class="indicator" name="Share Local" href="#">Share Local</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Road Ownership">
											<a>Road Ownership</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total Public Road Miles" href="#">Total Public Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="State Highway Agency Road Miles" href="#">State Highway Agency Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="County Highway Agency Road Miles" href="#">County Highway Agency Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Other State Agency Road Miles" href="#">Other State Agency Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Other Local Agency Road Miles" href="#">Other Local Agency Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Privately Owned Road Miles" href="#">Privately Owned Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Town or Township Highway Agency Road Miles" href="#">Town or Township Highway Agency Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="City or Municipal Highway Agency Road Miles" href="#">City or Municipal Highway Agency Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Other Public Instrumentality Road Miles" href="#">Other Public Instrumentality Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Indian Tribe/Nation Road Miles" href="#">Indian Tribe/Nation Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Federal Agency Road Miles" href="#">Federal Agency Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="County Land Square Miles" href="#">County Land Square Miles</a>
												</li>
												<li>
													<a class="indicator" name="Total Road Miles per Square Mile" href="#">Total Road Miles per Square Mile</a>
												</li>
												<li>
													<a class="indicator" name="Total County Road Miles per Square Mile" href="#">Total County Road Miles per Square Mile</a>
												</li>
												<li>
													<a class="indicator" name="Unknown Road Miles" href="#">Unknown Road Miles</a>
												</li>
												<li>
													<a class="indicator" name="Share State Highway Agency" href="#">Share State Highway Agency</a>
												</li>
												<li>
													<a class="indicator" name="Share County Highway Agency" href="#">Share County Highway Agency</a>
												</li>
												<li>
													<a class="indicator" name="Share Other State Agencies" href="#">Share Other State Agencies</a>
												</li>
												<li>
													<a class="indicator" name="Share Other Local Agencies" href="#">Share Other Local Agencies</a>
												</li>
												<li>
													<a class="indicator" name="Share Private" href="#">Share Private</a>
												</li>
												<li>
													<a class="indicator" name="Share Town or Township Highway Agency" href="#">Share Town or Township Highway Agency</a>
												</li>
												<li>
													<a class="indicator" name="Share City or Municipal Highway Agency" href="#">Share City or Municipal Highway Agency</a>
												</li>
												<li>
													<a class="indicator" name="Share Other Public Instrumentality" href="#">Share Other Public Instrumentality</a>
												</li>
												<li>
													<a class="indicator" name="Share Indian Tribe/Nation" href="#">Share Indian Tribe/Nation</a>
												</li>
												<li>
													<a class="indicator" name="Share Federal Agency" href="#">Share Federal Agency</a>
												</li>
												<li>
													<a class="indicator" name="Share Unknown" href="#">Share Unknown</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Utility">
									<a>Utility</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Utility Employment">
											<a>Utility Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Utility" href="#">Total Utility</a>
												</li>
												<li>
													<a class="indicator" name="Electric Utilities" href="#">Electric Utilities</a>
												</li>
												<li>
													<a class="indicator" name="Gas Utilities" href="#">Gas Utilities</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Utility Revenue">
											<a>Utility Revenue</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Utility" href="#">Total Utility</a>
												</li>
												<li>
													<a class="indicator" name="Electric Power Systems" href="#">Electric Power Systems</a>
												</li>
												<li>
													<a class="indicator" name="Gas Supply Systems" href="#">Gas Supply Systems</a>
												</li>
												<li>
													<a class="indicator" name="Public Mass Transit Systems" href="#">Public Mass Transit Systems</a>
												</li>
												<li>
													<a class="indicator" name="Water Supply Systems" href="#">Water Supply Systems</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Utility Expenditures">
											<a>Utility Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Utility" href="#">Total Utility</a>
												</li>
												<li>
													<a class="indicator" name="Electric Utilities" href="#">Electric Utilities</a>
												</li>
												<li>
													<a class="indicator" name="Gas Utilities" href="#">Gas Utilities</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Interest on Debt" href="#">Interest on Debt</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="category" name="Water, Sewerage &amp; Solid Waste Management">
									<a>Water, Sewerage &amp; Solid Waste Management</a>
									<ul class="dropdown-menu">
										<li class="dataset" name="Water, Sewerage &amp; Solid Waste Employment">
											<a>Water, Sewerage &amp; Solid Waste Employment</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Water, Sewerage &amp; Solid Waste" href="#">Total Water, Sewerage &amp; Solid Waste</a>
												</li>
												<li>
													<a class="indicator" name="Sewerage" href="#">Sewerage</a>
												</li>
												<li>
													<a class="indicator" name="Solid Waste" href="#">Solid Waste</a>
												</li>
												<li>
													<a class="indicator" name="Water Utilities" href="#">Water Utilities</a>
												</li>
											</ul>
										</li>
										<li class="dataset" name="Water, Sewerage &amp; Solid Waste Expenditures">
											<a>Water, Sewerage &amp; Solid Waste Expenditures</a>
											<ul class="dropdown-menu">
												<li>
													<a class="indicator" name="Total County" href="#">Total County</a>
												</li>
												<li>
													<a class="indicator" name="Total Water, Sewerage &amp; Solid Waste Management" href="#">Total Water, Sewerage &amp; Solid Waste Management</a>
												</li>
												<li>
													<a class="indicator" name="Sewerage" href="#">Sewerage</a>
												</li>
												<li>
													<a class="indicator" name="Solid Waste" href="#">Solid Waste</a>
												</li>
												<li>
													<a class="indicator" name="Water Utilities" href="#">Water Utilities</a>
												</li>
												<li>
													<a class="indicator" name="Current Operations" href="#">Current Operations</a>
												</li>
												<li>
													<a class="indicator" name="Construction" href="#">Construction</a>
												</li>
												<li>
													<a class="indicator" name="Other Capital Outlay" href="#">Other Capital Outlay</a>
												</li>
												<li>
													<a class="indicator" name="Interest on Debt" href="#">Interest on Debt</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to State" href="#">Intergovernmental to State</a>
												</li>
												<li>
													<a class="indicator" name="Intergovernmental to Local" href="#">Intergovernmental to Local</a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
								<li class="divider"></li>
								<li>
									<a id="resetSecondInd" title="Reset" href="#">Primary Indicator Only</a>
								</li>
							</ul>
						</li>

				    </ul>
				    <!--right nav-->
					<ul class="nav navbar-nav navbar-right" id="searchContainer">
						<li id="searchTypeLi">
							<div class="btn-group" id="searchTypes">
								<button type="button" class="btn btn-default" name="city name" id="citySearch">City Search</button>
								<button type="button" class="btn btn-default active" name="county name" id="countySearch">County Search</button>
								<button type="button" class="btn btn-default" id="stateSearch">State Search</button>
							</div>
						</li>
						<li id="stateDropLi" class="hidden">
							<a id="stateDropText">State</a>
							<ul id="stateDrop" class="dropdown-menu">
								<li><a name="State">All States</a></li>
								<li><a name="AK">AK</a></li>							
								<li><a name="AL">AL</a></li>
								<li><a name="AR">AR</a></li>
								<li><a name="AZ">AZ</a></li>
								<li><a name="CA">CA</a></li>							
								<li><a name="CO">CO</a></li>
								<li><a name="CT">CT</a></li>
								<li><a name="DC">DC</a></li>
								<li><a name="DE">DE</a></li>							
								<li><a name="FL">FL</a></li>
								<li><a name="GA">GA</a></li>
								<li><a name="HI">HI</a></li>
								<li><a name="IA">IA</a></li>							
								<li><a name="ID">ID</a></li>
								<li><a name="IL">IL</a></li>
								<li><a name="IN">IN</a></li>
								<li><a name="KS">KS</a></li>							
								<li><a name="KY">KY</a></li>
								<li><a name="LA">LA</a></li>
								<li><a name="MA">MA</a></li>
								<li><a name="MD">MD</a></li>							
								<li><a name="ME">ME</a></li>
								<li><a name="MI">MI</a></li>
								<li><a name="MN">MN</a></li>
								<li><a name="MO">MO</a></li>							
								<li><a name="MS">MS</a></li>
								<li><a name="MT">MT</a></li>
								<li><a name="NC">NC</a></li>
								<li><a name="ND">ND</a></li>							
								<li><a name="NE">NE</a></li>
								<li><a name="NH">NH</a></li>
								<li><a name="NJ">NJ</a></li>
								<li><a name="NM">NM</a></li>							
								<li><a name="NV">NV</a></li>
								<li><a name="NY">NY</a></li>
								<li><a name="OH">OH</a></li>
								<li><a name="OK">OK</a></li>							
								<li><a name="OR">OR</a></li>
								<li><a name="PA">PA</a></li>
								<li><a name="RI">RI</a></li>
								<li><a name="SC">SC</a></li>							
								<li><a name="SD">SD</a></li>
								<li><a name="TN">TN</a></li>
								<li><a name="TX">TX</a></li>
								<li><a name="UT">UT</a></li>							
								<li><a name="VA">VA</a></li>
								<li><a name="VT">VT</a></li>
								<li><a name="WA">WA</a></li>
								<li><a name="WI">WI</a></li>							
								<li><a name="WV">WV</a></li>
								<li><a name="WY">WY</a></li>
							</ul>
						</li>
						<li id="searchBox"><a>
							<form id="search_form">
								<input type="search" id="search_field" placeholder="county name">
								<input type="image" src="../img/active-search.svg" width="18px" height="18px" id="search_submit" value="Search">
							</form>
						</a></li>
						<li id="moreData">
							<a id="moreDataButton" onclick="moreDataShow();" href="#"><span id="moreDataText">ACCESS MORE DATA</span><img id="moreDataImg" src="../img/more_data.svg"/></a>
						</li>
					</ul>
				  </div><!--/.nav-collapse -->
				</div>
			</div>
    	<div id="cc">	
    		<div class="container" id="container">
	        
	        <div id="instructions">
	        	<div id="showOnMap"><img class="svgCircle" src="../img/showOnMap.svg"/>show on map</div>
	        	<div id="print"><img class="svgCircle" src="../img/print.svg"/>print</div>
	        	<div id="close">close<img class="svgCircle" src="../img/Close.svg"/></div>
	        	<div id="instructionText">
	        		<div class="iText" id="mdText">
						<div id="moreDataContent">
							<!--<div class="row">
								<div class="col-md-5">
									<h3><a href="http://www.countyinnovation.us/t/cic">Full Interactive Map</a></h3>
									<a href="http://www.countyinnovation.us/t/cic"><img src="../img/CICFullThumb.png"/></a>
								</div>
								<div class="col-md-7">
									<p>Access all 18 categories, 66 datasets, and over 500 indicators for display on the interactive map.<br/><br/>Login free to COIN <a href="http://www.countyinnovation.us/t/cic">here</a> to access</p>
								</div>
							</div>-->
							<div class="row">
								<div class="col-md-5">
									<h3><a href="http://cic.naco.org/cic_extraction/cic_extraction_1.cfm">CIC Extraction Tool</a></h3>
									<a href="http://cic.naco.org/cic_extraction/cic_extraction_1.cfm"><img src="../img/CICExtractionThumb.png"/></a>
								</div>
								<div class="col-md-7">
									<p>Full access to all the most recent data and additional historical data for all 18 categories, 66 datasets, and over 500 indicators.<br/><br/>Customizable data downloads available <a href="http://cic.naco.org/cic_extraction/cic_extraction_1.cfm">here</a></p>
								</div>
							</div>
						</div>	        			
	        		</div>
	        		<div class="iText" id="mailingText" style="text-align:center;">
        				<p style="font-size:1.5em;">Keep Me Updated!</p>
        				<p>Submit your email to the mailing list and receive updates when new features have been added.</p><br><br>
        				<script type="text/javascript">var submitted=false;</script>
        				<iframe name="hidden_iframe" id="hidden_iframe" style="display:none;" onload="if(submitted){thankYou();}"></iframe>
        				<form action="https://docs.google.com/forms/d/1m3fF7twvVyIj42GuDNqtTKnfZwXrtOZ1p1Z7jQoJa70/formResponse" method="POST" id="ss-form" target="hidden_iframe" onsubmit="submitted=true;">
        					<ol role="list" class="ss-question-list" style="padding-left: 0">
							<div class="ss-form-question errorbox-good" role="listitem">
							<div dir="ltr" class="ss-item ss-item-required ss-text"><div class="ss-form-entry">
							<label class="ss-q-item-label" for="entry_1891399482"><div class="ss-q-title">Email
							<label for="itemView.getDomIdToLabel()" aria-label="(Required field)"></label>
							<span class="ss-required-asterisk">*</span></div>
							<div class="ss-q-help ss-secondary-text" dir="ltr"></div></label>
							<input type="email" name="entry.1891399482" value="" class="ss-q-short" id="entry_1891399482" dir="auto" aria-label="Email  Must be a valid email address" aria-required="true" required="" title="Must be a valid email address">
							<button class="btn btn-default" type="submit" name="submit" value="Submit" id="ss-submit">Submit</button>
							</div></div></div>
							<input type="hidden" name="draftResponse" value="[,,&quot;8946414525009973512&quot;]
							">
							<input type="hidden" name="pageHistory" value="0">
							
							
							<input type="hidden" name="fbzx" value="8946414525009973512">
							
							</ol>
						</form>
	        		</div>
	        		<div class="iText" id="thankYouText" style="text-align:center;">
	        			<p style="font-size:1.5em;">Thank you!  Now you will be the first to know about the latest county data.</p>
	        			<p>Don't forget to <a href="#" id="showHideRrssbLink">share the CIC</a> with others!</p>
	        		</div>
	        		<div class="iText helpText" id="helpText1">
						<div class="helpTitle"><h3>Help</h3></div>
						<div class="helpContainer">
							<p>
								<div class="helpLinkContainer">&bull; <span class="helpLink" onclick="goToPage(2);">View a new indicator on the map</span></div>
								<div class="helpLinkContainer">&bull; <span class="helpLink" onclick="goToPage(2);">See detailed information on an indicator</span></div>
								<div class="helpLinkContainer">&bull; <span class="helpLink" onclick="goToPage(4);">Find a county</span></div>
								<div class="helpLinkContainer">&bull; <span class="helpLink" onclick="goToPage(4);">Find a county by a city name</span></div>
								<div class="helpLinkContainer">&bull; <span class="helpLink" onclick="goToPage(4);">Find a county by a state name</span></div>
								<div class="helpLinkContainer">&bull; <span class="helpLink" onclick="goToPage(6);">Find a county seat or an elected official</span></div>
								<div class="helpLinkContainer">&bull; <span class="helpLink" onclick="goToPage(3);">Compare two indicators</span></div>
							</p>
						</div>
	        		</div>
					<div class="iText helpText" id="helpText2">
						<div class="helpTitle"><h3>Getting Started</h3></div>
						<div class="helpContainer">
							<p>
								<div class="helpList">&bull; The map always displays the latest year of data in the CIC database for the &quot;Primary Indicator&quot;.</div>
								<br/>
								<div class="helpList">&bull; Pick a statistic by clicking on &quot;Primary Indicator&quot; on the top left of the screen and choosing an indicator.</div>
								<div class="helpList">&bull; Click on a county on the map to show detailed statistics for that county.</div>
								<div class="helpList">&bull; Or search for a county with the search bar on the top right of the screen.</div>
							</p>
							<br/>
							<div>Click on <div id="moreDataButton2" onclick="moreDataShow();" style="width:190px;"><span id="moreDataText">ACCESS MORE DATA</span><img id="moreDataImg2" src="../img/more_data.svg"/></div> to access more data or to sign up to download data through the CIC extraction tool (Coming September, 2014)</div>
							<br/>
							<div><img src="../img/Mail.svg"> - Sign up for CIC DATA UPDATES to be the first to know the latest information about counties</div>
							<br/>
							<div><img src="../img/Share.svg"> - Share the CIC on social media</div>
							<br/><br/><br/>
						</div>
	        		</div>
	        		<div class="iText helpText" id="helpText3">
	        			<div class="helpTitle"><h3>Comparing Two Indicators</h3></div>
	        			<div class="helpContainer">
	        				<p>To show additional statistics, click on &quot;Secondary Indicator&quot; on the top left of the screen and choose another indicator.</p>
	        				<br>
	        				<p>Clicking on a county will now compare statistics for both selected indicators</p>
	        				<br/>
	        				<p><img src="../img/Reset_indicators.svg"> - Click this to no longer see the secondary indicator</p>
	        			</div>
	        		</div>
					<div class="iText helpText" id="helpText4">
						<div class="helpTitle"><h3>Finding A County</h3></div>
						<div class="helpContainer">
							<p>There are multiple ways to find a county.</p>
							<p>
								<div class="helpList">&bull; Click on "County Search" and search for any county.</div>
								<div class="helpList">&bull; Click on "City Search", type in the name of a city, and all counties located within that city will appear in the search results.</div>
								<div class="helpList">&bull; Click on "State Search", pick a state from the dropdown, and all counties located in the state will appear in the search results.</div>
								<div class="helpList">&bull; Double-click on any county to view basic information about it, including its county seat.</div>
							</p>
						</div>
	        		</div>
					<div class="iText helpText" id="helpText5">
						<div class="helpTitle"><h3>Using the Map</h3></div>
						<div class="helpContainer">
							<p>
								<div class="helpList">&bull; Pick a new statistic by clicking on &quot;Primary Indicator&quot; on the top left of the screen and choosing an indicator.</div>
								<div class="helpList">&bull; Click on a county on the map to show statistics.</div>
								<br/>
								<div class="helpList">&bull; Scroll up when hovering over the map to ZOOM IN.</div>
								<div class="helpList">&bull; Scroll down when hovering over the map to ZOOM OUT.</div>
								<p>&bull; Click <img src="../img/Back_to_US.svg"> to fully zoom out and see the entire map</p>
							</p>
						</div>
	        		</div>
	        		<div class="iText helpText" id="helpText6">
						<div class="helpTitle"><h3>County Seats and Elected Executives</h3></div>
						<div class="helpContainer">
							<p>Coming Soon!  We are in the process of collecting and cleaning this data for your use.</p>
							<!--<p class="helpList">Double-click on any county to view basic information about it, including its county seat and a list of elected officials.</p>
							<p class="helpList">You can also find out whether a county has an Elected Executive or County Administrator by selecting from the "Primary Indicator"</p>
							<p>
								<div class="helpList">&bull; Hover over the "County Structure" category</div>
								<div class="helpList">&bull; Hover over the "Government Structure" dataset</div>
								<div class="helpList">&bull; Select "Elected Executive" or "County Administrator" to see which counties have that position</div>
							</p>-->
						</div>
	        		</div>
	        	</div>
				<div id="instructionPagination">
					<ul class="pagination">
						<li><a href='#' onclick="incrementPage(-1);">&laquo;</a></li>
						<li class="active" name="1"><a onclick="goToPage(1);">1</a></li>
						<li name="2"><a onclick="goToPage(2);">2</a></li>
						<li name="3"><a onclick="goToPage(3);">3</a></li>
						<li name="4"><a onclick="goToPage(4);">4</a></li>
						<li name="5"><a onclick="goToPage(5);">5</a></li>
						<li name="6"><a onclick="goToPage(6);">6</a></li>
						<li><a href='#' onclick="incrementPage(1);">&raquo;</a></li>
					</ul>
				</div>
	        </div>
			
			<div id="map">
				<table id="iconsGroup"><tbody>
					<tr><td><a id="showHelpIcon" title="Help"><img class="my-icons" alt="Help" src="../img/Help.svg"/></a></td><td id="showHelpIconText" class="extraInstructions">Help</td></tr>
					<tr><td><a id="backToMapIcon" title="Back to US Map"><img class="my-icons" alt="Back to US Map" src="../img/Back_to_US.svg"/></a></td><td id="backToMapIconText" class="extraInstructions">Back to US Map</td></tr>
					<tr><td><a id="resetAllIcon" title="Reset Indicators"><img class="my-icons" alt="Reset Indicators" src="../img/Reset_indicators.svg"/></a></td><td id="resetAllIconText" class="extraInstructions">Remove Second Indicator</td></tr>
					<tr><td><a id="showHideRrssbIcon" title="Share this info"><img class="my-icons" alt="Share this info" src="../img/Share.svg"/></a></td><td id="showHideRrssbIconText" class="extraInstructions">Share this map!</td></tr>
					<tr><td><a id="addToMailingListIcon" title="Add Me To Mailing List"><img class="my-icons" alt="Add Me To Mailing List" src="../img/Mail.svg"/></a></td><td id="addToMailingListIconText" class="extraInstructions">Add to Mailing List</td></tr>
				</tbody></table>
			</div>
			<div id="zoomIcons">
	        	<div id="zoomPlusIcon">+</div>
	        	<div id="zoomMinusIcon">-</div>
	        </div>
	        <div id="tt" class="tooltip hidden">
	        	<div id="tipContainer"></div>
	        	<div class="arrow_box"></div>
	        </div>
			<!--Under map area -->
	        <div id="underMap">
	        	<div class="container-fluid">
		        	<div class="row">
		        		<div class="col-md-6">
							<!-- <div id="perCapitaContainer">
								<button type="button" class="btn btn-default" id="perCapitaButton">View As Per Capita</button>
							</div>
							<div id="measureTypeContainer" class="btn-group">
								<button type="button" class="btn btn-default active" id="quantileButton">Quantile</button>
								<button type="button" class="btn btn-default" id="thresholdButton">Threshold</button>
							</div>
							<div id="thresholdInputContainer">
								<table>
									<tr>
										<td><input class="thresholdInput" id="thresholdInput1" size="10"></td>
										<td><input class="thresholdInput" id="thresholdInput2" size="10"></td>
										<td><input class="thresholdInput" id="thresholdInput3" size="10"></td>
										<td><input class="thresholdInput" id="thresholdInput4" size="10"></td>
									</tr>
									<tr>
										<td align="center"><span>low</span></td>
										<td></td><td></td>
										<td align="center"><span>high</span></td>										
									</tr>
									<tr>
										<td colspan=4 align="center">
											<input type="submit" id="thresholdSubmit">
										</td>
									</tr>
								</table>
							</div> -->
		        		</div>
		        		<div id="legend-container" class="col-sm-12 col-md-6">
		        			<div id="legendTitleContainer">
		        				<div id="legendTitle"></div>
		        				<div id="legendSubtitle"></div>
		        			</div>
		        			<div id="quantileLegend" class="legend"></div>
		        		</div>
			        </div>
			        <div class="row">
			        	<div class="col-md-6 byline">
				        	Brought to you by <a target="_blank" href="http://www.naco.org/research">NACo Research</a>
				        </div>
				        <div class="col-md-6 byline" style="text-align:right;">
				        	*county data is unavailable if the county is colored grey<br>
				        </div>
			        </div>
			        <div id="moreInteractives" class="row">
			        	<div class="col-md-6"><a href="http://www.uscounties.org/countyTracker/index.html"><h3>County Tracker Interactive: <small>County economies through recession and recovery</small></h3></a></div>
			        	<div class="col-md-6"><a href="http://www.uscounties.org/county-transportation-funding/index.html"><h3>Road Ahead Interactive: <small>County transportation funding and financing</small></h3></a></div>
			        </div>
		        </div>
	        	<div id="sourceContainer" class="container-fluid"></div>
	        	<div id="definitionsContainer" class="container-fluid"></div>
	        	<div id="notesContainer" class="container-fluid">
	        		<p><i>Notes:</i><br>New York City is a consolidation of the five boroughs of the city of New York:<br>&nbsp;&bull; Manhattan (New York County)<br>&nbsp;&bull; The Bronx (Bronx County)<br>&nbsp;&bull; Brooklyn (Kings County)<br>&nbsp;&bull; Queens (Queens County)<br>&nbsp;&bull; Staten Island (Richmond County).</p>
	        	</div>
	        </div>
	        <!-- Buttons start here.-->
            <div id="rrssbContainer">
                <ul class="rrssb-buttons clearfix" style="display:none;">
                    <li class="email">

                        <!-- Replace subject with your message using URL Endocding: http://meyerweb.com/eric/tools/dencoder/ -->
                        <a href="mailto:?subject=How%20Much%20Do%20You%20Know%20About%20Your%20County?&amp;body=Explore%20your%20county%20through%20over%20500%20indicators%20and%20nearly%2070%20datasets.%20www.naco.org%2FCIC">
                            <span class="icon">
                                <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" x="0px" y="0px" width="28px" height="28px" viewBox="0 0 28 28" enable-background="new 0 0 28 28" xml:space="preserve"><g><path d="M20.111 26.147c-2.336 1.051-4.361 1.401-7.125 1.401c-6.462 0-12.146-4.633-12.146-12.265 c0-7.94 5.762-14.833 14.561-14.833c6.853 0 11.8 4.7 11.8 11.252c0 5.684-3.194 9.265-7.399 9.3 c-1.829 0-3.153-0.934-3.347-2.997h-0.077c-1.208 1.986-2.96 2.997-5.023 2.997c-2.532 0-4.361-1.868-4.361-5.062 c0-4.749 3.504-9.071 9.111-9.071c1.713 0 3.7 0.4 4.6 0.973l-1.169 7.203c-0.388 2.298-0.116 3.3 1 3.4 c1.673 0 3.773-2.102 3.773-6.58c0-5.061-3.27-8.994-9.303-8.994c-5.957 0-11.175 4.673-11.175 12.1 c0 6.5 4.2 10.2 10 10.201c1.986 0 4.089-0.43 5.646-1.245L20.111 26.147z M16.646 10.1 c-0.311-0.078-0.701-0.155-1.207-0.155c-2.571 0-4.595 2.53-4.595 5.529c0 1.5 0.7 2.4 1.9 2.4 c1.441 0 2.959-1.828 3.311-4.087L16.646 10.068z"/></g></svg>
                            </span>
                            <span class="text">email</span>
                        </a>
                    </li>
                    <li class="facebook">
                        <!-- Replace with your URL. For best results, make sure you page has the proper FB Open Graph tags in header: 
                        https://developers.facebook.com/docs/opengraph/howtos/maximizing-distribution-media-content/ -->
                        <a href="https://www.facebook.com/sharer/sharer.php?u=http://www.naco.org/cic" class="popup">
                            <span class="icon">
                                <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="28px" height="28px" viewBox="0 0 28 28" enable-background="new 0 0 28 28" xml:space="preserve">
                                    <path d="M27.825,4.783c0-2.427-2.182-4.608-4.608-4.608H4.783c-2.422,0-4.608,2.182-4.608,4.608v18.434
                                        c0,2.427,2.181,4.608,4.608,4.608H14V17.379h-3.379v-4.608H14v-1.795c0-3.089,2.335-5.885,5.192-5.885h3.718v4.608h-3.726
                                        c-0.408,0-0.884,0.492-0.884,1.236v1.836h4.609v4.608h-4.609v10.446h4.916c2.422,0,4.608-2.188,4.608-4.608V4.783z"/>
                                </svg>
                            </span>
                            <span class="text">facebook</span>
                        </a>
                    </li>
                    <li class="linkedin">
                        <!-- Replace href with your meta and URL information -->
                        <a href="http://www.linkedin.com/shareArticle?mini=true&amp;url=http://www.naco.org/CIC&amp;title=How%20Well%20Do%20You%20Know%20Your%20County?&amp;summary=Explore%20your%20county%20through%20over%20500%20indicators%20and%20nearly%2070%20datasets." class="popup">
                            <span class="icon">
                                <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="28px" height="28px" viewBox="0 0 28 28" enable-background="new 0 0 28 28" xml:space="preserve">
                                    <path d="M25.424,15.887v8.447h-4.896v-7.882c0-1.979-0.709-3.331-2.48-3.331c-1.354,0-2.158,0.911-2.514,1.803
                                        c-0.129,0.315-0.162,0.753-0.162,1.194v8.216h-4.899c0,0,0.066-13.349,0-14.731h4.899v2.088c-0.01,0.016-0.023,0.032-0.033,0.048
                                        h0.033V11.69c0.65-1.002,1.812-2.435,4.414-2.435C23.008,9.254,25.424,11.361,25.424,15.887z M5.348,2.501
                                        c-1.676,0-2.772,1.092-2.772,2.539c0,1.421,1.066,2.538,2.717,2.546h0.032c1.709,0,2.771-1.132,2.771-2.546
                                        C8.054,3.593,7.019,2.501,5.343,2.501H5.348z M2.867,24.334h4.897V9.603H2.867V24.334z"/>
                                </svg>
                            </span>
                            <span class="text">linkedin</span>
                        </a>
                    </li>
                    <li class="twitter">
                        <!-- Replace href with your Meta and URL information  -->
                        <a id="twitterContent" href="http://twitter.com/home?status=See%20Federal%20Funding%20data%20for%20your%20county%20by%20@NACoTweets%20%23NACoCIC%20www.naco.org%2FCIC" class="popup">
                            <span class="icon">
                                <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
                                     width="28px" height="28px" viewBox="0 0 28 28" enable-background="new 0 0 28 28" xml:space="preserve">
                                <path d="M24.253,8.756C24.689,17.08,18.297,24.182,9.97,24.62c-3.122,0.162-6.219-0.646-8.861-2.32
                                    c2.703,0.179,5.376-0.648,7.508-2.321c-2.072-0.247-3.818-1.661-4.489-3.638c0.801,0.128,1.62,0.076,2.399-0.155
                                    C4.045,15.72,2.215,13.6,2.115,11.077c0.688,0.275,1.426,0.407,2.168,0.386c-2.135-1.65-2.729-4.621-1.394-6.965
                                    C5.575,7.816,9.54,9.84,13.803,10.071c-0.842-2.739,0.694-5.64,3.434-6.482c2.018-0.623,4.212,0.044,5.546,1.683
                                    c1.186-0.213,2.318-0.662,3.329-1.317c-0.385,1.256-1.247,2.312-2.399,2.942c1.048-0.106,2.069-0.394,3.019-0.851
                                    C26.275,7.229,25.39,8.196,24.253,8.756z"/>
                                </svg>
                           </span>
                            <span class="text">twitter</span>
                        </a>
                    </li>
                    <li class="googleplus">
                        <!-- Replace href with your meta and URL information.  -->
                        <a href="https://plus.google.com/share?url=http://www.naco.org/CIC" class="popup">
                            <span class="icon">
                                <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="28px" height="28px" viewBox="0 0 28 28" enable-background="new 0 0 28 28" xml:space="preserve">
                                    <g>
                                        <g>
                                            <path d="M14.703,15.854l-1.219-0.948c-0.372-0.308-0.88-0.715-0.88-1.459c0-0.748,0.508-1.223,0.95-1.663
                                                c1.42-1.119,2.839-2.309,2.839-4.817c0-2.58-1.621-3.937-2.399-4.581h2.097l2.202-1.383h-6.67c-1.83,0-4.467,0.433-6.398,2.027
                                                C3.768,4.287,3.059,6.018,3.059,7.576c0,2.634,2.022,5.328,5.604,5.328c0.339,0,0.71-0.033,1.083-0.068
                                                c-0.167,0.408-0.336,0.748-0.336,1.324c0,1.04,0.551,1.685,1.011,2.297c-1.524,0.104-4.37,0.273-6.467,1.562
                                                c-1.998,1.188-2.605,2.916-2.605,4.137c0,2.512,2.358,4.84,7.289,4.84c5.822,0,8.904-3.223,8.904-6.41
                                                c0.008-2.327-1.359-3.489-2.829-4.731H14.703z M10.269,11.951c-2.912,0-4.231-3.765-4.231-6.037c0-0.884,0.168-1.797,0.744-2.511
                                                c0.543-0.679,1.489-1.12,2.372-1.12c2.807,0,4.256,3.798,4.256,6.242c0,0.612-0.067,1.694-0.845,2.478
                                                c-0.537,0.55-1.438,0.948-2.295,0.951V11.951z M10.302,25.609c-3.621,0-5.957-1.732-5.957-4.142c0-2.408,2.165-3.223,2.911-3.492
                                                c1.421-0.479,3.25-0.545,3.555-0.545c0.338,0,0.52,0,0.766,0.034c2.574,1.838,3.706,2.757,3.706,4.479
                                                c-0.002,2.073-1.736,3.665-4.982,3.649L10.302,25.609z"/>
                                            <polygon points="23.254,11.89 23.254,8.521 21.569,8.521 21.569,11.89 18.202,11.89 18.202,13.604 21.569,13.604 21.569,17.004
                                                23.254,17.004 23.254,13.604 26.653,13.604 26.653,11.89      "/>
                                        </g>
                                    </g>
                                </svg>
                            </span>
                            <span class="text">google+</span>
                        </a>
                    </li>
                </ul>
			</div>
			<!-- Buttons end here -->
	    </div>
	    </div>
	    <script>window.jQuery || document.write('<script src="../js/vendor/jquery-1.10.2.min.js"><\/script>')</script>
        <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
        <!-- SmartMenus jQuery plugin -->
		<script src="../js/jquery.smartmenus.js" type="text/javascript"></script>
		<!-- SmartMenus jQuery Bootstrap Addon -->
		<script type="text/javascript" src="../js/jquery.smartmenus.bootstrap.min.js"></script>
		<!--RRSSB js -->
        <script src="../js/rrssb.min.js"></script>
        <script src="../js/vendor/nprogress.js"></script>
		<script src="../js/vendor/jquery.noty.packaged.min.js"></script>
		<script src="../js/vendor/jquery.doubletap.js"></script>
		<script src="../js/svgenie/rgbcolor.js"></script>
		<script src="../js/svgenie/canvg.js"></script>
		<script src="../js/svgenie/svgenie.js"></script>
        <script src="../js/plugins.js"></script>
        <script src="../js/colorlegend.js"></script>
        <script src="../js/main.js"></script>
        <!-- Google Analytics: -->
        <script>
		  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
		  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
		  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
		  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
		
		  ga('create', 'UA-44457538-4', 'naco.org');
		  ga('send', 'pageview');
		
		</script>
	
    </body>
</html>



</CFIF>