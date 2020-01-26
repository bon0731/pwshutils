$ExportPath = "$PSScriptRoot/Export";
$PrivatePath = "$PSScriptRoot/Private";
Get-ChildItem -Filter *.ps1 -Path $ExportPath, $PrivatePath -Recurse | ForEach-Object {
    . $_.FullName;
}
Get-ChildItem -Filter *.ps1 -Path $ExportPath -Recurse | ForEach-Object {
    Export-ModuleMember $_.BaseName;
}
