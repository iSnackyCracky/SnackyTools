###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Connect-Office365.ps1
# Autor        :  iSnackyCracky (https://isnackycracky.de/ -- https://github.com/isnackycracky/)
# Description  :  Connect to the Office 365 and Exchange Online powershell
# Repository   :  https://github.com/isnackycracky/SnackyTools
###############################################################################################################

<#
.SYNOPSIS
Connect to Office 365 and Exchange Online powershell

.DESCRIPTION
Connect to Office 365 and Exchange Online powershell

.EXAMPLE
Connect-Office365
#>

function Connect-Office365 {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "Login-Credentials")]
        [System.Management.Automation.CredentialAttribute()][SecureString]$Credential
    )

    Begin {

    }

    Process {
        # Get login-credentials, if none were provided as parameter
        If (!$Credential) {
            $Credential = Get-Credential
        }

        # Import the MSOnline Module
        Import-Module MSOnline

        # Create the Exchange Online session
        $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $Credential -Authentication Basic –AllowRedirection

        # Connect the MSOnline Service
        Connect-MsolService -Credential $Credential

        # Import the created Exchange Online session
        Import-Module(Import-PSSession $Session -AllowClobber -DisableNameChecking) -Global -DisableNameChecking
    }

    End {

    }
}
