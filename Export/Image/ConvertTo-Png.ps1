using namespace System.Drawing

function ConvertTo-Png() {
<#
.SYNOPSIS
指定画像の保存形式をPNG形式に変換します。

.DESCRIPTION
指定画像の保存形式をPNG形式に変換します。

.PARAMETER Path
変換元画像のパスを指定します。

.PARAMETER PassThru
出力先パスを返します。
（パイプにより他画像編集関数へ渡すことができます。）
#>
    param(
        [Parameter(Mandatory, ValueFromPipeline)][string]$Path,
        [switch]$PassThru
    )
    Process {
        $full_path = Convert-ImageFormat -Path $Path -OutFormat ([System.Drawing.Imaging.ImageFormat]::Png);
        if($PassThru) {
            return $full_path;
        }
    }
}