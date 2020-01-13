function Get-ImageFromStream() {
    param(
        [Parameter(Mandatory)][string]$Path
    )
    Process {
        try {
            $resolve_path = (Resolve-Path -Path $Path -ErrorAction Stop).Path;
        } catch [System.Management.Automation.ItemNotFoundException] {
            throw "${Path} が見つかりません。";
        }
        # Streamから読み込んで一旦ファイルを閉じないと環境によっては上書き保存できないため、
        # StreamからImageにしてStreamは閉じる
        try {
            $stream = [System.IO.File]::OpenRead($resolve_path);
            return [System.Drawing.Image]::FromStream($stream);
        } finally {
            if($null -ne $stream) {
                $stream.Close();
            }
        }
    }
}