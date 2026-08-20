<#
.SYNOPSIS
    Bulk-updates UPN for users. Requires the new UPN to be added to the forest first.
    Get-ADForest | Set-ADForest -UPNSuffixes @{add='nordvik.se'}
.EXAMPLE
    .\Update-UPN.ps1 -NewSuffix "nordvik.se" -OldSuffix "corp.nordvik.se" -WhatIf
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory=$true)][string]$OldSuffix,
    [Parameter(Mandatory=$true)][string]$NewSuffix
)
Import-Module ActiveDirectory

function Update-Accounts{
    param(
        [Parameter(Mandatory=$true)][string]$OldSuffix,
        [Parameter(Mandatory=$true)][string]$NewSuffix
    )
    Get-ADUser -Filter "UserPrincipalName -like '*@$OldSuffix'" -Properties UserPrincipalName |
        Where-Object UserPrincipalName -NotLike "*@$NewSuffix"
}

$Users = Update-Accounts -OldSuffix $OldSuffix -NewSuffix $NewSuffix

foreach ($User in $Users){
    if ($User.UserPrincipalName -notlike "*@$OldSuffix") { continue }
    $NewUPN = $User.UserPrincipalName -replace "@$([regex]::Escape($OldSuffix))$", "@$NewSuffix"
    if ($PSCmdlet.ShouldProcess($User.UserPrincipalName, "Updating UPN to $NewUPN")) {
        $User | Set-ADUser -UserPrincipalName $NewUPN
    }
}