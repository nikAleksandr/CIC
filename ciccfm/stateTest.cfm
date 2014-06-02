<!--- Listing of Counties for Selected State --->

<CFPARAM NAME="statecode" DEFAULT="">

        <CFQUERY NAME="getstate" datasource="naco_cic">
		SELECT *
		FROM States (NOLOCK)
		WHERE Statecode =  '#statecode#'
		</CFQUERY> 
			
		<CFQUERY NAME="getcounties" datasource="naco_cic">
		SELECT FIPS,   County_Name, State, county_seat, Member_Status,  Org_Type,
		Population_2010, Total_Square_Miles, founded,  board_size, Gov_Type
		FROM  County_Data  (NOLOCK)
		WHERE State='#statecode#' and Org_Type in ('County', 'Independent City', 'County W/o Govt Structure', 'Geographical Census Area') 
		ORDER BY Org_Type
		</CFQUERY> 
     

<CFOUTPUT> 
#SerializeJSON(getcounties,true)#
</CFOUTPUT>