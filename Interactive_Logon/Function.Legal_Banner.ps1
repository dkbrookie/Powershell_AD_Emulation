Function Set-LogonLegalNotice {
    <#
    .DESCRIPTION
    Description here

    .PARAMETER BannerTitle
    Banner message title

    .PARAMETER BannerMessage
    Banner message help
    #>

    [CmdletBinding()]

    Param (
        [Parameter (
            Mandatory   = $true,
            HelpMessage = 'Banner title help'
        )]
        [string]$BannerTitle

        ,[Parameter (
            Mandatory   = $true,
            HelpMessage = 'Banner message help'
        )]
        [string]$BannerMessage
    )


    $output = @()


    Try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "legalnoticecaption" -Value $BannerTitle
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "legalnoticetext" -Value $BannerMessage
        $output += "!SUCCESS: Successfully configured the logon legal notice!"
    } Catch {
        $output += "!FAILED: There was a problem when attempting to set the values for the logon legal notice. Full error output: $Error"
    }

    
    $output = $output -join "`n"
    Return $output
}
