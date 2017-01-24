#install-module -name xSQLServer


Configuration DBServerConfig
{
   param 
   ( 
        [Parameter(Mandatory)]
        [String]$DomainName,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$Admincreds,

       # [Int]$RetryCount=20,
       # [Int]$RetryIntervalSec=30,

        [Parameter(Mandatory)]
        [String]$StorageAccountName,

        [Parameter(Mandatory)]
        [String]$StorageAccountContainer,

        [Parameter(Mandatory)]
        [String]$StorageAccountKey

    ) 

    Import-DscResource -ModuleName PSDesiredStateConfiguration, xPendingReboot, xAzureStorage #xSQLServer    
    #Get-DscResource xSQLServerSetup |select -expand properties   
    #$admincreds=Get-Credential
    #$domainname='IRMCHOSTED.COM'
   
    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${DomainName}\$($Admincreds.UserName)", $Admincreds.Password)
    $Username=$DomainName+'\'+$Admincreds.Username
	Node ("localhost")
 	{

#PARAGON Server Common Config 
#Set-ParagonServerCommonConfig
 		Script Set-ParagonPowerPlan
        	{
	            SetScript = { Powercfg -SETACTIVE SCHEME_MIN }
	            TestScript = { return ( Powercfg -getactivescheme) -like "*High Performance*" }
	            GetScript = { return @{ Powercfg = ( "{0}" -f ( powercfg -getactivescheme ) ) } }
        	}

#Set-ParagonMSDTCConfig
        #SET-ITEMPROPERTY HKLM:\software\microsoft\ole -name "EnableDCOM" -value "Y" -ErrorAction Stop
        Registry EnableDCOM
        {
            Ensure = "Present"
            Key = "HKLM:\software\microsoft\ole"
            ValueName = "EnableDCOM"
            ValueData = "Y"
        }
        #SET-ITEMPROPERTY HKLM:\software\microsoft\ole -name "LegacyImpersonationLevel" -value 2 -type "Dword" -ErrorAction SilentlyContinue
        Registry LegacyImpersonationLevel
        {
            Ensure = "Present"
            Key = "HKLM:\software\microsoft\ole"
            ValueName = "LegacyImpersonationLevel"
            ValueData = "2"
            ValueType ="Dword"
        }
 
        #SET-ITEMPROPERTY HKLM:\software\microsoft\ole -name "LegacyAuthenticationLevel" -value 2 -type "Dword" -ErrorAction SilentlyContinue
        Registry LegacyAuthenticationLevel
        {
            Ensure = "Present"
            Key = "HKLM:\software\microsoft\ole"
            ValueName = "LegacyAuthenticationLevel"
            ValueData = "2"
            ValueType ="Dword"
        }
        
        #SET-ITEMPROPERTY HKLM:\software\microsoft\ole -name "MachineLaunchRestriction" `
        #            -value ([byte[]](0x01,0x00,0x04,0x80,0x90,0x00,0x00,0x00,0xa0,0x00,0x00,0x00,0x00, `
        #            0x00,0x00,0x00,0x14,0x00,0x00,0x00,0x02,0x00,0x7c,0x00,0x05,0x00,0x00,0x00,0x00, `
        #            0x00,0x14,0x00,0x1f,0x00,0x00,0x00,0x01,0x01,0x00,0x00,0x00,0x00,0x00,0x01,0x00, `
        #            0x00,0x00,0x00,0x00,0x00,0x18,0x00,0x0b,0x00,0x00,0x00,0x01,0x02,0x00,0x00,0x00, `
        #            0x00,0x00,0x0f,0x02,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x18,0x00,0x1f, `
        #            0x00,0x00,0x00,0x01,0x02,0x00,0x00,0x00,0x00,0x00,0x05,0x20,0x00,0x00,0x00,0x20, `
        #            0x02,0x00,0x00,0x00,0x00,0x18,0x00,0x1f,0x00,0x00,0x00,0x01,0x02,0x00,0x00,0x00, `
        #            0x00,0x00,0x05,0x20,0x00,0x00,0x00,0x2f,0x02,0x00,0x00,0x00,0x00,0x18,0x00,0x1f, `
        #            0x00,0x00,0x00,0x01,0x02,0x00,0x00,0x00,0x00,0x00,0x05,0x20,0x00,0x00,0x00,0x32, `
        #            0x02,0x00,0x00,0x01,0x02,0x00,0x00,0x00,0x00,0x00,0x05,0x20,0x00,0x00,0x00,0x20, `
        #            0x02,0x00,0x00,0x01,0x02,0x00,0x00,0x00,0x00,0x00,0x05,0x20,0x00,0x00,0x00,0x20, `
        #            0x02,0x00,0x00)) -ErrorAction Stop
<#   
        Registry MachineLaunchRestriction
        {
            Ensure = "Present"
            Key = "HKLM:\software\microsoft\ole"
            ValueName = "MachineLaunchRestriction"
            ValueData = $value
        }
#>


        #SET-ITEMPROPERTY HKLM:\software\microsoft\MSDTC\security -name "networkdtcaccess" -value "1" -ErrorAction Stop
        Registry networkdtcaccess
        {
            Ensure = "Present"
            Key = "HKLM:\software\microsoft\MSDTC\security"
            ValueName = "networkdtcaccess"
            ValueData = "1"
        }

        #SET-ITEMPROPERTY HKLM:\software\microsoft\MSDTC\security -name "networkdtcaccessadmin" -value "1" -ErrorAction Stop
        Registry networkdtcaccessadmin
        {
            Ensure = "Present"
            Key = "HKLM:\software\microsoft\MSDTC\security"
            ValueName = "networkdtcaccessadmin"
            ValueData = "1"
        }
        
        #SET-ITEMPROPERTY HKLM:\software\microsoft\MSDTC\security -name "networkdtcaccessinbound" -value "1" -ErrorAction Stop
        Registry networkdtcaccessinbound
        {
            Ensure = "Present"
            Key = "HKLM:\software\microsoft\MSDTC\security"
            ValueName = "networkdtcaccessinbound"
            ValueData = "1"
        }
        
        #SET-ITEMPROPERTY HKLM:\software\microsoft\MSDTC\security -name "networkdtcaccessoutbound" -value "1" -ErrorAction Stop
        Registry networkdtcaccessoutbound
        {
            Ensure = "Present"
            Key = "HKLM:\software\microsoft\MSDTC\security"
            ValueName = "networkdtcaccessoutbound"
            ValueData = "1"
        }

        #SET-ITEMPROPERTY HKLM:\software\microsoft\MSDTC\security -name "networkdtcaccesstransactions" -value "1" -ErrorAction Stop
        Registry networkdtcaccesstransactions
        {
            Ensure = "Present"
            Key = "HKLM:\software\microsoft\MSDTC\security"
            ValueName = "networkdtcaccesstransactions"
            ValueData = "1"
        }	        

        #SET-ITEMPROPERTY HKLM:\software\microsoft\MSDTC\security -name "XAtransactions" -value "1" -ErrorAction Stop
        Registry XAtransactions
        {
            Ensure = "Present"
            Key = "HKLM:\software\microsoft\MSDTC\security"
            ValueName = "XAtransactions"
            ValueData = "1"
        }	        

        #SET-ITEMPROPERTY HKLM:\software\microsoft\MSDTC\security -name "LuTransactions" -value "1" -ErrorAction Stop
        Registry LuTransactions
        {
            Ensure = "Present"
            Key = "HKLM:\software\microsoft\MSDTC\security"
            ValueName = "LuTransactions"
            ValueData = "1"
        }	        

        #SET-ITEMPROPERTY HKLM:\software\microsoft\MSDTC -name "turnoffrpcsecurity" -value "1" -ErrorAction Stop
        Registry turnoffrpcsecurity
        {
            Ensure = "Present"
            Key = "HKLM:\software\microsoft\MSDTC\security"
            ValueName = "turnoffrpcsecurity"
            ValueData = "1"
        }	        

        #SET-ITEMPROPERTY HKLM:\software\microsoft\MSDTC -name "AllowonlySecureRPCCalls" -value "0" -ErrorAction Stop
        Registry AllowonlySecureRPCCalls
        {
            Ensure = "Present"
            Key = "HKLM:\software\microsoft\MSDTC\security"
            ValueName = "AllowonlySecureRPCCalls"
            ValueData = "1"
        }

   		Script Restart-MSDTCService
       	{
            SetScript = { 
                Start-Sleep	-seconds 30 
                RESTART-SERVICE "MSDTC" 
            }
            TestScript = { $False }
            GetScript = { <# This must return a hash table #> }
       	}
#Set-ParagonTSConfig
        #SET-ITEMPROPERTY -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "fAutoClientDrives" -Value 1 -ErrorAction Stop
        Registry fAutoClientDrives
        {
            Ensure = "Present"
            Key = "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
            ValueName = "fAutoClientDrives"
            ValueData = "1"
        }

        #SET-ITEMPROPERTY -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "fAutoClientLpts" -Value 1 -ErrorAction Stop
        Registry fAutoClientLpts
        {
            Ensure = "Present"
            Key = "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
            ValueName = "fAutoClientLpts"
            ValueData = "1"
        }

        #SET-ITEMPROPERTY -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "fDisableAudioCapture" -Value 1 -ErrorAction Stop
        Registry fDisableAudioCapture
        {
            Ensure = "Present"
            Key = "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
            ValueName = "fDisableAudioCapture"
            ValueData = "1"
        }

        #SET-ITEMPROPERTY -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "fDisableCam" -Value 1 -ErrorAction Stop
        Registry fDisableCam
        {
            Ensure = "Present"
            Key = "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
            ValueName = "fDisableCam"
            ValueData = "1"
        }

        #SET-ITEMPROPERTY -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "fDisableCcm" -Value 1 -ErrorAction Stop
        Registry fDisableCcm
        {
            Ensure = "Present"
            Key = "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
            ValueName = "fDisableCcm"
            ValueData = "1"
        }

        #SET-ITEMPROPERTY -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "fDisableCdm" -Value 0 -ErrorAction Stop
        Registry fDisableCdm
        {
            Ensure = "Present"
            Key = "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
            ValueName = "fDisableCdm"
            ValueData = "0"
        }

        #SET-ITEMPROPERTY -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "fDisableCpm" -Value 1 -ErrorAction Stop
        Registry fDisableCpm
        {
            Ensure = "Present"
            Key = "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
            ValueName = "fDisableCpm"
            ValueData = "1"
        }

        #SET-ITEMPROPERTY -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "fDisableLPT" -Value 1 -ErrorAction Stop
        Registry fDisableLPT
        {
            Ensure = "Present"
            Key = "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
            ValueName = "fDisableLPT"
            ValueData = "1"
        }
        #SET-ITEMPROPERTY -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fsinglesessionperuser" -value 0 -ErrorAction Stop
        Registry fsinglesessionperuser
        {
            Ensure = "Present"
            Key = "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
            ValueName = "fsinglesessionperuser"
            ValueData = "0"
        }


#Set-ParagonDisallowAnimations
        #SET-ITEMPROPERTY -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DWM' -name "DisallowAnimations" -Value 1 -ErrorAction Stop
        Registry DisallowAnimations
        {
            Ensure = "Present"
            Key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DWM"
            ValueName = "DisallowAnimations"
            ValueData = "1"
        }
#New-ParagonDataCollectorSet
#Need to review this one, as it will not have SQL installed initially which is required to determine instance names for DCS


#End of Paragon Common Config

#DB Server Specific below

 
		#Install Storage Services
		WindowsFeature Storage-Services
		{
			Ensure = "Present"
			Name = "Storage-Services"
		}

		#Install .NET Framework Core
		WindowsFeature NETFrameworkCore
		{
			Ensure = "Present"
			Name = "NET-Framework-Core"
		}
	
		#Install NET-Framework-45-Core
		WindowsFeature NET-Framework-45-Core
		{
			Ensure = "Present"
			Name = "NET-Framework-45-Core"
		}


		#Install Failover-Clustering
		WindowsFeature Failover-Clustering
		{
			Ensure = "Present"
			Name = "Failover-Clustering"
		}

		#Install RDC
		WindowsFeature RDC
		{
			Ensure = "Present"
			Name = "RDC"
		}

		#Install FS-SMB1
		WindowsFeature FS-SMB1
		{
			Ensure = "Present"
			Name = "FS-SMB1"
		}

		#Install Server-Gui-Mgmt-Infra
		WindowsFeature Server-Gui-Mgmt-Infra
		{
			Ensure = "Present"
			Name = "Server-Gui-Mgmt-Infra"
		}

		#Install Server-Gui-Shell
		WindowsFeature Server-Gui-Shell
		{
			Ensure = "Present"
			Name = "Server-Gui-Shell"
		}
<#
		#Had an issue with this returning an error, even though PS is installed OOB
		#Install  PowerShell
		WindowsFeature  PowerShell
		{
			Ensure = "Present"
			Name = " PowerShell"
		}
#>
		#Install PowerShell-V2
		WindowsFeature PowerShell-V2
		{
			Ensure = "Present"
			Name = "PowerShell-V2"
		}

		#Install PowerShell-ISE
		WindowsFeature PowerShell-ISE
		{
			Ensure = "Present"
			Name = "PowerShell-ISE"
		}
		
		#Install WoW64-Support
		WindowsFeature WoW64-Support
		{
			Ensure = "Present"
			Name = "WoW64-Support"
		}

		#Install XPS-Viewer
		WindowsFeature XPS-Viewer
		{
			Ensure = "Present"
			Name = "XPS-Viewer"
		}


		#Install NET-WCF-TCP-PortSharing45
		WindowsFeature NET-WCF-TCP-PortSharing45


		{
			Ensure = "Present"
			Name = "NET-WCF-TCP-PortSharing45"
		}

          Script Output-SQLAcct
        {
                Setscript=
                {
                    $tempPath='C:\temp'
                    if (!(Test-path $tempPath))
		            {
        		        $temppathfoldercreateresult = New-Item $tempPath -type Directory
                        write-output $temppathfoldercreateresult
		            } 

                    $username=$using:username
                    $username|out-file 'C:\temp\username1.txt' -Force

                }
                GetScript = {<# This must return a hash table #> }
                TestScript=
                {
                    $tempPath='C:\temp\username1.txt'
                    if ((Test-path $tempPath))
		            {
                        $true
		            }    
                    else
                    {
                        $false
                    }
                }

        }

        #to be used as part of sql install 


		Script Configure-StoragePool
        	{
	            SetScript = { 
		        $PhysicalDisks = Get-StorageSubSystem -FriendlyName "Storage Spaces*" | Get-PhysicalDisk -CanPool $True
                $DataDisks = $PhysicalDisks | Where-Object FriendlyName -in('PhysicalDisk2','PhysicalDisk3','Physicaldisk4','PhysicalDisk5')
                $LogDisks = $PhysicalDisks | Where-Object FriendlyName -in('PhysicalDisk6','PhysicalDisk7')
                $SystemDisks = $PhysicalDisks | Where-Object FriendlyName -in('PhysicalDisk8','PhysicalDisk9')

		        If($DataDisks.Count -gt 3)
			    {
			        $totalstorageconfigresult = New-StoragePool -FriendlyName "SQLData1Pool01A" -StorageSubsystemFriendlyName "Storage Spaces*" -PhysicalDisks $DataDisks | New-VirtualDisk -FriendlyName "SQLData1Disk01A" -Size 4088GB -ProvisioningType Fixed -ResiliencySettingName Simple|Initialize-Disk -PassThru | New-Partition -DriveLetter 'F' -UseMaximumSize
			        write-output $totalstorageconfigresult
                    start-sleep -s 30
			        $Partition = get-partition| Where-Object DriveLetter -eq "F" 
				
                    if ($Partition)
	   			    {
					    $formatvolumeresult = $Partition|Format-Volume -Confirm:$False -AllocationUnitSize 64KB
                        write-output $formatvolumeresult
				    }
			    }
			    else
		        {
           		    Write-Output "$(get-date) : All 4 data disks are not available. Please review to confirm disks were created successfully. Details of disks are below"
           		    Write-Error($DataDisks) -ErrorAction Stop
           		}
	
                If($LogDisks.Count -gt 1)
			    {
			        $totalstorageconfigresult2 = New-StoragePool -FriendlyName "SQLLogsPool01A" -StorageSubsystemFriendlyName "Storage Spaces*" -PhysicalDisks $LogDisks | New-VirtualDisk -FriendlyName "SQLLogs1Disk01A" -Size 2044GB -ProvisioningType Fixed -ResiliencySettingName Simple|Initialize-Disk -PassThru | New-Partition -DriveLetter 'G' -UseMaximumSize
			        write-output $totalstorageconfigresult2
                    start-sleep -s 30
			        $Partition = get-partition| Where-Object DriveLetter -eq "G" 
				    if ($Partition)
 				    {
					    $formatvolumeresult2 = $Partition|Format-Volume -Confirm:$False -AllocationUnitSize 64KB
                        write-output $formatvolumeresult2
  				    }
			    }
			    else
		        {
           		Write-Output "$(get-date) : Two log disks are not available. Please review to confirm disk are created successfully. Details of disks are below"
           		Write-Error($PhysicalDisks) -ErrorAction Stop
           		}
           			
		        If($SystemDisks.Count -gt 1)
			    {
                    $totalstorageconfigresult3 = New-StoragePool -FriendlyName "SQLSystemDBPool01A" -StorageSubsystemFriendlyName "Storage Spaces*" -PhysicalDisks $SystemDisks | New-VirtualDisk -FriendlyName "SQLSystemDBDisk01A" -Size 2044GB -ProvisioningType Fixed -ResiliencySettingName Simple|Initialize-Disk -PassThru | New-Partition -DriveLetter 'H' -UseMaximumSize
			      	write-output $totalstorageconfigresult3
                    start-sleep -s 30
			        $Partition = get-partition| Where-Object DriveLetter -eq "H" 
				    if ($Partition)
 				    {
					    $formatvolumeresult2 = $Partition|Format-Volume -Confirm:$False -AllocationUnitSize 64KB
                        write-output $formatvolumeresult2
  				    }
			    }
			    else
		        {
           		Write-Output "$(get-date) : Two system disks are not available. Please review to confirm disk are created successfully. Details of disks are below"
           		Write-Error($SystemDisks) -ErrorAction Stop
           		}

		    } #End of Set script for ConfigureStoragePool
	            TestScript = { 
                    $Storagepools=get-storagepool |Where-object friendlyname -in ('SQLData1Pool01A','SQLLogsPool01A','SQLSystemDBPool01A')
                    if($StoragePools.count -eq 3)
                    {
                        $True
                    }
                    else
                    {
                        $False
                    }
                } #End of Test Script
	            GetScript = { <# This must return a hash table #> }
                DependsOn = "[Script]Output-SQLAcct" 
        	} #End of ConfigureStoragePool 

		Script Configure-MountPoints
        	{
	            SetScript = { 

                #Configure MountPoint
    	        $DataPath ='C:\DataRoot\Data1'
		        $LogPath ='C:\DataRoot\Logs'
		        $SystemDBPath = 'C:\DataRoot\SystemDB'
		        Write-Output ("$(get-date) : Set-AzureParagonNthDBStorageConfiguration: Configuring Mount Point Folder Structure")
		        #Create directories for Data, Log, System DB
		        if (!(Test-path $DataPath))
		        {
    		        $datapathfoldercreateresult = New-Item $DataPath -type Directory
                    write-output $datapathfoldercreateresult
		        }
		        if (!(Test-path $LogPath))
		        {
    		        $logpathfoldercreateresult = New-Item $LogPath -type Directory
                    write-output $logpathfoldercreateresult
		        }
		        if (!(Test-path $SystemDBPath))
		        {
    		        $systemdbpathfoldercreateresult = New-Item $SystemDBPath -type Directory
                    write-output $systemdbpathfoldercreateresult
		        }
		        Write-Output ("$(get-date) : Set-AzureParagonNthDBStorageConfiguration: Mount Point directories created.")		
		
		        #Mount volumes to access path directories
		        $fdrive=get-partition -DriveLetter f
                $datampdrive=$fdrive|where-object AccessPaths -like "$DataPath\"
                if($datampdrive -eq $Null)
                {
    		        $partitiondatapathresult = Get-Partition -DriveLetter F |Add-PartitionAccessPath -PartitionNumber 2 -AccessPath $DataPath
                    write-output $partitiondatapathresult
                }
                $gdrive=get-partition -DriveLetter g
                $logmpdrive=$gdrive|where-object AccessPaths -like "$LogPath\"
                if($Logmpdrive -eq $Null)
                {
    		        $partitionlogpathresult = Get-Partition -DriveLetter G |Add-PartitionAccessPath -PartitionNumber 2 -AccessPath $LogPath
                    write-output $partitionlogpathresult
                }
                $hdrive=get-partition -DriveLetter h
                $systemdbmpdrive=$hdrive|where-object AccessPaths -like "$SystemDBPath\"
                if($systemdbmpdrive -eq $Null)
                {
	    	        $partitionsystpathresult = Get-Partition -DriveLetter H |Add-PartitionAccessPath -PartitionNumber 2 -AccessPath $SystemDBPath
                    write-output $partitionsystpathresult
                }
		        Write-Output ("$(get-date) : Set-AzureParagonNthDBStorageConfiguration: Partitions mounted to mount point directories.")		
                }
	            TestScript = {

                $fdrive=get-partition -DriveLetter f
                $gdrive=get-partition -DriveLetter g
                $hdrive=get-partition -DriveLetter h

                $datampdrive=$fdrive|where-object AccessPaths -eq 'C:\DataRoot\Data1\'
                $logmpdrive=$gdrive|where-object AccessPaths -eq 'C:\DataRoot\logs\'
                $systemmpdrive=$hdrive|where-object AccessPaths -eq 'C:\DataRoot\systemDB\'

                    if($datampdrive -ne $Null -and $logmpdrive -ne $null -and $systemmpdrive -ne $null)
                    {
                        $true
                    }
                    else
                    {
                        $False
                    }
                 }#End of TestScript 
	            GetScript = {<# This must return a hash table #> }
                DependsOn = "[Script]Configure-StoragePool"
        	}#End of script ConfigureMountPoints

    
    #Install SQL using script method
    #C:\SQLServer_12.0_Full\setup.exe /q /Action=Install /IACCEPTSQLSERVERLICENSETERMS /UpdateEnabled=True /UpdateSource=C:\SQLServer_12.0_Full\CU /FEATURES=SQLEngine,FullText,RS,IS,BC,Conn,ADV_SSMS /ASCOLLATION=Latin1_General_BIN /InstanceName=PARLIVE /SQLBACKUPDIR=C:\DataRoot\SystemDB\Backup /INSTALLSQLDATADIR=C:\DataRoot\SystemDB /SQLSYSADMINACCOUNTS='+$LocalAdminSQL +' /SQLSVCSTARTUPTYPE=AUTOMATIC /SQLTEMPDBDIR=D:\TempDB\MSSQL\Data /SQLTEMPDBLOGDIR=D:\TempDB\MSSQL\Logs /SQLUSERDBDIR=C:\DataRoot\Data1 /SQLUSERDBLOGDIR=C:\DataRoot\Logs /RSINSTALLMODE=FilesOnlyMode
        Script InstallSQLServer
        {
            SetScript = {
                #$LocalAdminSQL=invoke-command {whoami}
                $LocalAdminSQL=get-content 'C:\temp\username1.txt'
                $ArgumentList= "/q /Action=Install /IACCEPTSQLSERVERLICENSETERMS /UpdateEnabled=True /UpdateSource=C:\SQLServer_12.0_Full\CU /FEATURES=SQLEngine,FullText,RS,IS,BC,Conn,ADV_SSMS /SQLCOLLATION=Latin1_General_BIN /InstanceName=PARLIVE /SQLBACKUPDIR=C:\DataRoot\SystemDB\Backup /INSTALLSQLDATADIR=C:\DataRoot\SystemDB /SQLSYSADMINACCOUNTS=$LocalAdminSQL /SQLSVCSTARTUPTYPE=AUTOMATIC /SQLTEMPDBDIR=D:\TempDB\MSSQL\Data /SQLTEMPDBLOGDIR=D:\TempDB\MSSQL\Logs /SQLUSERDBDIR=C:\DataRoot\Data1 /SQLUSERDBLOGDIR=C:\DataRoot\Logs /RSINSTALLMODE=FilesOnlyMode"
                Start-Process C:\SQLServer_12.0_Full\setup.exe  -ArgumentList $ArgumentList -Wait
            }
            TestScript = {
                $SQLInstalled=[System.Data.Sql.SqlDataSourceEnumerator]::Instance.GetDataSources()
                if ($SQLInstalled.InstanceName -eq 'PARLIVE')
                {
                    $True
                }
                else
                {
                    $False
                }
            }
            GetScript ={<# This must return a hash table #>}
                DependsOn = "[Script]Configure-MountPoints"
        }#end of InstallSQLServer

        xPendingReboot PostSQLInstall
        { 
            Name = "Check for a pending reboot before changing anything" 
        }


#New way
#Install-AzurePowershellModules
		Script InstallAzurePowershellModules
        	{
	            SetScript = 
                    {  
                        $trustrepo=Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
                        $install=install-module azure
                        import-module azure 
                    }
	            GetScript =  { @{} }
	            TestScript = 
                    { 
                          $module=get-module -listavailable -name azure -refresh -erroraction silentlycontinue
                          if($module)
                          {
                            $true
                          }
                          else
                          {
                            $false
                          }                        
                    }
                
        	}
    

        xAzureBlobFiles DownloadDBAndVardata 
        {
            Path                    = "C:\downloads"
            StorageAccountName      = $StorageAccountName
            StorageAccountContainer = $StorageAccountContainer
            StorageAccountKey       = $StorageAccountKey
            DependsOn = "[Script]InstallAzurePowershellModules"
        }



<#
    #Install SQL using native xSQLServerSetup resource
        xSQLServerSetup DB01
        {
            SetupCredential = $domaincreds 
            SQLSvcAccount = $domaincreds                                                     
            Features = "SQLEngine,FullText,RS,IS,BC,Conn,ADV_SSMS"
            InstanceName = "PARLIVE"
            SQLSysAdminAccounts = "irmchosted\localadmin"
            SourcePath = "C:\SQLServer_12.0_Full"
            InstallSQLDataDir = "C:\DataRoot\SystemDB"
            SQLTEMPDBDIR="D:\TempDB\MSSQL\Data" 
            SQLTEMPDBLOGDIR="D:\TempDB\MSSQL\Logs" 
            SQLUSERDBDIR="C:\DataRoot\Data1" 
            SQLUSERDBLOGDIR="C:\DataRoot\Logs"
            SQLBackupDir = "C:\DataRoot\Data1\Backup"                                                                                          
        }
#>
#Restore DB
        Script RestoreSQLDB
        {
                SetScript = 
                    {  
                       #will be passed through
                        $storageAccountName=$using:StorageAccountName
                        $StorageAccountKey=$using:StorageAccountKey
                        $StorageAccountContainer='backups'
                        $BackupFileName='paragon_test_20160427-blob.bak'
                        #$BackupFullPath='C:\downloads\'+$BackupFileName
                        $BackupFullPath='https://'+$StorageAccountName+'.blob.core.windows.net/'+$StorageAccountContainer+'/'+$BackupFileName
                        $SourceDBName='paragon_test'
                        $ServerInstanceName='DB01\PARLIVE' 
                        $DestinationDBName='paragon_hosted'
                        $sqlstoragecred='paragoncommonstoragecred'
                        $SecureStorageAccountKey=convertto-securestring $StorageAccountKey -asplaintext -force
                        $srvPath="sqlserver:\sql\"+$ServerInstanceName
                        $blocksize=512	
		                import-module sqlps

	    		        $newDataFilePath = "C:\dataroot\data1\"
        		        $newLogFilePath = "c:\dataroot\logs\"
        		
				        # Check if SQL Credential exists
				        if((get-sqlcredential -Name $sqlstoragecred -Path $srvPath -ErrorAction SilentlyContinue))
				        {
            		        Write-Output ("$(get-date) : Restore-AzureParagonNthDBFromBlob: The "+$sqlstoragecred +" credential already exists.")_
        		        }
        		        # Create a SQL credential if it does not exist
        		        if(!(get-sqlcredential -Name $sqlstoragecred -Path $srvPath -ErrorAction SilentlyContinue))
				        { 
		    		        $newsqlcredresults = New-SqlCredential -Name $sqlstoragecred -Path $srvPath -Identity $StorageAccountName -Secret $SecureStorageAccountKey
                            write-output $newsqlcredresults
				        }
		
	
				        #Restore DB
				        if(get-sqldatabase -ServerInstance $ServerInstanceName -Name $DestinationDBName -ErrorAction SilentlyContinue)
				        {
		    		        Write-Output ("$(get-date) : Restore-AzureParagonDB: The database already exists.  Will stop restore")
				        }
		
				        if(!(get-sqldatabase -ServerInstance $ServerInstanceName -Name $DestinationDBName -ErrorAction SilentlyContinue))
				        {
         		    #        $Query="restore filelistonly from disk ='"+$BackUpFullPath+"'"
                            $Query="restore filelistonly from url ='"+$BackUpFullPath +"' With Credential ='"+$sqlstoragecred +"', BLOCKSIZE="+$blocksize         		
         		            #Invoke SQL CMd to run Restore filelistonly and get list of physical file names
         		            #Also need to reroute to data1 and logs directory based on file type (MDF or LDF)         
           			        $FileList=Invoke-Sqlcmd -ServerInstance $ServerInstanceName -Database master -Query $Query 
           			        $res = new-object Microsoft.SqlServer.Management.Smo.Restore
             		        ForEach ($DataRow in $Filelist) 
                		    {
                    		    $LogicalName = $DataRow.LogicalName
                    		    $PhysicalNameLeaf=Split-Path $DataRow.PhysicalName -leaf                    		
                    		    if ($PhysicalNameLeaf -like '*.mdf*')
                        		    {
                        		    $PhysicalNameLeaf2=$PhysicalNameLeaf.Replace('.mdf','')
                        		    $NewPhysicalNameLeaf=$PhysicalNameLeaf2.Replace($SourceDBName,$DestinationDBName)
                        		    $NewPhysicalName = $newDatafilePath+$NewPhysicalNameLeaf+'.mdf'
		
                        		    }
                     		    if ($PhysicalNameLeaf -like '*.ndf*')
                        		    {
                        		    $PhysicalNameLeaf2=$PhysicalNameLeaf.Replace('.ndf','')
                        		    $NewPhysicalNameLeaf=$PhysicalNameLeaf2.Replace($SourceDBName,$DestinationDBName)
                        		    $NewPhysicalName = $newDatafilePath+$NewPhysicalNameLeaf+'.ndf'		
                        		    }
                    		    if ($PhysicalNameLeaf -like '*.ldf*')
                        		    {
                        		    $PhysicalNameLeaf2=$PhysicalNameLeaf.Replace('.ldf','')
                        		    $NewPhysicalNameLeaf=$PhysicalNameLeaf2.Replace($SourceDBName,$DestinationDBName)
                        		    $NewPhysicalName = $newDatafilePath+$NewPhysicalNameLeaf+'.ldf'
                        		    }        
                    		    $RestoreData = New-Object("Microsoft.SqlServer.Management.Smo.RelocateFile")
                    		    $RestoreData.LogicalFileName = $LogicalName
                    		    $RestoreData.PhysicalFileName = $NewPhysicalName
                    		    $tmpvar1 = $res.RelocateFiles.Add($RestoreData)
                		    }
                		    $RelocateData = $res.RelocateFiles		
		    		        $restoresqldbresult = Restore-SqlDatabase -ServerInstance $ServerInstanceName -Database $DestinationDBName -BackupFile $BackUpFullPath -RelocateFile $RelocateData -SqlCredential $sqlstoragecred -BlockSize 512 -ReplaceDatabase
                        }#End of iF
                    }#End of SetScript              
	            GetScript =  { @{} }
	            TestScript = 
                    { 
                          $dbexists=get-sqldatabase -ServerInstance $ServerInstanceName -Name $DestinationDBName -ErrorAction SilentlyContinue
                          if($dbexists)
                          {
                            $true
                          }
                          else
                          {
                            $false
                          }                        
                    }
                DependsOn = "[xAzureBlobFiles]DownloadDBAndVardata"
        } #End of SQLrestoreDB Script

    }#End of Node
}#End of config
 
<#
$cd = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            PSDscAllowPlainTextPassword = $true
            PSDSCAllowDomainUser=$True
            RebootNodeIfNeeded = $true
            $

        }
    )
}
$creds=get-credential -UserName localadmin
DBServerConfig -admincreds $creds -domainname irmchosted.com -configurationdata $cd
Start-DscConfiguration -Force -Path C:\Packages\Plugins\Microsoft.Powershell.DSC\2.19.0.0\DSCWork\DBServerConfig.ps1.0\DBServerConfig -verbose
   $job= (Get-Job -Id 13).ChildJobs.progress

#>

    