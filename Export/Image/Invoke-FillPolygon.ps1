using namespace System.Drawing

function Invoke-FillPolygon() {
<#
.SYNOPSIS
指定画像ファイルに対して指定パス範囲を塗りつぶした図形を描画します。

.DESCRIPTION
指定画像ファイルに対して指定パス範囲を塗りつぶした図形を描画します。

.PARAMETER Path
編集画像のパスを指定します。

.PARAMETER Points
描画点の配列を指定します。
例：
-Points @(
    @{x=50; y=50;},
    @{x=25; y=100;},
    @{x=75; y=100;}
)

.PARAMETER A
塗りつぶし色の透過度(0〜255)を指定します。

.PARAMETER R
塗りつぶし色の赤強度(0〜255)を指定します。

.PARAMETER G
塗りつぶし色の緑強度(0〜255)を指定します。

.PARAMETER B
塗りつぶし色の青強度(0〜255)を指定します。

.PARAMETER PassThru
出力先パスを返します。
（パイプにより他画像編集関数へ渡すことができます。）
#>
    param(
        [Parameter(Mandatory, ValueFromPipeline)][string]$Path,
        [Parameter(Mandatory, ValueFromPipeline)][Point[]]$Points,
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
            throw Get-ErrorMessage -Code NOT_FOUND -Params @($Path);
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
            $graphics.FillPolygon($brush, $Points);
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
        }
        if($PassThru) {
            return $resolve_path;
        }
    }
}