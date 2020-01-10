function ConvertTo-FullPath {
<#
.SYNOPSIS
相対パスを絶対パスへ変換します。

.DESCRIPTION
相対パスを絶対パスへ変換します。
Resolve-Path等とは異なり、存在しないパスであっても例外は発生しません。

.PARAMETER Path
絶対パスを取得したい相対パス
#>
    param(
        [Parameter(Mandatory, ValueFromPipeline)][string]$Path
    )
    Process {
        return $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path);
    }
}