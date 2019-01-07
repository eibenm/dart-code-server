Function Print
{
    <#
        .SYNOPSIS
            This method prints text out to the console.  It has an optional "error" flag.
        .PARAMETER Message
            This parameter is a string representing the message to be printed.
        .PARAMETER Error
            This is an optional flag that prints the message with error formatting.
        .EXAMPLE
            Print -Message "There was an error" -Error
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)] [String]$Message = "",
        [Parameter(Mandatory=$false)] [Switch]$Error
    )
    Process
    {
        if ($Error)
        {
            Write-Host $Message -ForegroundColor Red
        }
        else
        {
            Write-Host $Message -ForegroundColor Magenta    
        }
    }
}

Function DartInstalled
{
    <#
        .SYNOPSIS
            This method returns a boolean representing if dart is installed or not.
        .EXAMPLE
            if (-Not (DartInstalled)) { }
    #>
    if (Get-Command "dart" -ErrorAction SilentlyContinue)
    {
        return $true
    }

    return $false
}
