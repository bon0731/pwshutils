using namespace System.Drawing

function Convert-ImageFormat() {
    param(
        [Parameter(Mandatory, ValueFromPipeline)][string]$Path,
        [Imaging.ImageFormat]$OutFormat
    )
    Process {
        try {
            $resolve_path = (Resolve-Path -Path $Path -ErrorAction Stop).Path;
        } catch [System.Management.Automation.ItemNotFoundException] {
            throw "${Path} が見つかりません。";
        }
        try {
            $image = Get-ImageFromStream -Path $resolve_path;
            $bmp = [Bitmap]::new($image);
            $bmp.Save($resolve_path, $OutFormat);
        } finally {
            if($null -ne $image) {
                $image.Dispose();
            }
            if($null -ne $bmp) {
                $bmp.Dispose();
            }
        }
        return $resolve_path;
    }
}