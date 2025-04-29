# Module entry point

$script:ModuleRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

# Import private helpers
Get-ChildItem -Path (Join-Path $script:ModuleRoot 'Private') -Filter '*.ps1' |
  ForEach-Object { . $_.FullName }

# Import public cmdlets
Get-ChildItem -Path (Join-Path $script:ModuleRoot 'Public') -Filter '*.ps1' |
  ForEach-Object { . $_.FullName }
