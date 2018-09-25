
#

function Invoke-ScriptFolder {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations.")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,
        [string]
        $filter,
        [scriptblock]
        $script
    )
    process {
        Set-Location $Path
        Get-ChildItem -Filter $filter `
        | Where-Object {$_.Name -match "\d\d\d.*"} `
        | Sort-Object -Property Name `
        | ForEach-Object $script
    }
}

function Invoke-SQLScriptFolder {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations.")]
        [ValidateNotNullOrEmpty()]
        [string]
        $ConnectionString,
        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations.")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path
    )
    process {
        Invoke-ScriptFolder -Path $Path -filter "*.sql" -script {
            Invoke-SqlCmd -ConnectionString $ConnectionString -InputFile $_.Name
        }
    }
}