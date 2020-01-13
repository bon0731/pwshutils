using namespace System.Drawing

function Invoke-DrawPie() {
<#
.SYNOPSIS
指定画像ファイルに対して扇形を描画します。

.DESCRIPTION
指定画像ファイルに対して扇形を描画します。
指定矩形範囲に内接する円の指定角度範囲の扇形を描画します。

.PARAMETER Path
編集画像のパスを指定します。

.PARAMETER Left
矩形左上X座標を指定します。

.PARAMETER Top
矩形左上Y座標を指定します。

.PARAMETER Width
矩形幅を指定します。

.PARAMETER Height
矩形高さを指定します。

.PARAMETER LineWidth
描画線の太さを指定します。

.PARAMETER A
描画線の色の透過度(0〜255)を指定します。

.PARAMETER R
描画線の色の赤強度(0〜255)を指定します。

.PARAMETER G
描画線の色の緑強度(0〜255)を指定します。

.PARAMETER B
描画線の色の青強度(0〜255)を指定します。

.PARAMETER StartAngle
描画角度の開始角度を指定します。

.PARAMETER SweepAngle
描画角度の終了角度を指定します。

.PARAMETER PassThru
出力先パスを返します。
（パイプにより他画像編集関数へ渡すことができます。）
#>
    param(
        [Parameter(Mandatory, ValueFromPipeline)][string]$Path,
        [Parameter(Mandatory)][int]$Left,
        [Parameter(Mandatory)][int]$Top,
        [Parameter(Mandatory)][int]$Width,
        [Parameter(Mandatory)][int]$Height,
        [Parameter(Mandatory)][int]$StartAngle,
        [Parameter(Mandatory)][int]$SweepAngle,
        [int]$LineWidth=1,
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
            $rectangle = [Rectangle]::new($Left, $Top, $Width, $Height);
            $pen = [Pen]::new($brush, $LineWidth);
            $graphics.DrawPie($pen, $rectangle, $StartAngle, $SweepAngle);
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
            if($null -ne $pen) {
                $pen.Dispose();
            }
        }
        if($PassThru) {
            return $resolve_path;
        }
    }
}