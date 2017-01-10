#http://geekswithblogs.net/Wchrabaszcz/archive/2013/09/04/how-to-install-windows-server-features-using-powershell--server.aspx
Configuration NtierServerConfig
{
	Node ("localhost")
	{
		#Install the App Server Role
		WindowsFeature AppServer
		{
			Ensure = "Present"
			Name = "Application-Server"
		}
		
		#Install ASNet Framework
		WindowsFeature ASNETFramework
		{
			Ensure = "Present"
			Name = "AS-NET-Framework"
		}
		#Install ASEntServices
		WindowsFeature ASEntServices
		{
			Ensure = "Present"
			Name = "AS-Ent-Services"
		}

		#Install ASIncomingTrans
		WindowsFeature ASIncomingTrans
		{
			Ensure = "Present"
			Name = "AS-Incoming-Trans"
		}

		#Install AS-Outgoing-Trans
		WindowsFeature ASOutgoingTrans
		{
			Ensure = "Present"
			Name = "AS-Outgoing-Trans"
		}

		#Install PrintServices
		WindowsFeature PrintServices
		{
			Ensure = "Present"
			Name = "Print-Services"
		}

		#Install PrintServer
		WindowsFeature PrintServer
		{
			Ensure = "Present"
			Name = "Print-Server"
		}
		#Install the IIS Role
		WindowsFeature IIS
		{
			Ensure = "Present"
			Name = "Web-Server"
		}
		
		#Install Web Server
		WindowsFeature WebWebServer
		{
			Ensure = "Present"
			Name = "Web-WebServer"
		}

		#Install Common HTTP Features 
		WindowsFeature WebCommonHttp
		{
			Ensure = "Present"
			Name = "Web-Common-Http"
		}

		#Install Default Document
		WindowsFeature DefaultDocument
		{
			Ensure = "Present"
			Name = "Web-Default-Doc"
		}
		#Install Web Directory Browsing
		WindowsFeature WebDirBrowsing
		{
			Ensure = "Present"
			Name = "Web-Dir-Browsing"
		}
		#Install Web HTTP Errors
		WindowsFeature WebHttpErrors
		{
			Ensure = "Present"
			Name = "Web-Http-Errors"
		}
		#Install Static Content
		WindowsFeature StaticContent
		{
			Ensure = "Present"
			Name = "Web-Static-Content"
		}

		#Install Web Health
		WindowsFeature WebHealth
		{
			Ensure = "Present"
			Name = "Web-Health"
		}

		#Install Web HTTP Logging
		WindowsFeature WebHttpLogging
		{
			Ensure = "Present"
			Name = "Web-Http-Logging"
		}
	
		#Install Web HTTP Tracing
		WindowsFeature WebHttpTracing

		{
			Ensure = "Present"
			Name = "Web-Http-Tracing"
		}

		#Install Web Performance
		WindowsFeature WebPerformance
		{
			Ensure = "Present"
			Name = "Web-Performance"
		}

		#Install Static Content Compression
		WindowsFeature StaticContentCompression
		{
			Ensure = "Present"
			Name = "Web-Stat-Compression"
		}

		#Install Web Security
		WindowsFeature WebSecurity
		{
			Ensure = "Present"
			Name = "Web-Security"
		}

		#Install Request Filtering
		WindowsFeature RequestFiltering
		{
			Ensure = "Present"		
			Name = "Web-Filtering"
		}

		#Install WebWebSockets
		WindowsFeature WebWebSockets
		{
			Ensure = "Present"		
			Name = "Web-WebSockets"
		}

		#Install Web App Dev
		WindowsFeature WebAppDev
		{
			Ensure = "Present"
			Name = "Web-App-Dev"
		}

		#Install NET Extensibility 45
		WindowsFeature NetExt45
		{
			Ensure = "Present"
			Name = "Web-Net-Ext45"
		}

		#Install ASP.NET 4.5
		WindowsFeature ASP45
		{
			Ensure = "Present"
			Name = "Web-Asp-Net45"
		}

		#Install ISAPI Extensions
		WindowsFeature WebISAPI_EXT
		{
			Ensure = "Present"
			Name = "Web-ISAPI-Ext"
		}

		#Install ISAPI Filters
		WindowsFeature ISAPI_Filters
		{
			Ensure = "Present"
			Name = "Web-ISAPI-Filter"
		}

		#Install Web Mgmt Tools
		WindowsFeature WebMgmtTools
		{
			Ensure = "Present"
			Name = "Web-Mgmt-Tools"
		}

		WindowsFeature WebServerManagementConsole
		{
			Ensure = "Present"	
			Name = "Web-Mgmt-Console"
		}

		#Install Web Metabase
		WindowsFeature WebMetabase
		{
			Ensure = "Present"
			Name = "Web-Metabase"
		}

		#Install .NET Framework Features
		WindowsFeature NETFramework45Features
		{
			Ensure = "Present"
			Name = "NET-Framework-45-Features"
		}

		#Install .NET Framework 4.5 Core
		WindowsFeature NETFramework45Core
		{
			Ensure = "Present"
			Name = "NET-Framework-45-Core"
		}

		#Install .NET Framework 45 ASPNET
		WindowsFeature NETFramework45ASPNET
		{
			Ensure = "Present"
			Name = "NET-Framework-45-ASPNET"
		}

		#Install .NET 45 WCF Services
		WindowsFeature NET-WCF-Services45
		{
			Ensure = "Present"
			Name = "NET-WCF-Services45"
		}

		#Install NET WCF TCP Port Sharing45
		WindowsFeature NETWCFTCPPortSharing45
		{
			Ensure = "Present"
			Name = "NET-WCF-TCP-PortSharing45"
		}

		#Install RSATPrintServices
		WindowsFeature RSATPrintServices
		{
			Ensure = "Present"
			Name = "RSAT-Print-Services"
		}

		#Install NET Extensibility 35
		WindowsFeature NetExt35
		{
			Ensure = "Present"
			Name = "Web-Net-Ext"
		}

		#Install ASP.NET 3.5
#		WindowsFeature ASP35
#		{
#			Ensure = "Present"
#			Name = "Web-Asp-Net"
#		}
    }
########################


######################################################################
##                                                                  ##
##                     FUNCTION Set-ParagonIIS32bit                 ##
##          - Function used to enable 32-bit IIS                    ##
##                                                                  ##
######################################################################

    <#
    .Synopsis
       Enables 32-bit IIS  for Paragon servers
    .DESCRIPTION
       Enables 32-bit IIS  for Paragon servers
    .EXAMPLE
       Set-ParagonIIS32bit -IISAppPoolName "MyAppPool"
    .EXAMPLE
       Set-ParagonIIS32bit -IISAppPoolName "DefaultAppPool"
    .EXAMPLE
       Set-ParagonIIS32bit
    #>
    FUNCTION Set-ParagonIIS32bit
    {
        param 
        (
            # IISAppPoolName - AppPoolName to set 32-Bit setting on.  Default is "DefaultAppPool"
            [Parameter(Mandatory=$false, 
            ValueFromPipeline=$true,
            Position=0)]
            [string]
            $IISAppPoolName="DefaultAppPool"
        )

        Try
        {
            Import-Module WebAdministration
            $AppPoolString = ("IIS:\AppPools\" + $IISAppPoolName)
            Set-ItemProperty $AppPoolString -Name enable32BitAppOnWin64 -Value TRUE -ErrorAction Stop
            $returnValue = "`nSUCCESS: 32-bit IIS Set on $IISAppPoolName"
        }
        Catch
        {
            $returnValue = "`nERROR: Error while configuring 32-bit setting on $IISAppPoolName"
        }
        Finally
        {
            $returnValue
        }
    }
    Set-ParagonIIS32bit

######################################################################
##                                                                  ##
##          FUNCTION Set-ParagonIISAppPoolRecycling                 ##
##          - Function used to set app pool recycling times         ##
##                                                                  ##
######################################################################

    <#
    .Synopsis
       Set all app pool recycling times
    .DESCRIPTION
       Sets the App Pool Recyling time for all application pools in IIS
    .EXAMPLE
       Set-ParagonIISAppPoolRecycling
    #>
    FUNCTION Set-ParagonIISAppPoolRecycling
    {
        Import-Module WebAdministration

        Try
        {
            $appPools = Get-ChildItem IIS:\AppPools

            foreach ($appPool in $appPools)
            {
                # set the Recycling Time Interval to 0, which disables the setting
                Set-ItemProperty -Path ("IIS:\AppPools\" + $appPool.name) -Name recycling.periodicrestart.time -Value ([TimeSpan]::FromMinutes(0))

                # set the Recycling schedule to 2 AM
                Set-ItemProperty -Path ("IIS:\AppPools\" + $AppPool.name) -Name Recycling.periodicRestart.schedule -Value @{value="02:00:00"}
            }

            $returnStatus = "`nSUCCESS: IIS Application Pool Recycling times have been set"
        }
        Catch
        {
            $returnStatus = "`nERROR: IIS Application Pool Recycling times could not be set"
        }

        $returnStatus
    }

    Set-ParagonIISAppPoolRecycling


######################################################################
##                                                                  ##
##               FUNCTION Set-ParagonDisableForceUnloadProfile      ##
##      - Function used to check that 'Do no forcefully unload      ##
##        the users registry at user logoff' setting is Enabled in  ##
##        Local Group Policy                                        ##
##                                                                  ##
######################################################################

    <#
    .Synopsis
       Checks and attempts to set 'Do no forcefully unload the users registry at user logoff' setting in Local Group Policy for Paragon servers
    .DESCRIPTION
       Checks and attempts to set 'Do no forcefully unload the users registry at user logoff' setting in Local Group Policy for Paragon servers
    .EXAMPLE
       Set-ParagonDisableForceUnloadProfile 
    .EXAMPLE
       Set-ParagonDisableForceUnloadProfile 
    #>
    FUNCTION Set-ParagonDisableForceUnloadProfile
    {

        # Must use Get-ItemProperty in this case because Test-Path does not work for individual registry keys, only folder paths
        Try
        {
            if ((Test-Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System') -eq $false)
            { 
                md HKLM:\SOFTWARE\Policies\Microsoft\Windows\System 
            } 
            SET-ITEMPROPERTY -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -name "DisableForceUnload" -Value 1 -ErrorAction Stop
            Get-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name "DisableForceUnload" -ErrorAction Stop | Out-Null
            $returnValue = "`nSUCCESS: Local Group Policy setting 'Do not forcefully unload the users registry at user logoff' is enabled"
        }
        Catch
        {
            $returnValue = "`nERROR: Local Group Policy setting 'Do not forcefully unload the users registry at user logoff' was NOT enabled"
        }
        finally
        {
            $returnValue
        }
    }  

    Set-ParagonDisableForceUnloadProfile
    
} 