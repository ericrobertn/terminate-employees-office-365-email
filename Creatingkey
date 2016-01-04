#Taken From Adminarsenal Website. Secure Password with PowerShell: Encrypting Credentials – Part 2
#http://www.adminarsenal.com/admin-arsenal-blog/secure-password-with-powershell-encrypting-credentials-part-2/

##Step One: Creating AES key with random data and export to file
$KeyFile = "\\Machine1\SharedPath\AES.key"
$Key = New-Object Byte[] 16   # You can use 16, 24, or 32 for AES
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
$Key | out-file $KeyFile
###############################

##Step Two: Creating SecureString object
$PasswordFile = "\\Machine1\SharedPath\Password.txt"
$KeyFile = "\\Machine1\SharedPath\AES.key"
$Key = Get-Content $KeyFile
$Password = "P@ssword1" | ConvertTo-SecureString -AsPlainText -Force
$Password | ConvertFrom-SecureString -key $Key | Out-File $PasswordFile
################################

#Step Three: Creating PSCredential object
$User = "MyUserName"
$PasswordFile = "\\Machine1\SharedPath\Password.txt"
$KeyFile = "\\Machine1\SharedPath\AES.key"
$key = Get-Content $KeyFile
$MyCredential = New-Object -TypeName System.Management.Automation.PSCredential `
 -ArgumentList $User, (Get-Content $PasswordFile | ConvertTo-SecureString -Key $key)
