$denyLogonGroupSid = 'S-1-5-21-606772152-2796217479-3214608351-8177'
Set-Content -Path "C:\test.inf" -Value "
[Unicode]
Unicode=yes
[Version]
signature=`"`$CHICAGO`$`"
Revision=1
[Privilege Rights]
SeDenyInteractiveLogonRight = *$denyLogonGroupSid
SeDenyRemoteInteractiveLogonRight = *$denyLogonGroupSid
SeDenyBatchLogonRight = *$denyLogonGroupSid
"