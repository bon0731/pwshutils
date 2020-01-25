function Watch-Directory() {
<#
.SYNOPSIS
指定ディレクトリ内にあるファイル・ディレクトリの変更を監視します。

.DESCRIPTION
-Pathパラメータに指定したディレクトリ配下のファイルの編集/作成/削除/名前の変更を監視します。
変更が発生した時に-ScriptBlockに指定した処理を実行します。
監視を停止する場合には「Ctrl+C」を実行して下さい。（停止に少し時間がかかります。）

.PARAMETER Path
監視対象となるディレクトリを指定します。
ここに指定したディレクトリ配下のファイル・ディレクトリを監視します。
未指定の場合、カレントディレクトリ配下を監視します。

.PARAMETER Filter
監視対象となるファイル・ディレクトリのパターンをワイルドカードで指定して下さい。
未指定の場合は、すべてのファイル・ディレクトリが対象となります。

.PARAMETER ScriptBlock
変更を感知した際に実行する処理を指定します。
パラメータとして以下のオブジェクトが渡されます。

第一引数： {
    ChangeType: 変更種別（Created、Changed、Renamed、Deletedのいずれか）
    FullPath: 検知したファイル・ディレクトリへのフルパス
    OldFullPath: ChangeTypeがRenamedである場合は変更前のファイルへのフルパス、それ以外の場合はnull
}
#>
    param (
        [Parameter(ValueFromPipeline)][string]$Path=".",
        [String]$Filter="*",
        [Parameter(Mandatory)][scriptblock]$ScriptBlock
    )
    process {
        try {
            $resolve_path = (Resolve-Path -Path $Path -ErrorAction Stop).Path;
        } catch [System.Management.Automation.ItemNotFoundException] {
            throw Get-ErrorMessage -Code NOT_FOUND -Params @($Path);
        }
        if([System.IO.File]::Exists($Path)) {
            throw Get-ErrorMessage -Code NEED_DIRECTORY -Params @("-Path");
        }

        try {
            # 監視ジョブ
            $watch_job = Start-Job -ScriptBlock {
                param($p, $f)
                $watcher = [System.IO.FileSystemWatcher]::new($p);
                $watcher.Filter = $f;
                $watcher.IncludeSubdirectories = $true;
                $watcher.EnableRaisingEvents = $true;
                while($true) {
                    Write-Output -InputObject $watcher.WaitForChanged([System.IO.WatcherChangeTypes]::All);
                }
            } -ArgumentList @($resolve_path, $Filter);
        
            while($true) {
                Start-Sleep -Seconds 1;
                $job_result = $watch_job | Receive-Job;
                $job_result | ForEach-Object {
                    $type = $_.ChangeType;
                    $full_path = ConvertTo-FullPath -Path $_.Name;
                    $old_full_path = if(-not [String]::IsNullOrEmpty($_.OldName)) { ConvertTo-FullPath -Path $_.OldName } else { $null };

                    $ScriptBlock.Invoke([PSObject]@{
                        ChangeType = $type;
                        FullPath = $full_path;
                        OldFullPath = $old_full_path;
                    });
                }
            }
        } finally {
            if($null -ne $watch_job) {
                $watch_job | Remove-Job -Force;
            }
        }
    }
}