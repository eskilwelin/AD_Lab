$au = Get-MgDirectoryAdministrativeUnit -Filter "DisplayName eq 'AU-Consulting'"
$userid = Get-MgUser -Filter "Department eq 'Consulting'"

foreach ($user in $userid) {
		$odataid = "https://graph.microsoft.com/v1.0/users/$($user.Id)"
		New-MgDirectoryAdministrativeUnitMemberByRef -AdministrativeUnitId $au.Id -OdataId $odataid
}