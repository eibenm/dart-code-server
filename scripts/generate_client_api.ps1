<#

Author: Matt Eiben
Email: eibenm@gmail.com

Description:

This script checks to see if Dartlang is installed and generates api stubs for clients.

#>

# Variables

$rootDirPath = Get-Location
$generatedDirPath = Join-Path -Path $rootDirPath -ChildPath generated
$scriptStartTime = Get-Date

# Including Functions

. "$rootDirPath\scripts\functions.ps1"

# Script

Print
Print -Message "Generating client stubs ..."
Print

if (-Not (DartInstalled))
{
    Print -Message "Dart is not installed" -Error
    exit
}

# Run a pub get
pub get

# Generate discovery document
pub run rpc:generate discovery -i .\lib\src\api_server.dart > $generatedDirPath\dartservices.json

# Update system encoding to utf8
(Get-Content -Path $generatedDirPath\dartservices.json) | Set-Content -Encoding UTF8 -Path $generatedDirPath\dartservices.json

# Generate client stub library
pub run discoveryapis_generator:generate files -i $generatedDirPath -o $generatedDirPath

Print
Print -Message "Generating client stubs: Finished..."
Print -Message "Script time: $((Get-Date).Subtract($scriptStartTime).Seconds) second(s)"
Print
