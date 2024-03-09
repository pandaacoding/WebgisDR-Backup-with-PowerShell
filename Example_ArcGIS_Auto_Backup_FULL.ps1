# Created log file
$LogFile = "log-location-file-path-here$env:COMPUTERNAME.log"
# Start logging
Start-Transcript -Path $LogFile -Append
# Get Computer Name
$ServerName = $env:COMPUTERNAME.ToLower()
Write-Host "Current script is running on "$ServerName
# Production -> C:\Program Files\ArcGIS\Portal\tools\webgisdr
# Development -> Dev path

Write-Host "Getting webgisdr folder location...."
# Set webgisdr folder location
$WebgisdrFolder = "C:\Program Files\ArcGIS\Portal\tools\webgisdr"
$Webgisdrfile = "\webgisdr.properties"
$FullWebgisdrfilepath = $WebgisdrFolder + $Webgisdrfile
$Originalwebdr = $WebgisdrFolder + "\ORIGINALwebgisdr.properties"

Write-Host "Setting Portal Admin Parameters...."
# Set Parameters for backup
$PortalAdminURL = "PORTAL_ADMIN_URL = YOUR PORTAL URL HERE"
$PortalUsername = "PORTAL_ADMIN_USERNAME = YOUR PORTAL ADMIN USERNAME HERE"
$PortalPW = "PORTAL_ADMIN_PASSWORD = YOUR PORTAL ADMIN PASSWORD HERE"
$PortalPWEncrypt = "PORTAL_ADMIN_PASSWORD_ENCRYPTED = true"
$Backupmodeshort = "full"
$BackupRestoreMode = "BACKUP_RESTORE_MODE = full"
$TempBackupPath = "SHARED_LOCATION = Put your backup location here (use \\ for each \ in the file path)"

#Backup Store Provider -FileSystem or AmazonS3 or Azureblob (will change to AzureBlob in Production)
#FileSystem Parameter
# $BackupStoreProvider = "BACKUP_STORE_PROVIDER = FileSystem"
# $BackupLocation = "BACKUP_LOCATION = \\\\ad.testing.com\\fileshare\\ps-scripts\\Testing"

# Get Date Variable
Get-Date
$TodayDate = Get-Date -UFormat "%Y%m%d"
$DateBackup = $TodayDate + "-" + $ServerName + "-" + $Backupmodeshort + "-wedgisdr_backup"
Write-Host "Backup Name is" $DateBackup

Write-Host "Setting AzureBlob Parameters...."
#AzureBlob Paramter
$BackupStoreProvider = "BACKUP_STORE_PROVIDER = AzureBlob"
$AZBlobAcctName = "AZURE_BLOB_ACCOUNT_NAME = NAME OF YOUR AZURE BLOB ACCOUNT HERE"
$AZBlobAcctKey = "AZURE_BLOB_ACCOUNT_KEY = AZURE BLOB ACCOUNT KEY HERE"
$AZBlobAcctKeyEncrypt ="AZURE_BLOB_ACCOUNT_KEY_ENCRYPTED = false"
$AZBlobAcctEndpointSuffix = "AZURE_BLOB_ACCOUNT_ENDPOINT_SUFFIX = core.windows.net"
$AZBlobContainerName = "AZURE_BLOB_CONTAINER_NAME = $ServerName"


Write-Host "Replacing Parameters to PROPERTIES File"
# Get content from webgisdr.properties and replace the parameters -- AzureBlob
(Get-Content $Originalwebdr) | foreach-Object {
    $PSItem -replace 'PORTAL_ADMIN_URL =', $PortalAdminURL `
       -replace 'PORTAL_ADMIN_USERNAME =', $PortalUsername `
       -replace 'PORTAL_ADMIN_PASSWORD =', $PortalPW `
       -replace 'PORTAL_ADMIN_PASSWORD_ENCRYPTED =', $PortalPWEncrypt `
       -replace 'BACKUP_RESTORE_MODE =', $BackupRestoreMode `
       -replace 'SHARED_LOCATION =', $TempBackupPath `
       -replace 'BACKUP_STORE_PROVIDER =', $BackupStoreProvider `
       -replace 'AZURE_BLOB_ACCOUNT_NAME =', $AZBlobAcctName `
       -replace 'AZURE_BLOB_ACCOUNT_KEY =', $AZBlobAcctKey `
       -replace 'AZURE_BLOB_ACCOUNT_KEY_ENCRYPTED =', $AZBlobAcctKeyEncrypt `
       -replace 'AZURE_BLOB_ACCOUNT_ENDPOINT_SUFFIX =', $AZBlobAcctEndpointSuffix `
       -replace 'AZURE_BLOB_CONTAINER_NAME =', $AZBlobContainerName `
       -replace 'AZURE_BLOB_BACKUP_NAME =', $AZBlobBackupName `
} | Set-Content $FullWebgisdrfilepath

# command line
#$command = "webgisdr.bat -- export --file webgisdr.properties"


#Running Script in cmd
Write-Host "Running command in cmd..."

$process = Start-Process -FilePath "C:\\Program Files\\ArcGIS\\Portal\\tools\\webgisdr\\webgisdr.bat" -WorkingDirectory "C:\\Program Files\\ArcGIS\\Portal\\tools\\webgisdr" -ArgumentList "--export", "--file webgisdr.properties" -Verb RunAs -PassThru
$process.WaitForExit();

Write-Host "Exit Code is" $process.ExitCode


Stop-Transcript

