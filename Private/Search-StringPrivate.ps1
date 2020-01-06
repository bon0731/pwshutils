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
        # 前半部、後半部をそれぞれsliceして全て繋げる（sliceした結果要素が1つになると配列ではなくなるので@()で配列に戻している）
        $pre_lines = @(if($Before -ne 0) { $match_info.Context.PreContext[-$Before..-1] } else { @() });
        $post_lines = @(if($After -ne 0 ) { $match_info.Context.PostContext[0..($After - 1)] } else { @() });
        $all_lines = $pre_lines + @($match_info.Line) + $post_lines;
        for($i = 0; $i -lt $all_lines.Length; $i++) {
            $distance = -$pre_lines.Length + $i;
            $Writer.Invoke($Path.FullName, $match_info.LineNumber + $distance, $all_lines[$i], $distance);
        }
    }
}