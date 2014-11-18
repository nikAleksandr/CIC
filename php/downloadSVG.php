<?php
	$data = $_REQUEST['data'];
	$file = "map.svg";
	
	header('Content-type: image/svg+xml');
	header("Content-Disposition: attachment; filename=" . $file);
	
	echo('<?xml version="1.0" encoding="iso-8859-1"?>' . "\n"); 
	echo('<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 20000303 Stylable//EN" "http://www.w3.org/TR/2000/03/WD-SVG-20000303/DTD/svg-20000303-stylable.dtd">' . "\n");  
	echo $data;	
?>