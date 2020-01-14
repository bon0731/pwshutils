using namespace System.Drawing

function Get-ImageFormat() {
<#
.SYNOPSIS
指定画像の保存形式を取得します。

.DESCRIPTION
指定画像の保存形式を取得します。

.PARAMETER Path
画像のパスを指定します。
#>
    param(
        [Parameter(Mandatory, ValueFromPipeline)][string]$Path,
        [switch]$PassThru
    )
    Process {
        try {
            $resolve_path = (Resolve-Path -Path $Path -ErrorAction Stop).Path;
        } catch [System.Management.Automation.ItemNotFoundException] {
            throw Get-ErrorMessage -Code NOT_FOUND -Params @($Path);
        }
        try {
            $image = Get-ImageFromStream -Path $resolve_path;
            $formats = @{};
            [Imaging.ImageFormat] | Get-Member -Static -MemberType Properties | ForEach-Object {
                $formats[([Imaging.ImageFormat]::"$($_.Name)")] = $_.Name;
            }
            $format = $formats[$image.RawFormat];
            if($null -ne $format) {
                return $formats[$image.RawFormat];
            } else {
                return "Unknown";
            }
        } finally {
            if($null -ne $image) {
                $image.Dispose();
            }
        }
    }
}