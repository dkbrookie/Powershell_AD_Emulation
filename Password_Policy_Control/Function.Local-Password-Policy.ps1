Function Local-Password-Policy {
    <#
    .DESCRIPTION
    This function will allow you to control the password policies on a local machine for local user accounts.

    .PARAMETER ForceLogoffTimer
    Set the number of minutes a user has before being forced to log off when the account expires or valid logon hours expire
    Policy: Force user logoff how long after time expires?
    Command: net accounts /forcelogoff:[number] or No

    .PARAMETER MinPasswordChange
    Set a minimum number of days that must pass before a user can change a password (default = 0)
    Policy: Minimum password age (days): 
    Command: net accounts /minpwage:[number]

    .PARAMETER MaxPasswordAge
    Set the maximum number of days that a password is valid
    Policy: Maximum password age (days): 
    Command: net accounts /maxpwage:[number]

    .PARAMETER MinPasswordLength
    Set the minimum number of characters for a password
    Policy: Minimum password length: 
    Command: net accounts /minpwlen:[number]

    .PARAMETER UniquePasswordHistory
    Require that new passwords be different from 'x' number of previous passwords
    Polocy: Length of password history maintained:
    Command: net accounts /uniquepw:[number]

    .PARAMETER FailedSignInAttemptLockout
    Determines the number of failed sign-in attempts that will cause a local account to be locked
    Policy: Lockout threshold:
    Command: net accounts /lockoutthreshold: [number]

    .PARAMETER TotalLockoutTimeAfterFails
    Determines the number of minutes that a locked-out local account remains locked out before automatically becoming unlocked
    Policy: Lockout duration (minutes):
    Command: net accounts /lockoutduration:[number]

    .PARAMETER LockoutObservationWindow
    Determines the number of minutes that must elapse from the time a user fails to log on before the failed logon attempt counter 
    is reset to 0. If Account lockout threshold is set to a number greater than zero, this reset time must be less than or equal to 
    the value of Account lockout duration.
    Policy: Lockout observation window (minutes):
    Command: net accounts /lockoutwindow:[number]

    .PARAMETER DisableNoExpiration
    Set this value to Y or N. This is N by default. VERY IMPORTANT to note that if this is set to N but you have specified a lockout
    policy, all accounts set to Never Expire will NOT honor yuor password policy! In general, if you are setting password policies,
    set this to Y.
    #>

    [CmdletBinding()]

    Param (
        [Parameter (
            HelpMessage='Set the number of minutes a user has before being forced to log off when the account expires or valid logon hours expire. This value must be between 0 - 999, or No.'
        )]
        [string]$ForceLogoffTimer = 'NO'

        ,[Parameter (
            HelpMessage='Set a minimum number of days that must pass before a user can change a password. This value must be between 0 - 999.'
        )]
        [int]$MinPasswordChange = 0

        ,[Parameter (
            HelpMessage='Set the maximum number of days that a password is valid. This value must be between 0 - 999.'
        )]
        [int]$MaxPasswordAge = 30

        ,[Parameter (
            HelpMessage='Set the minimum number of characters for a password. This value must be between 0 - 999.'
        )]
        [int]$MinPasswordLength = 10

        ,[Parameter (
            HelpMessage='Require that new passwords be different from ''x'' number of previous passwords. This value must be between 0 - 999.'
        )]
        [int]$UniquePasswordHistory = 24

        ,[Parameter (
            HelpMessage='Determines the number of failed sign-in attempts that will cause a local account to be locked. This value must be between 0 - 999.'
        )]
        [int]$FailedSignInAttemptLockout = 10

        ,[Parameter (
            HelpMessage='Determines the number of minutes that a locked-out local account remains locked out before automatically becoming unlocked. This value must be between 0 - 999.'
        )]
        [int]$TotalLockoutTimeAfterFails = 15

        ,[Parameter (
            HelpMessage='Determines the number of minutes that must elapse from the time a user fails to log on before the failed logon attempt counter is reset to 0. This value must be between 0 - 999.'
        )]
        [int]$LockoutObservationWindow = 15

        ,[Parameter (
            HelpMessage='Force disable Password Never Expires on all local user accounts. By default, this is N.'
        )]
        [ValidateSet('Y','N')]
        [string]$DisableNoExpiration = 'N'
    )

    ## Get the current values set for local password policy
    If ($ForceLogoffTimer -eq 'NO') {
        $ForceLogoffTimer = 'Never'
    }
    $pattern = 'Force user logoff how long after time expires\?:\s*(.*)'
    $currentForceLogoffTimer = ((net accounts) | Select-String -Pattern $pattern).Matches.Groups[1].Value
    $pattern = 'Minimum password age \(days\):\s*(.*)'
    $currentMinPasswordChange = ((net accounts) | Select-String -Pattern $pattern).Matches.Groups[1].Value
    $pattern = 'Maximum password age \(days\):\s*(.*)'
    $currentMaxPasswordAge = ((net accounts) | Select-String -Pattern $pattern).Matches.Groups[1].Value
    $pattern = 'Minimum password length:\s*(.*)'
    $currentMinPasswordLength = ((net accounts) | Select-String -Pattern $pattern).Matches.Groups[1].Value
    $pattern = 'Length of password history maintained:\s*(.*)'
    $currentUniquePasswordHistory = ((net accounts) | Select-String -Pattern $pattern).Matches.Groups[1].Value
    $pattern = 'Lockout threshold:\s*(.*)'
    $currentFailedSignInAttemptLockout = ((net accounts) | Select-String -Pattern $pattern).Matches.Groups[1].Value
    $pattern = 'Lockout duration \(minutes\):\s*(.*)'
    $currentTotalLockoutTimeAfterFails = ((net accounts) | Select-String -Pattern $pattern).Matches.Groups[1].Value
    $pattern = 'Lockout observation window \(minutes\):\s*(.*)'
    $currentLockoutObservationWindow = ((net accounts) | Select-String -Pattern $pattern).Matches.Groups[1].Value


    ## Check values defined when the function was called vs the current settings on the local machine and if different, fix it
    If ($currentForceLogoffTimer -ne $ForceLogoffTimer -or $currentMinPasswordChange -ne $MinPasswordChange -or $currentMaxPasswordAge -ne $MaxPasswordAge -or $currentMinPasswordLength -ne $MinPasswordLength -or $currentUniquePasswordHistory -ne $UniquePasswordHistory -or $currentFailedSignInAttemptLockout -ne $FailedSignInAttemptLockout -or $currentTotalLockoutTimeAfterFails -ne $TotalLockoutTimeAfterFails -or $currentLockoutObservationWindow -ne $LockoutObservationWindow) {
        ## Set all policy values to the values set when the function was called
        If ($ForceLogoffTimer -eq 'Never') {
            $ForceLogoffTimer = 'NO'
        }
        &cmd.exe /c "net accounts /forcelogoff:$ForceLogoffTimer" | Out-Null
        &cmd.exe /c "net accounts /minpwage:$MinPasswordChange" | Out-Null
        &cmd.exe /c "net accounts /maxpwage:$MaxPasswordAge" | Out-Null
        &cmd.exe /c "net accounts /minpwlen:$MinPasswordLength" | Out-Null
        &cmd.exe /c "net accounts /uniquepw:$UniquePasswordHistory" | Out-Null
        &cmd.exe /c "net accounts /lockoutthreshold:$FailedSignInAttemptLockout" | Out-Null
        &cmd.exe /c "net accounts /lockoutduration:$TotalLockoutTimeAfterFails" | Out-Null
        &cmd.exe /c "net accounts /lockoutwindow:$LockoutObservationWindow" | Out-Null
        
        ## Get the values again for local password policy so we can check and make sure the changes were successful
        If ($ForceLogoffTimer -eq 'NO') {
            $ForceLogoffTimer = 'Never'
        }
        $pattern = 'Force user logoff how long after time expires\?:\s*(.*)'
        $currentForceLogoffTimer = ((net accounts) | Select-String -Pattern $pattern).Matches.Groups[1].Value
        $pattern = 'Minimum password age \(days\):\s*(.*)'
        $currentMinPasswordChange = ((net accounts) | Select-String -Pattern $pattern).Matches.Groups[1].Value
        $pattern = 'Maximum password age \(days\):\s*(.*)'
        $currentMaxPasswordAge = ((net accounts) | Select-String -Pattern $pattern).Matches.Groups[1].Value
        $pattern = 'Minimum password length:\s*(.*)'
        $currentMinPasswordLength = ((net accounts) | Select-String -Pattern $pattern).Matches.Groups[1].Value
        $pattern = 'Length of password history maintained:\s*(.*)'
        $currentUniquePasswordHistory = ((net accounts) | Select-String -Pattern $pattern).Matches.Groups[1].Value
        $pattern = 'Lockout threshold:\s*(.*)'
        $currentFailedSignInAttemptLockout = ((net accounts) | Select-String -Pattern $pattern).Matches.Groups[1].Value
        $pattern = 'Lockout duration \(minutes\):\s*(.*)'
        $currentTotalLockoutTimeAfterFails = ((net accounts) | Select-String -Pattern $pattern).Matches.Groups[1].Value
        $pattern = 'Lockout observation window \(minutes\):\s*(.*)'
        $currentLockoutObservationWindow = ((net accounts) | Select-String -Pattern $pattern).Matches.Groups[1].Value

        ## If any of the settings aren't what we just tried to set them to, set $statust to Failed and output the results of what failed to $logOutput
        If ($currentForceLogoffTimer -ne $ForceLogoffTimer -or $currentMinPasswordChange -ne $MinPasswordChange -or $currentMaxPasswordAge -ne $MaxPasswordAge -or $currentMinPasswordLength -ne $MinPasswordLength -or $currentUniquePasswordHistory -ne $UniquePasswordHistory -or $currentFailedSignInAttemptLockout -ne $FailedSignInAttemptLockout -or $currentTotalLockoutTimeAfterFails -ne $TotalLockoutTimeAfterFails -or $currentLockoutObservationWindow -ne $LockoutObservationWindow) {
            $global:status = 'Failed'
            $global:logOutput += "Current: $currentForceLogoffTimer Attempted Change: $ForceLogoffTimer`r`n"
            $global:logOutput += "Current: $currentMinPasswordChange Attempted Change: $MinPasswordChange`r`n"
            $global:logOutput += "Current: $currentMaxPasswordAge Attempted Change: $MaxPasswordAge`r`n"
            $global:logOutput += "Current: $currentMinPasswordLength Attempted Change: $MinPasswordLength`r`n"
            $global:logOutput += "Current: $currentUniquePasswordHistory Attempted Change: $UniquePasswordHistory`r`n"
            $global:logOutput += "Current: $currentFailedSignInAttemptLockout Attempted Change: $FailedSignInAttemptLockout`r`n"
            $global:logOutput += "Current: $currentTotalLockoutTimeAfterFails Attempted Change: $TotalLockoutTimeAfterFails`r`n"
            $global:logOutput += "Current: $currentLockoutObservationWindow Attempted Change: $LockoutObservationWindow"
        }
    } Else {
        $global:status = 'Success'
    }
    $global:status
}