$ReferenceObject = Get-CsTeamsMeetingPolicy -Identity Tag:AllOn #or you can import from CSV and change the required policy
$DifferenceObject = Get-CsTeamsMeetingPolicy -Identity Global

function SendTo-Teams {$JSONBody = [PSCustomObject][Ordered]@{
"@type" = "MessageCard"
"@context" = "http://schema.org/extensions"
"summary" = "Here is the list of all the properties that were changed"
"themeColor" = '0078D7'
"title" = "Properties"
"text" = $ChangedPrtopertiesToString
}

$TeamsMessageBody = ConvertTo-Json $JSONBody -Depth 30

$parameters = @{
"URI" = 'https://m365x770187.webhook.office.com/webhookb2/07188cea-abd7-4023-a0ec-c35265f664e8@a30446d5-8b09-4fcc-92e8-8a73ae50e8e7/IncomingWebhook/1d9ad3f1f28f423183ce5cf29016d511/58ab20bb-24e1-4902-afec-e02eac84dbd9'
"Method" = 'POST'
"Body" = $TeamsMessageBody
"ContentType" = 'application/json'
}
Invoke-RestMethod @parameters}

#getting the properties

$properties = @(Get-CsTeamsMeetingPolicy -Identity Global | Get-Member -MemberType Property | Select-Object -ExpandProperty Name)
$ChangedProperties = @()

foreach ($property in $properties) {
Compare-Object $ReferenceObject $DifferenceObject -Property "$property" | Where-Object {$_.SideIndicator -eq "=>"} | ForEach-Object {
$ChangedProperties += $property} 
}

$ChangedPrtopertiesToString = $ChangedProperties -join ","

if ($newarray.Length -gt 0) {
SendToTeams} else {Write-Host "No changes"}