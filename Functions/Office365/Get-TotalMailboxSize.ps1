###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Get-TotalMailboxSize.ps1
# Autor        :  iSnackyCracky (https://isnackycracky.de/ -- https://github.com/isnackycracky/)
# Description  :  Get the sum of all Mailbox-Sizes
# Repository   :  https://github.com/isnackycracky/SnackyTools
###############################################################################################################

<#
.SYNOPSIS
Get the sum of all Mailbox-Sizes

.DESCRIPTION
Get the sum of all Mailbox-Sizes

.EXAMPLE
Get-TotalMailboxSize
#>

function Get-TotalMailboxSize {
    [CmdletBinding()]
    param(

    )

    Begin {

    }

    Process {
        # Get all Mailbox-Stats
        $allstats = Get-Mailbox -ResultSize unlimited | Get-MailboxStatistics
        $regex = [regex]"\((.*)\)"
        foreach ($stat in $allstats) {
            # $Name = $stat.DisplayName
            $TIS = $stat.TotalItemSize.Value.ToString()
            $TDIS = $stat.TotalDeletedItemSize.Value.ToString()

            $TISString = [regex]::Match($TIS, $regex).Groups[1]
            $TDISString = [regex]::Match($TDIS, $regex).Groups[1]
            
            $TISString = $TISString -replace "Bytes",""
            $TDISString = $TDISString -replace "Bytes",""
            
            $TISValue = [INT]$TISString
            $TDISValue = [INT]$TDISString

            $TotalSize = [decimal]::Round((($TISValue + $TDISValue)/1024)/1024)
        }
        Write-Host $TotalSize
    }

    End {

    }
}
