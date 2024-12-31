#
# Create a local Docker container development environment
#

# Default Credentials
$secpasswd = ConvertTo-SecureString "password" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ("admin", $secpasswd)

# Create Container
$containerName = 'pegboard'
.\.AL-Go\localDevEnv.ps1 -containerName $containerName -auth UserPassword -credential $credential -accept_insiderEula -licenseFileUrl "none"

# Install any dependencies for local development
