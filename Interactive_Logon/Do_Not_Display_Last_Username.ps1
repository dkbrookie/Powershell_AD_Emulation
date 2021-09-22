$output = @()
$regPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'

Try {
    If ((Get-ItemProperty -Path $regPath -Name dontdisplaylastusername) -ne 1) {
        $output += "[dontdisplaylastusername] at $regPath was not set to 1, setting to 1 now..."
        Set-ItemProperty -Path $regPath -Name dontdisplaylastusername -Value 1
        $output += "Successfully set [dontdisplaylastusername] at $regPath to 1!"
    } Else {
        $output += "Verified [dontdisplaylastusername] at $regPath is already set to 1!"
    }
    Return $output
} Catch {
    $output += "There was a problem when attempting to set [dontdisplaylastusername] at $regPath to the value of 1. Full error output: $Error"
    Return $output
    Break
}