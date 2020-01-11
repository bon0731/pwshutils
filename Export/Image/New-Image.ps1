using namespace System.Drawing

function New-Image() {
<#
.SYNOPSIS
空のビットマップファイルを作成します。

.DESCRIPTION
空のビットマップファイルを作成します。

.PARAMETER Path
出力先パスを指定します。

.PARAMETER Width
出力画像の幅を指定します。

.PARAMETER Height
出力画像の高さを指定します。

.PARAMETER PassThru
出力先パスを返します。
（パイプにより他画像編集関数へ渡すことができます。）
#>
    param(
        [Parameter(Mandatory, ValueFromPipeline)][string]$Path,
        [Parameter(Mandatory)]$Width,
        [Parameter(Mandatory)]$Height,
        [switch]$PassThru
    )
    Process {
        $full_path = ConvertTo-FullPath -Path $Path;
        try {
            $image = [Bitmap]::new($Width, $Height);
            $image.Save($full_path);
        } finally {
            if($null -ne $image) {
                $image.Dispose();
            }
        }
        if($PassThru) {
            return $full_path;
        }
    }
}