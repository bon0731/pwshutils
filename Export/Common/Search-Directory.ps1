function Search-Directory() {
<#
.SYNOPSIS
指定ディレクトリ内にある指定ディレクトリ名を持つディレクトリを検索します。

.DESCRIPTION
-Pathパラメータに指定したディレクトリ配下に、
-Patternで指定した正規表現にマッチするディレクトリ名をもつディレクトリのDirectoryInfoオブジェクトを返します。

.PARAMETER Path
検索する基準となるディレクトリを指定します。
ここに指定したディレクトリ配下を検索対象とします。
未指定の場合、カレントディレクトリ配下を検索します。

.PARAMETER Pattern
ディレクトリ名にマッチさせる正規表現文字列を指定します。
未指定の場合、すべてのディレクトリを返します。
#>
    param(
        [string]$Path=".",
        [string]$Pattern=".*"
    )
    try {
        $resolve_path = (Resolve-Path -Path $Path -ErrorAction Stop).Path;
    } catch [System.Management.Automation.ItemNotFoundException] {
        throw "${Path} が見つかりません。";
    }
    if([System.IO.File]::Exists($Path)) {
        throw "-Path にはディレクトリを指定してください。";
    }
    return Get-ChildItem -Path $resolve_path -Directory -Recurse | Where-Object {$_.Name -match $Pattern};
}

