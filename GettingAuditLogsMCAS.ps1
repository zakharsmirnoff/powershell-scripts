#via the module for Cloud App Security we can get the list of all the acitivies for the applications

$activities = @(Get-MCASActivity -AppName Microsoft_Skype_For_Business -ResultSetSize 50)

foreach ($x in $activities) {
if ($x.description -eq "Set-CsTeamsMeetingPolicy" -or "Set-CsTeamsMessagingPolicy") {
Write-Host $x.rawDataJson}}

#you can specify the activities for Teams admin center:

$activities = @(Get-MCASActivity -AppName Microsoft_Teams -ResultSetSize 50)

foreach ($x in $activities) {
if ($x.description -eq "TeamsAdminChange") {
Write-Host $x.rawDataJson}}