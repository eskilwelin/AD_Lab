[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory=$true)][string]$OldSuffix,
    [Parameter(Mandatory=$true)][string]$NewSuffix
)
Import-Module ActiveDirectory

function Get-Users{
    param(
        [Parameter(Mandatory=$true)][string]$OldSuffix,
        [Parameter(Mandatory=$true)][string]$NewSuffix
    )
    Get-ADUser -Filter "UserPrincipalName -like '*@$OldSuffix'" -Properties UserPrincipalName |
        Where-Object UserPrincipalName -NotLike "*@$NewSuffix"
}

$Users = (Get-Users -OldSuffix $OldSuffix -NewSuffix $NewSuffix)

foreach ($User in $Users){
    $NewUPN = $User.UserPrincipalName.Replace($OldSuffix,$NewSuffix)
    if ($PSCmdlet.ShouldProcess($User.UserPrincipalName, "Updating UPN to $NewUPN")) {
        $User | Set-ADUser -UserPrincipalName $NewUPN
    }
}