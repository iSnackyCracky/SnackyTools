###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Get-DriveCapacity.ps1
# Autor        :  iSnackyCracky (https://isnackycracky.de/ -- https://github.com/isnackycracky/)
# Description  :  Get the drive capacity / free space of Computers
# Repository   :  https://github.com/isnackycracky/psmodule
###############################################################################################################

<#
    .SYNOPSIS
	Get drive capacity and free space of computers

    .DESCRIPTION
	Get drive capacity and free space of computers

    .EXAMPLE
	Get-DriveCapacity

	Drive  Size GB Free % Free
	-----  ---- ------- ------
	C:    229,2   121,5   53,0

	.EXAMPLE
	Get-DriveCapacity -Computer "localhost"

	Drive  Size GB Free % Free
	-----  ---- ------- ------
	C:    116,9   031,3   26,8
	D:    930,7   266,9   28,7
#>


function Get-DriveCapacity {
	[CmdletBinding()]
	param (
		[Parameter(Position=0,Mandatory=$false,HelpMessage="Computername")]
		[String]$Computer="localhost",
		[Parameter(Position=1,Mandatory=$false,HelpMessage="Credentials")]
		[System.Management.Automation.CredentialAttribute()]$Credential
	)

	begin {

	}

	process {
		try {
			Get-WmiObject -Class Win32_LogicalDisk -ComputerName $Computer -Filter "DriveType='3' or DriveType='2'" | Format-Table @{Label="Drive"; Expression={$_.DeviceID}}, @{Label="Size"; Expression={$_.Size / 1GB}; Format="000.0"; width=20}, @{Label="GB Free"; Expression={$_.FreeSpace / 1GB}; Format="000.0"; width=20}, @{Label="% Free"; Expression={$_.FreeSpace * 100 / $_.Size}; Format="00.0"; width=20}
		}
		catch {
			if (!$Credential) {
				$Credential = Get-Credential
			}
			Get-WmiObject -Class Win32_LogicalDisk -ComputerName $Computer -Credential $Credential -Filter "DriveType='3' or DriveType='2'" | Format-Table @{Label="Drive"; Expression={$_.DeviceID}}, @{Label="Size"; Expression={$_.Size / 1GB}; Format="000.0"; width=10}, @{Label="GB Free"; Expression={$_.FreeSpace / 1GB}; Format="000.0"; width=10}, @{Label="% Free"; Expression={$_.FreeSpace * 100 / $_.Size}; Format="00.0"; width=10}
		}
	}

	end {

	}
}
