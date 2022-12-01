Write-Host "Hello, this script is used to find data and information about the current computer." -f Green

do {
    $choice = 0

    "
    Welcome to ComputerInfo! Enter one of the choices below to get more info (Enter q to quit):
    1.	PC hardware
    2.	Software installed
    3.	AV status
    4.	Firewall status
    5.	Current CPU/RAM/Disk usage
    6.	View Event Log
    7.	Users and groups
    8.	Printers
    9.	Network info
    10.	Processes running
    "

    $choice = Read-Host "Please enter a choice from above, or enter 'q' to quit"

    switch($choice)
    {
        1 { Get-PCHardware; Break}
        2 { Get-InstalledSoftware; Break}
        3 { Get-AVStatus; Break}
        4 { Get-FirewallStatus; Break}
        5 { Get-Resources; Break}
        6 {Get-EventLogs; Break}
        7 { Get-Users; Break}
        8 { Get-Printers; Break}
        9 { Get-NetworkInfo; Break}
        10 { Get-Processes; Break}
        'q' {"Goodbye"; Break}
        Default {
            Write-Host "Invalid response" -f Red
        }
    }

    Start-Sleep -Seconds 1.5

} while (
    $choice -ne 'q'
)

function Get-PCHardware {
    systeminfo
}

function Get-InstalledSoftware {
    #Get-WmiObject -Class Win32_Product | where vendor -eq CodeTwo | select Name, Version
    $InstalledSoftware = Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
    foreach($obj in $InstalledSoftware){write-host $obj.GetValue('DisplayName') -NoNewline; write-host " - " -NoNewline; write-host $obj.GetValue('DisplayVersion')}
}

function Get-AVStatus {
    Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct
    # ""
    # Get-MpComputerStatus
}

function Get-FirewallStatus {
    Get-NetFirewallProfile
}

function Get-Resources{  
    param(  
    $computername =$env:computername 
    )  
    # Processor utilization 
    $LoadPercent=Get-WmiObject Win32_Processor | Select LoadPercentage
    $cpu = $LoadPercent.LoadPercentage
    # Memory utilization 
    $ComputerMemory = Get-WmiObject -ComputerName $computername  -Class win32_operatingsystem -ErrorAction Stop 
    $Memory = ((($ComputerMemory.TotalVisibleMemorySize - $ComputerMemory.FreePhysicalMemory)*100)/ $ComputerMemory.TotalVisibleMemorySize) 
    $RoundMemory = [math]::Round($Memory, 2) 
    # Free disk space 
    $disks = get-wmiobject -class "Win32_LogicalDisk" -namespace "root\CIMV2" -computername $computername
    $results = foreach ($disk in $disks)  
    { 
    if ($disk.Size -gt 0) 
    { 
      $size = [math]::round($disk.Size/1GB, 0) 
      $free = [math]::round($disk.FreeSpace/1GB, 0) 
      [PSCustomObject]@{ 
      Drive = $disk.Name 
      Name = $disk.VolumeName 
      "Total Disk Size" = $size
      "Free Disk Size" = "{0:N0} ({1:P0})" -f $free, ($free/$size) 
      } } }     

      # Write results 
      Write-host "Resources on" $computername "- RAM Usage:"$RoundMemory"%, CPU:"$cpu"%, Free" $free "GB" -f Blue
      }

function Get-EventLogs {
    # Get-Eventlog -Logname System -Newest 5 | fl

    Get-EventLog -LogName System -Newest 10 -EntryType Error,Warning | Select Index,EntryType,Message,TimeGenerated | ft
}

function Get-Users {
    ""
    Write-host "Local Users: "-f Magenta
    get-localuser | ft
    Write-host "Local Groups: " -f Magenta
    get-localgroup | ft
}

function Get-Printers {
    Get-Printer | Select Name,Type,DriverName,PortName | ft
}

function Get-NetworkInfo {
    Get-NetAdapter | ft
}

function Get-Processes {
    "
    1. Number of processes running
    2. List of processes running
    "
    $input = Read-Host "Please choose an option: "

    if ($input -eq 1) {ps | Measure | Select Count}
    else {ps}
    }
