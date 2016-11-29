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
		        $partitiondatapathresult = Get-Partition -DriveLetter F |Add-PartitionAccessPath -PartitionNumber 2 -AccessPath $DataPath
                write-output $partitiondatapathresult

		        $partitionlogpathresult = Get-Partition -DriveLetter G |Add-PartitionAccessPath -PartitionNumber 2 -AccessPath $LogPath
                write-output $partitionlogpathresult

		        $partitionsystpathresult = Get-Partition -DriveLetter H |Add-PartitionAccessPath -PartitionNumber 2 -AccessPath $SystemDBPath
                write-output $partitionsystpathresult

		        Write-Output ("$(get-date) : Set-AzureParagonNthDBStorageConfiguration: Partitions mounted to mount point directories.")		
