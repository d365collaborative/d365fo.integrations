function New-AuthorizationToken() {

    Write-PSFMessage -Message "New-AuthorizationToken, Auth: $Script:Authority ClientId: $Script:ClientId Secret: $Script:ClientSecret URL: $Script:D365FOURL  "

    $authContext = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext ($Script:Authority, $false)
    $clientCred = New-Object  Microsoft.IdentityModel.Clients.ActiveDirectory.ClientCredential($Script:ClientId, $Script:ClientSecret)

    $task = $authContext.AcquireTokenAsync($Script:D365FOURL, $clientCred)

    $taskStatus = $task.Wait(1000)

    Write-PSFMessage -Message "AuthToken request status $taskStatus" -Level Verbose

    if ($task.IsFaulted -eq $true) {
        Write-PSFMessage -Level Critical -Exception $task.Exception -Message "Unable to receive Access token from Authority $Authority"
        Stop-PSFFunction -StepsUpward 1 -Message "Stopping"
        return
    }
    $authorizationHeader = $task.Result
    $authToken = $authorizationHeader.CreateAuthorizationHeader()

    Write-PSFMessage -Message "New-AuthorizationToken $authToken" -Level VeryVerbose -Tag "Webrequest.TOKEN"
    $authToken
}