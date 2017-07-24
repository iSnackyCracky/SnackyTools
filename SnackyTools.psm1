###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  SnackyTools.psm1
# Autor        :  iSnackyCracky (https://isnackycracky.de/ -- https://github.com/isnackycracky/)
# Description  :  PowerShell-Module with some Functions for daily use
# Repository   :  https://github.com/isnackycracky/SnackyTools
###############################################################################################################

# Include functions which are outsourced in .ps1-files
Get-ChildItem -Path "$PSScriptRoot\Functions" -Recurse | Where-Object {$_.Name.EndsWith(".ps1")} | ForEach-Object {. $_.FullName}
