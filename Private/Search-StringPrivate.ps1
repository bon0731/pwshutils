function Search-StringPrivate() {
    param (
        [Parameter(Mandatory)][System.IO.FileInfo]$Path,
        [Parameter(Mandatory)][string]$Pattern,
        [Int]$Before,
        [Int]$After,
        [Parameter(Mandatory)][string]$Encoding,
        [Parameter(Mandatory)][scriptblock]$Writer,
        [switch]$CaseSensitive
    )

    $context_count = [Math]::Max($Before, $After);
    Select-String -Path $Path -Pattern $Pattern -Context $context_count -Encoding $Encoding -CaseSensitive:$CaseSensitive | ForEach-Object {
        $match_info = $_;
        if($Before -gt 0) {
            # 前行表示
            $context = $match_info.Context.PreContext;
            $end = $context.Length - 1;
            $start = $end - [Math]::Min($end, $Before - 1)
            for($i = $start; $i -le $end; $i++) {
                $distance = $i - $end - 1;
                $Writer.Invoke($Path.FullName, $match_info.LineNumber + $distance, $context[$i], $distance);
            }
        }
        # マッチ行表示
        $Writer.Invoke($Path.FullName, $match_info.LineNumber, $match_info.Line, 0);
        if($After -gt 0) {
            # 後行表示
            $context = $match_info.Context.PostContext;
            $end = [Math]::Min($context.Length - 1, $After - 1)
            for($i = 0; $i -le $end; $i++) {
                $distance = $i + 1;
                $Writer.Invoke($Path.FullName, $match_info.LineNumber + $distance, $context[$i], $distance);
            }
        }
        Write-Output -InputObject "";
    };
}