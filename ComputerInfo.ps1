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

} while (
    $choice -ne 'q'
)


