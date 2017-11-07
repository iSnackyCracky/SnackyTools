###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Connect-ExchangeOnline.ps1
# Autor        :  iSnackyCracky (https://isnackycracky.de/ -- https://github.com/isnackycracky/)
# Description  :  Connect to the Exchange Online powershell
# Repository   :  https://github.com/isnackycracky/SnackyTools
###############################################################################################################

<#
.SYNOPSIS
Connect to the Exchange Online powershell

.DESCRIPTION
Connect to the Exchange Online powershell

.EXAMPLE
Connect-ExchangeOnline
#>

function Connect-ExchangeOnline {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "Login-Credentials")]
        [ValidateNotNull()]
        [System.Management.Automation.Credential()]
        [System.Management.Automation.PSCredential]$Credential

    )

    Begin {

    }

    Process {
        # Get login-credentials, if none were provided as parameter
        If (!$Credential) {
            $Credential = Get-Credential
        }

        # Create the Exchange Online session
        $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $Credential -Authentication Basic –AllowRedirection

        # Import the created Exchange Online session
        Import-Module(Import-PSSession $Session -AllowClobber -DisableNameChecking) -Global -DisableNameChecking
    }

    End {

    }
}
