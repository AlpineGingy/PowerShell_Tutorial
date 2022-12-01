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
    6.	Last 20 Event Log errors
    7.	Users and groups
    8.	Shares
    9.	Printers
    10.	Network info
    11.	Number of processes running
    "

    $choice = Read-Host "Please enter a choice from above, or enter 'q' to quit"

    switch($choice)
    {
        1 { Get-PCHardware; Break}
        2 { Get-InstalledSoftware; Break}
        3 { Get-AVStatus; Break}
        4 { Get-FirewallStatus; Break}
        5 { Get-Resources; Break}
        6 {"Method";Break}
        7 {"Method";Break}
        8 {"Method";Break}
        9 {"Method";Break}
        10 {"Method";Break}
        11 {"Method";Break}
        'q' {"Goodbye"; Break}
        Default {
            Write-Host "Invalid response" -f Red
        }
    }

    Start-Sleep -Seconds 1.5

} while (
    $choice -ne 'q'
)

function Get-PCHardware () {
    systeminfo
}

function Get-InstalledSoftware () {
    Get-WmiObject -class Win32_Product
}

function Get-AVStatus () {
    Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct
    ""
    Get-MpComputerStatus
}

function Get-FirewallStatus () {
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
      Write-host "Resources on" $computername "- RAM Usage:"$RoundMemory"%, CPU:"$cpu"%, Free" $free "GB"
      }
