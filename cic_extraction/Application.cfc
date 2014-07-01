
<cfcomponent> 
<cfset This.name = "NACoCIC"> 
<cfset This.Sessionmanagement="True"> 
<cfset This.loginstorage="session"> 
 
<cffunction name="OnRequestStart"> 
    <cfargument name = "request" required="true"/>
	<cfif IsDefined("Form.logout")> 
        <cflogout> 
    </cfif> 
 
 
 <cflogin> 
        <cfif NOT IsDefined("cflogin")> 
            <cfinclude template="loginform.cfm"> 
            <cfabort> 
        <cfelse> 
            <cfif cflogin.name IS "" OR cflogin.password IS ""> 
                <cfoutput> 
                    <h2>You must enter a valid User Name and Password. </h2> 
                </cfoutput> 
                <cfinclude template="loginform.cfm"> 
                <cfabort> 
            <cfelse> 
                <cfquery name="loginQuery" dataSource="naco_cic"> 
                SELECT UserID, Roles 
                FROM tbl_logins
                WHERE 
                    UserID = '#cflogin.name#' 
                    AND Password = '#cflogin.password#' 
                </cfquery> 
                
                <cfif loginQuery.Roles NEQ "">
                    <cfloginuser name="#cflogin.name#" Password = "#cflogin.password#" roles="#loginQuery.Roles#"> 
                <cfelse> 
                
                    <cfoutput> 
                        <H2>Your login information is not valid.<br>Please Try again</H2> 
                    </cfoutput>     
                      <cfinclude template="loginform.cfm"> 
                    <cfabort> 
                </cfif> 
            </cfif>     
        </cfif> 
    </cflogin> 

 <cfif GetAuthUser() NEQ ""> 
        <cfoutput> 
                <form action="cic_extraction_1.cfm" method="Post"> 
                <input type="submit" Name="Logout" value="Logout"> 
                </form> 
        </cfoutput> 
    </cfif> 
 

</cffunction>
</cfcomponent>