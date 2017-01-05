Configuration MgmtServerConfig
{
    #Install-Module Azure -Force|Out-file c:\logs.txt
    #Install-Azure
      

	Node localhost
 	{
 
#Install-AzureRMPowershellModules
 		Script InstallAzureRMPowershellModules
        	{
	            SetScript = { 
                    $script = Install-Module Azure
                 }
	            TestScript = { 
                   $azurepsinstalled=get-wmiobject -class Win32_Product|where-object Name -like '*Azure Powershell*' 
            
                    if($Azurepsinstalled)
                    {
                        $True
                    }
                    else
                    {
                        $False
                    }
                }
	            GetScript = {<# This must return a hash table #>}
        	}

    }#End of node

}


