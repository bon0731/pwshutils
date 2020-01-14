function Convert-NewLine() {
<#
.SYNOPSIS
ファイルの改行コードを変更します。

.DESCRIPTION
ファイルの改行コードをLF、またはCRLFに変更します。

.PARAMETER Path
変更対象のファイルへのパスを指定します。

.PARAMETER Encoding
変換対象のファイルのエンコード形式を指定します。

.PARAMETER CRLF
改行コードをCRLFに変更する場合に指定します。
（-CRLF、-LF のいずれかを指定してください。）

.PARAMETER LF
改行コードをLFに変更する場合に指定します。
（-CRLF、-LF のいずれかを指定してください。）
#>
    param(
        [Parameter(Mandatory, ValueFromPipeline)][string]$Path,
        [string]$Encoding="UTF-8",
        [switch]$CRLF,
        [switch]$LF
    )
    Process {
        try {
            if($CRLF) {
                $new_line = "`r`n";
            } elseif($LF) {
                $new_line = "`n";
            } else {
                throw Get-ErrorMessage -Code REQUIRED_OR -Params @("-CRLF", "-LF");
            }
            $resolve_path = (Resolve-Path -Path $Path -ErrorAction Stop).Path;
            $raw = Get-Content -Path $resolve_path -Encoding $Encoding -Raw;
            $bytes = [System.Text.Encoding]::GetEncoding($Encoding).GetBytes(($raw -replace "\r?\n", $new_line));
            [System.IO.File]::WriteAllBytes($resolve_path, $bytes);
        } catch [System.Management.Automation.ItemNotFoundException] {
            throw Get-ErrorMessage -Code NOT_FOUND -Params @($Path);
        }
    }
}