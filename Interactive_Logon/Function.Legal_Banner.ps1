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

    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "legalnoticecaption" -Value $BannerTitle
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "legalnoticetext" -Value $BannerMessage
}
