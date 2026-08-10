# Lägg till användare i grupper

Poc:

```powershell
$Department = "HR"

Get-MgUser -Filter "Department eq '$Department'" -Select DisplayName,Id |
ForEach-Object { Write-Host $_.Id }

$Group = Get-MgGroup -All | Where-Object DisplayName -like "*$Department*"
```

Alla tillgängliga properties för `MgUser`

```powershell
Get-MgUser -All |
ForEach-Object { $_.PSObject.Properties } |
Select-Object -Property MemberType, Name, TypeNameOfValue |
Sort-Object -Property Name -Unique
```

- Department filter

```powershell
$Department = "HR"
$GroupId = (Get-MgGroup -Filter "DisplayName eq 'GRP_${Department}_Users'").Id

Get-MgUser -Filter "Department eq '$Department'" -Select Id |
ForEach-Object { New-MgGroupMember -GroupId $GroupId -DirectoryObjectId $_.Id }
```

Fungerar för Consulting, Finance, HR, inte för IT och Ceo etc 

- Helpdesk

```powershell
$Title = "Helpdesk"
$GroupId = (Get-MgGroup -Filter "DisplayName eq 'GRP_IT_Helpdesk'").Id

Get-MgUser -Filter "JobTitle eq '$Title'" -Select Id |
ForEach-Object { New-MgGroupMember -GroupId $GroupId -DirectoryObjectId $_.Id }
```

- ServiceAcc

```powershell
$GroupId = (Get-MgGroup -Filter "DisplayName eq 'GRP_ServiceAccounts'").Id

Get-MgUser -Filter "startswith(DisplayName, 'svc_')" -Select Id |
ForEach-Object { New-MgGroupMember -GroupId $GroupId -DirectoryObjectId $_.Id }
```

- VPN_Users

```powershell
$GroupId = (Get-MgGroup -Filter "DisplayName eq 'GRP_VPN_Users'").Id

Get-MgUser -Filter "Department eq 'Management' or Department eq 'IT'" |
Where-Object DisplayName -NotLike "svc_*" |
ForEach-Object { New-MgGroupMember -GroupId $GroupId -DirectoryObjectId $_.Id }
```

- Uppdatera AnvändarId från CSV

```powershell
$users = Import-Csv -Path "C:\Users\eskil.welin\Desktop\Labb\Data\users_names_ids.csv"
foreach ($user in $users) {
		$userid = (Get-MgUser -Filter "DisplayName eq '$($user.Name)'").Id
    Update-MgUser -UserId $userid -EmployeeId $user.EmployeeID
}
```