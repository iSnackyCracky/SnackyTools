###############################################################################################################
# Language     :  PowerShell
# Filename     :  Connect-Office365.ps1
# Autor        :  iSnackyCracky (https://isnackycracky.de/ -- https://github.com/isnackycracky/)
# Description  :  Connect to Azure and Office 365 Cloud Powershells
# Repository   :  https://github.com/isnackycracky/SnackyTools
###############################################################################################################

#Requires -Version 5

<#
.SYNOPSIS
    Connect to Office 365 Online Services.
.DESCRIPTION
    Connect to Azure AD and Exchange Online by default.
    Connect to SharePoint Online by specifying -SPOTenant parameter.
    Connect to Skype for Business online by specifying -ConnectSkype parameter.
    Connect to Security & Compliance Center by specifying -ConnectSCC parameter.
    Use old "Microsoft Azure Active Directory Module for Windows Powershell" instead of "Azure Active Directory Powershell for Graph module" by specifying -UseLegacyMSOLModule parameter.
.EXAMPLE
    Connect-Office365
.EXAMPLE
    Connect-Office365 -Credential -SPOTenant "contoso" -ConnectSCC -UseLegacyMSOLModule
.EXAMPLE
    Connect-Office365 -Username "admin@contoso.onmicrosoft.com" -Password "P@$$w0rd" -SPOTenant "contoso" -ConnectSkype -ConnectSCC
#>
function Connect-Office365 {
    [CmdletBinding(DefaultParameterSetName='default')]
    Param (
        [Parameter(ParameterSetName='Credential')]
        [pscredential]
        $Credential,

        [Parameter(ParameterSetName='UserPass')]
        [ValidateNotNullOrEmpty]
        [string]
        $Username,

        [Parameter(ParameterSetName='UserPass')]
        [ValidateNotNullOrEmpty]
        [string]
        $Password,

        [Parameter()]
        [ValidateNotNullOrEmpty]
        [string]
        $SPOTenant,

        [Parameter()]
        [switch]
        $ConnectSkype,

        [Parameter()]
        [switch]
        $ConnectSCC,

        [Parameter()]
        [switch]
        $UseLegacyMSOLModule
    )

    begin {
        # Check Azure module requirements
        if ($UseLegacyMSOLModule) {
            $azModule = "MSOnline"
            if (Get-Module -ListAvailable -Name $azModule) {
                Import-Module -Name $azModule
            } else {
                Write-Error -Message 'Microsoft Azure Active Directory Module for Windows Powershell (MSOnline) not available.' -RecommendedAction 'Please see https://docs.microsoft.com/de-de/office365/enterprise/powershell/connect-to-office-365-powershell#connect-with-the-microsoft-azure-active-directory-module-for-windows-powershell for installation-instructions.'
            }
        } else {
            $azModule = "AzureAD"
            if (Get-Module -ListAvailable -Name $azModule) {
                Import-Module -Name $azModule
            } else {
                try {
                    Write-Host -Object 'Azure Active Directory PowerShell for Graph module not installed. Trying Install-Module'
                    Install-Module -Name $azModule
                }
                catch {
                    Write-Error -Message 'Azure Active Directory PowerShell for Graph module (AzureAD) not available.' -RecommendedAction 'Please see https://docs.microsoft.com/de-de/office365/enterprise/powershell/connect-to-office-365-powershell#connect-with-the-azure-active-directory-powershell-for-graph-module for installation-instructions.'
                }
            }
        }

        # Check SharePoint module requirements
        if ($SPOTenant) {
            $spoModule = "Microsoft.Online.SharePoint.PowerShell"
            if (Get-Module -ListAvailable -Name $spoModule) {
                Import-Module -Name $spoModule -DisableNameChecking
            } else {
                try {
                    Write-Host -Object 'SharePoint Online Management Shell module not installed. Trying Install-Module'
                    Install-Module -Name $spoModule
                }
                catch {
                    Write-Error -Message 'SharePoint Online Management Shell not available.' -RecommendedAction 'Please see https://docs.microsoft.com/en-us/powershell/sharepoint/sharepoint-online/connect-sharepoint-online?view=sharepoint-ps for installation-instructions.'
                }
            }
        }

        # Check Skype for Business module requirements
        if ($ConnectSkype) {
            $sfboModule = "SkypeOnlineConnector"
            if (Get-Module -ListAvailable -Name $sfboModule) {
                Import-Module -Name $sfboModule
            } else {
                try {
                    Write-Host -Object 'Skype for Business Online module not installed. Trying Install-Module'
                    Install-Module -Name $sfboModule
                }
                catch {
                    Write-Error -Message 'Skype for Business Online module not available.' -RecommendedAction 'Please see https://docs.microsoft.com/de-de/office365/enterprise/powershell/manage-skype-for-business-online-with-office-365-powershell for installation-instructions.'
                }
            }
        }

        # Get Credentials if not provided via parameter
        if (!$Credential) {
            $Credential = Get-Credential -Message 'MS Online Credentials'
        }
    }
    
    process {
        if ($Credential) {
            # Connect Azure
            if ($UseLegacyMSOLModule) {
                # Azure AD (via MSOnline Module)
                Connect-MsolService -Credential $Credential
            } else {
                # Azure AD (via AzureAD Module)
                Connect-AzureAD -Credential $Credential
            }

            # Connect Exchange Online
            $EXOSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $Credential -Authentication "Basic" -AllowRedirection
            Import-Module (Import-PSSession -Session $EXOSession -AllowClobber -DisableNameChecking) -Global -DisableNameChecking

            # Connect SharePoint Online
            if ($SPOTenant) {
                Connect-SPOService -Url "https://$SPOTenant-admin.sharepoint.com" -Credential $Credential
            }

            # Connect Skype for Business Online
            if ($ConnectSkype) {
                $SFBOSession = New-CsOnlineSession -Credential $Credential
                Import-Module (Import-PSSession $SFBOSession -AllowClobber -DisableNameChecking) -Global -DisableNameChecking
            }

            # Connect Security & Compliance Center
            if ($ConnectSCC) {
                $SCCSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.compliance.protection.outlook.com/powershell-liveid/" -Credential $Credential -Authentication "Basic" -AllowRedirection
                Import-Module (Import-PSSession $SCCSession -Prefix "cc" -AllowClobber -DisableNameChecking) -Global -DisableNameChecking
            }
        } else {
            Write-Error -Message 'No Credentials were provided.' -RecommendedAction 'Run the cmdlet again and provide credentials.'
        }
    }
    
    end {
    }
}