using namespace System.Drawing

function Invoke-DrawString() {
<#
.SYNOPSIS
指定画像ファイルに対して指定座標に文字列を描画します。

.DESCRIPTION
指定画像ファイルに対して指定座標に文字列を描画します。

.PARAMETER Path
編集画像のパスを指定します。

.PARAMETER X
描画X座標を指定します。

.PARAMETER Y
描画Y座標を指定します。

.PARAMETER FontName
描画文字列のフォント名を指定します。
未指定の場合、システムのデフォルト値を使用します。

.PARAMETER FontSize
描画文字列のフォントサイズを指定します。
未指定の場合、システムのデフォルト値を使用します。

.PARAMETER A
文字色の透過度(0〜255)を指定します。

.PARAMETER R
文字色の赤強度(0〜255)を指定します。

.PARAMETER G
文字色の緑強度(0〜255)を指定します。

.PARAMETER B
文字色の青強度(0〜255)を指定します。

.PARAMETER PassThru
出力先パスを返します。
（パイプにより他画像編集関数へ渡すことができます。）
#>
    param(
        [Parameter(Mandatory, ValueFromPipeline)][string]$Path,
        [Parameter(Mandatory)][int]$X,
        [Parameter(Mandatory)][int]$Y,
        [Parameter(Mandatory)][string]$Text,
        [string]$FontName=[SystemFonts]::DefaultFont.Name,
        [int]$FontSize=[SystemFonts]::DefaultFont.Size,
        [int]$A=0xFF,
        [int]$R=0x00,
        [int]$G=0x00,
        [int]$B=0x00,
        [switch]$PassThru
    )
    Process {
        try {
            $resolve_path = (Resolve-Path -Path $Path -ErrorAction Stop).Path;
        } catch [System.Management.Automation.ItemNotFoundException] {
            throw "${Path} が見つかりません。";
        }
        $alpha = [Math]::Max(0, [Math]::Min(0xFF, $A));
        $red = [Math]::Max(0, [Math]::Min(0xFF, $R));
        $green = [Math]::Max(0, [Math]::Min(0xFF, $G));
        $blue = [Math]::Max(0, [Math]::Min(0xFF, $B));
        try {
            $image = Get-ImageFromStream -Path $resolve_path;
            $graphics = [Graphics]::FromImage($image);
            $graphics.SmoothingMode = [Drawing2D.SmoothingMode]::HighQuality;
            $brush = [SolidBrush]::new([Color]::FromArgb($alpha, $red, $green, $blue));
            $font = [Font]::new($FontName, $FontSize);
            $format = [StringFormat]::new([StringFormat]::GenericTypographic);
            $graphics.DrawString($Text, $font, $brush, $X, $Y, $format);
            $image.Save($resolve_path);
        } finally {
            if($null -ne $image) {
                $image.Dispose();
            }
            if($null -ne $graphics) {
                $graphics.Dispose();
            }
            if($null -ne $brush) {
                $brush.Dispose();
            }
            if($null -ne $font) {
                $font.Dispose();
            }
            if($null -ne $format){
                $format.Dispose();
            }
        }
        if($PassThru) {
            return $resolve_path;
        }
    }
}