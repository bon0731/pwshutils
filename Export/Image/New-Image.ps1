using namespace System.Drawing

function New-Image() {
<#
.SYNOPSIS
空の画像ファイルを作成します。

.DESCRIPTION
空の画像ファイルを作成します。
画像形式を選択しない場合、ビットマップになります。

.PARAMETER Path
出力先パスを指定します。

.PARAMETER Width
出力画像の幅を指定します。

.PARAMETER Height
出力画像の高さを指定します。

.PARAMETER OutFormat
画像の出力形式を指定します。

.PARAMETER PassThru
出力先パスを返します。
（パイプにより他画像編集関数へ渡すことができます。）
#>
    param(
        [Parameter(Mandatory, ValueFromPipeline)][string]$Path,
        [Parameter(Mandatory)]$Width,
        [Parameter(Mandatory)]$Height,
        [ValidateSet("Bmp", "Jpeg", "Png")]$OutFormat="Bmp",
        [switch]$PassThru
    )
    Process {
        $full_path = ConvertTo-FullPath -Path $Path;
        try {
            $image = [Bitmap]::new($Width, $Height);
            $image.Save($full_path, [Imaging.ImageFormat]::"${OutFormat}");
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