###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Switch-Office365License.ps1
# Autor        :  iSnackyCracky (https://isnackycracky.de/ -- https://github.com/isnackycracky/)
# Description  :  Switch the License of one or all Users from one to another
# Repository   :  https://github.com/isnackycracky/SnackyTools
###############################################################################################################

<#
.SYNOPSIS
Switch the License of one or all Users from one to another

.DESCRIPTION
Switch the License of one or all Users from one to another

.EXAMPLE
Switch-Office365License -OldSkuPartNumber "SMB_BUSINESS_PREMIUM" -NewSkuPartNumber "O365_BUSINESS_PREMIUM"
#>

function Switch-Office365License {
    [CmdletBinding()]

    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "User Principal Name of single user")]
        [String]$UserPrincipalName,
        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Old SKU-Part-Number")]
        [String]$OldSkuPartNumber,
        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "New SKU-Part-Number")]
        [String]$NewSkuPartNumber,
        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "List possible SKU-Part-Numbers")]
        [Switch]$ListSkuPartNumbers
    )
	
    begin {
    }
	
    process {
        if ($ListSkuPartNumbers) {
			Write-Host
			Get-Content $PSScriptRoot\SKUPartNumbers.txt | Write-Host
        } else {	
            If ($UserPrincipalName) {
                $o365Users = Get-MsolUser -UserPrincipalName $UserPrincipalName | Where-Object {$_.Licenses[0].AccountSkuId -like "*$oldSkuPartNumber*"}
            }
            else {
                $o365Users = Get-MsolUser | Where-Object {$_.Licenses[0].AccountSkuId -like "*$oldSkuPartNumber*"}
            }
			
            # Remove the old License
            $o365Users | Set-MsolUserLicense -RemoveLicenses (Get-MsolAccountSku | Where-Object {$_.AccountSkuId -like $oldSkuPartNumber}).AccountSkuId
            # Add the new License
            $o365Users | Set-MsolUserLicense -AddLicenses (Get-MsolAccountSku | Where-Object {$_.SkuPartNumber -like $newSkuPartNumber}).AccountSkuId
            Write-Output $o365Users
        }
    }
	
    end {
    }
}