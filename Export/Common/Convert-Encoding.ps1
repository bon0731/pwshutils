function Convert-Encoding() {
<#
.SYNOPSIS
ファイルのエンコードを変更します。

.DESCRIPTION
ファイルのエンコード、および改行コードをLF、またはCRLFに変更します。

.PARAMETER Path
変更対象のファイルへのパスを指定します。

.PARAMETER From
変換対象のファイルの変換前エンコード形式を指定します。

.PARAMETER To
変換対象のファイルの変換後エンコード形式を指定します。

.PARAMETER CRLF
改行コードをCRLFに変更する場合に指定します。

.PARAMETER LF
改行コードをLFに変更する場合に指定します。
#>
    param(
        [Parameter(Mandatory, ValueFromPipeline)][string]$Path,
        [Parameter(Mandatory)][string]$From,
        [Parameter(Mandatory)][string]$To,
        [switch]$CRLF,
        [switch]$LF
    )
    Process {
        try {
            $resolve_path = (Resolve-Path -Path $Path -ErrorAction Stop).Path;
            $raw = Get-Content -Path $resolve_path -Encoding $From -Raw;
            $bytes = [System.Text.Encoding]::GetEncoding($To).GetBytes($raw);
            [System.IO.File]::WriteAllBytes($resolve_path, $bytes);
            if($CRLF) {
                Convert-NewLine -Path $Path -Encoding $To -CRLF;
            } elseif ($LF) {
                Convert-NewLine -Path $Path -Encoding $To -LF;
            }
        } catch [System.Management.Automation.ItemNotFoundException] {
            throw Get-ErrorMessage -Code NOT_FOUND -Params @($Path);
        }
    }
}
