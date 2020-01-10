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
    $before_output_line_file = "";
    Select-String -Path $Path -Pattern $Pattern -Context $context_count -Encoding $Encoding -CaseSensitive:$CaseSensitive | ForEach-Object {
        $match_info = $_;
        # 前半部、後半部をそれぞれsliceして全て繋げる（sliceした結果要素が1つになると配列ではなくなるので@()で配列に戻している）
        $pre_lines = @(if($Before -ne 0) { $match_info.Context.PreContext[-$Before..-1] } else { @() });
        $post_lines = @(if($After -ne 0 ) { $match_info.Context.PostContext[0..($After - 1)] } else { @() });
        $all_lines = $pre_lines + @($match_info.Line) + $post_lines;
        for($i = 0; $i -lt $all_lines.Length; $i++) {
            $distance = -$pre_lines.Length + $i;
            $Writer.Invoke(@{
                # ファイル内最初のマッチ出力
                IsFileFirst = $before_output_line_file -ne $Path.FullName;
                # マッチ単位最初の出力行
                IsMatchLinesFirst = $i -eq 0;
                # マッチ単位最後の出力行
                IsMatchLinesEnd = $i -eq $all_lines.Length - 1;
                # ファイルフルパス
                FilePath=$Path.FullName;
                # 行番号
                LineNumber=$match_info.LineNumber + $distance;
                # 行内容
                Line=$all_lines[$i];
                # マッチ行までの相対距離
                MatchLineDistance=$distance;
            });
            $before_output_line_file = $Path.FullName;
        }
    }
}