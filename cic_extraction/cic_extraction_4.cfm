<cfparam name="catlist" default="">
<cfparam name="selected_state" default="">

<cfquery datasource="naco_cic" name="get_states">
select statecode, statename
from states
where countrycode = 'USA'
</cfquery>


<CFIF #selected_state# NEQ "">
        <cfquery datasource="naco_cic" name="get_counties">
        select FIPS, County_Name, State from County_data
        where state = '#Selected_State#'
        </cfquery>
 <CFELSE>
        <cfquery datasource="naco_cic" name="get_counties">
        select FIPS, County_Name, State from County_data
        where state = 'AL'
        </cfquery>
</CFIF>



<CFIF #catlist# NEQ "">
        <cfquery datasource="naco_cic" name="get_sub_category">
        select * from categories
        where cat_code = '#catlist#' and sub_cat is not null
        </cfquery>
<CFELSE>
        <cfquery datasource="naco_cic" name="get_sub_category">
        select * from categories
        where cat_code = 'admin'  and sub_cat is not null
        </cfquery>
</CFIF> 


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CIC</title>




<p><em><font size="4">Choose Categories:</font></em></p>

<select id="catlist" name="Category_List" size="10" multiple>
      <option value="Administration">Administration</option>
      <option value="County_Employment">County Employment
      <option value="County_Finance">County Finance
      <option value="County_Structure">County Structure
      <option value="Demographics">Demographics
      <option value="Economy">Economy
      <option value="Education">Education
      <option value="Federal_Funding">Federal Funding
      <option value="Geography">Geography
      <option value="Health_Hospitals">Health & Hospitals
      <option value="Housing_Community_Development">Housing & Community Development
      <option value="Justice_Public_Safety">Justice & Public Safety
      <option value="Public_Amenity">Public Amenity
      <option value="Public_Welfare">Public Welfare
      <option value="Transportation">Transportation
      <option value="Utility">Utility
      <option value="W_S_SW">Water, Sewage & Solid Waste
</select>





<button onclick="ValidateSelectionCategory()">Next</button>



<!-- start of second tab -->
<div id="tab2" style="display: none;">
<p><em><font size="4">Choose Sub-categories:</font></em></p>


<select id="sublist" name="SubCategory_List" size="10" multiple>
  <option>sub-category 1</option>
  <option>sub-category 2</option>
</select>



<button onclick="validateSelectionSubcat()">Next</button>

</div>


<!-- start of third tab -->
<div id="tab3" style="display: none;">
<p><em><font size="4">Choose States:</font></em></p>

<select id="statelist" name="States List" size="10" multiple>
  <option value="ALL">All States</option>
  <CFOUTPUT query="get_states">
  <option value="#StateCode#">#StateName#</option>
  </CFOUTPUT>
  
</select>

<button onclick="tab('tab4')">Next</button>
</div>


<!-- start of tab4 -->
<div id="tab4" style="display: none;">
<p><em><font size="4">Choose Counties:</font></em></p>

<select id="countylist" name="County List" size="10" multiple>
  <option>County 1</option>
  <option>County 2</option>
</select>


<button onclick="validateSectionCounty()">Next</button>
</div>

<!-- start of tab5 -->
<div id="tab5" style="display: none;">
<p><em><font size="4">Choose Years:</font></em></p>

<select id="yearlist" name="Year List" size="10" multiple>
  <option value ="2000">2000  </option>
  <option value ="2001">2001  </option>
  <option value ="2002">2002  </option>
  <option value ="2003">2003  </option>
  <option value ="2004">2004  </option>
  <option value ="2005">2005  </option>
  <option value ="2006">2006  </option>
  <option value ="2007">2007  </option>
  <option value ="2008">2008  </option>
  <option value ="2009">2009  </option>
  <option value ="2010">2010  </option>
  <option value ="2011">2011  </option>
  <option value ="2012">2012  </option>
  <option value ="2013">2013  </option>
</select>



<button onclick="validateSelectionYear()">Download Data</button>
</div>

</div>
</div>
</body>
</html>