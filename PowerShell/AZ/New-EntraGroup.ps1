$params = @{
		DisplayName = "GRP_Finance_Users"
		Description = "Finance department staff"
		MailNickname = "Finance"
		MailEnabled = $false
		GroupTypes = @("DynamicMembership")
		MembershipRule = '(user.department -eq "Finance")'
		MembershipRuleProcessingState = "On"
		SecurityEnabled = $true
}

New-MgGroup -BodyParameter $params