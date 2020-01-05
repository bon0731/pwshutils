function Rename-ItemByPattern() {
<#
.SYNOPSIS
ファイル(ディレクトリ）名等を指定パターン文字列により変更します。

.DESCRIPTION
正規表現文字列によりファイル（ディレクトリ）名を変更します。

.PARAMETER Path
名前変更対象のファイル（ディレクトリ）のパスを指定します。

.PARAMETER Pattern
置換する正規表現文字列を指定します。。

.PARAMETER Replacement
置換後文字列を指定します。
#>
    param(
        [Parameter(Mandatory, ValueFromPipeline)][string]$Path,
        [Parameter(Mandatory)][string]$Pattern,
        [Parameter(Mandatory)][string]$Replacement
    )
    Process {
        try {
            $resolve_path = (Resolve-Path -Path $Path -ErrorAction Stop).Path;
            $old_name = Split-Path -Path $resolve_path -Leaf;
            Rename-Item -Path $resolve_path -NewName ($old_name -replace $Pattern, $Replacement);
        } catch [System.Management.Automation.ItemNotFoundException] {
            throw "${Path} が見つかりません。";
        }
    }
}
