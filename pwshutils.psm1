Get-ChildItem -Filter *.ps1 -Path Export, Private -Recurse | ForEach-Object {
    . $_.FullName;
}
Get-ChildItem -Filter *.ps1 -Path Export -Recurse | ForEach-Object {
    Export-ModuleMember $_.BaseName;
}
