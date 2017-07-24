###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Connect-SharePointOnline.ps1
# Autor        :  iSnackyCracky (https://isnackycracky.de/ -- https://github.com/isnackycracky/)
# Description  :  Connect to the SharePointOnline PowerShell
# Repository   :  https://github.com/isnackycracky/SnackyTools
###############################################################################################################

<#
  .SYNOPSIS
  Connect to the SharePointOnline PowerShell

  .DESCRIPTION
  Connect to the SharePointOnline PowerShell

  .EXAMPLE
  Connect-SharePointOnline -Url "https://contoso.sharepoint.com"
#>

function Connect-SharePointOnline
{
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=$true,HelpMessage="SharePoint-URL")]
    [String]$Url,
    [Parameter(Position=1,Mandatory=$false,HelpMessage="Login-Credentials")]
    [System.Management.Automation.CredentialAttribute()]$Credential
  )

  Begin{

  }

  Process{
    # Get login-credentials, if none were provided as parameter
    If (!$Credential) {
      $Credential = Get-Credential
    }

    # Import the SharePointOnline Module
    Import-Module "C:\Program Files\SharePoint Online Management Shell\Microsoft.Online.SharePoint.PowerShell\Microsoft.Online.SharePoint.PowerShell.psd1" -Global

    # Connect the MSOnline Service
    Connect-SPOService -Url $Url -Credential $Credential
  }

  End{

  }
}
