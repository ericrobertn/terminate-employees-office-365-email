# terminate-employees-office-365-email
#This Powershell script will change a users office 365 password, disable owa and active sync, forward their emails, and hide them from the GAL


Import-Module 'Microsoft.PowerShell.Security'

#Accesses AES.key to un-encrypt password.txt and create a credential variable to log into office 365
$User = "s1lending_it@s1lending.com"
$PasswordFile = "C:\Users\eric\Desktop\Terminate Employee\Password.txt"
$KeyFile = "C:\Users\eric\Desktop\Terminate Employee\AES.key"
$key = Get-Content $KeyFile
$credential = New-Object -TypeName System.Management.Automation.PSCredential `
 -ArgumentList $User, (Get-Content $PasswordFile | ConvertTo-SecureString -Key $key)


#Creates an Exchange Online session
$ExchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $credential -Authentication Basic -AllowRedirection 

#Import session commands
Import-PSSession $ExchangeSession 
Connect-MsolService -Credential $credential

#Asks for users email and manager to forward emails to
$Terminate = Read-Host -Prompt 'Input terminated users email'
$Forwarding = Read-Host -Prompt 'Input email to be forwarded too'

#changes password
Set-MsolUserPassword –UserPrincipalName $Terminate –NewPassword "Termination1!$" –ForceChangePassword $False


#sets forwarding address and hides from GAL (this is seperate from the litigation hold as the litigation hold command can fail if user doesn't have proper licesnse)
Set-Mailbox  $Terminate  -ForwardingAddress $Forwarding -HiddenFromAddressListsEnabled $false


#disable activesync and owa for devices
Set-CASMailbox -Identity $Terminate -ActiveSyncEnabled $False
Set-CASMailbox -Identity $Terminate -OWAforDevicesEnabled $False

#puts on litigation hold so users can't delete emails
Set-Mailbox –Identity $Terminate –LitigationHoldEnabled $True –RetentionComment Retention  # ("Employee Terminated on " + (Get-Date) + " by " [System.Security.Principal.WindowsIdentity]::GetCurrent().Name))


#Closes remote session
Remove-pssession $ExchangeSession 

Pause
