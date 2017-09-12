param (
        [string]$MachineName,
        [string]$AdminUserName,
        [string]$AdminPassword,
        [string]$Source,
        [string]$Destination      
        )

Write-Output "Machine Name - $MachineName"
Write-Output "Admin User Name - $AdminUserName"
Write-Output "Source Location - $Source"
Write-Output "Backup Location - $Destination"

$pass = ConvertTo-SecureString -AsPlainText $AdminPassword -Force

$credential = new-object -typename System.Management.Automation.PSCredential -argumentlist $AdminUserName,$pass

Invoke-Command -ComputerName $MachineName -credential $credential  -ScriptBlock {

Param (
[Parameter(Mandatory=$True)]
[ValidateNotNull()]
$Source,
[Parameter(Mandatory=$True)]
[ValidateNotNull()]
$Destination)

$UserSplit = $Users -split ";"
$FolderSplit = $Path -split ";"

 #Check Source exists or not
    Write-Output "Source Folder=$Source";
    If(Test-Path $Source) {
        Write-Output "Source folder exists."; 
        }
        else{
            Write-Output "Source folder does not exist.";
            Write-Output "ACTION FAILED, SOURCE FOLDER DOES NOT EXIST !!!";
            exit 1
        }
                    
    #Start Robocopy operation
    Write-Output "Starting Robocopy";
    Robocopy $Source $Destination /E 
    Write-Output "Robocopy completed.";
    } -ArgumentList ($Source, $Destination)