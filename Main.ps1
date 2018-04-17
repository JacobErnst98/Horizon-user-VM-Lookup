<#
.SYNOPSIS
  Shows all vm's owned by a user
.DESCRIPTION
  Shows all vm's the user owns, this does NOT mean the user is entitled to the VM only that they have clamed it in a Horizion Pool
.INPUTS
  None
.OUTPUTS
  None
.NOTES

  INFO
    Version:        1.1
    Author:         Jacob Ernst
    Modification Date:  4/17/2018
    Purpose/Change: Sanitise for Git
    Modules:        Vmware* (PowerCLI), HV-Helper Get-Help Main.ps1 -online for a link to this module if not provided

  USEFULL VARS
   $domain holds the domain, the format is not a DC so enter it as plain text like "Example.com" NOT "DC=example,DC=com"
   $user holds the username, again this is not a CN or DC so use "john.doe"


.LINK
https://github.com/vmware/PowerCLI-Example-Scripts/tree/master/Modules/VMware.Hv.Helper

#>

#Connect to the server and prompt for creds with windows auth

#################
#  This user MUST have the Admin or ReadOnlyAdmin role on the viewserver
#################

Connect-HVServer viewserver.example.com

#Get all vms
$vms = Get-HVMachineSummary 

#Strip all garbage data from the object
$vmsSimpl =@()
foreach ($vm in $vms){
    $ourObject = $vm | select-object -property `
    @{Label="Computer";Expression={$_.Base.Name}},
    @{Label="User";Expression={$_.namesdata.userName}}
    $vmsSimpl += $ourObject

}

#set the domain and user
$domain='example.com'
$user='john.doe'

#Display the data in a table
$vmsSimpl | where User -eq "$($domain)\$($user)" | Out-GridView -Title "$($User)'s Vm's"

