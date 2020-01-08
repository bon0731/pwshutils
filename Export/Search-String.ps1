function Search-String() {
<#
.SYNOPSIS
指定ファイル内に指定パターン文字列が存在するか検索します。

.DESCRIPTION
指定ファイル内に指定パターン文字列が存在するか検索します。
存在する場合、存在する行番号及び行の内容を出力します。
出力フォーマットはWriterパラメータにより調整できます。

.PARAMETER Path
文字列検索対象のパスを指定します。
ディレクトリパスを指定した場合は、そのディレクトリ配下のファイルが検索対象となります。
ファイルパスを指定した場合は、PathPatternパラメータは無視されます。
未指定の場合はカレントディレクトリ配下を検索対象とします。

.PARAMETER PathPattern
Pathパラメータに指定したディレクトリ配下のファイルのうち、
このパラメータに指定した正規表現にマッチしたファイルのみを検索対象とします。
未指定の場合はすべてのファイルが検索対象となります。

.PARAMETER Pattern
ファイル内を検索する正規表現文字列を指定します。

.PARAMETER Before
検索対象文字列がマッチした行の前にある行も表示したい場合、表示する行数を指定します。

.PARAMETER After
検索対象文字列がマッチした行の後ろにある行も表示したい場合、表示する行数を指定します。

.PARAMETER Encoding
検索対象ファイルのエンコードを指定します。（デフォルトは、UTF-8）

.PARAMETER Writer
マッチ行を出力するための処理をスクリプトブロックで指定します。
スクリプトブロックには出力行の以下の情報パラメータが渡されます。

$info.IsFileFirst
 検索ファイルの最初の出力行の場合、True
$info.IsMatchLinesFirst
 マッチ単位先頭の出力行である場合、True
 （ファイル先頭でなければ-Beforeの最終行の時、True）
$info.IsMatchLinesEnd
 マッチ単位最後の出力行である場合、True
 （ファイル末尾でなければ-Afterの最終行の時、True）
$info.FilePath
 検索ファイルフルパス
$info.LineNumber
 出力行番号
$info.Line
 出力行内容
$info.MatchLineDistance
 マッチ行までの距離（例えば、-1ならマッチ行の直前行、0ならマッチ行、1なら直後の行）

例：

-Writer {
    param($info)

    if($info.IsFileFirst) {
        Write-Output -InputObject "";
        Write-Output -InputObject "[ $($info.FilePath) ]";
        Write-Output -InputObject "";
    }
    $accent = if($info.MatchLineDistance -eq 0) { "*" } else { " " };
    Write-Output -InputObject " $($info.LineNumber.ToString().PadLeft(5, "0")) ${accent}: $($info.Line)";
}

この例では、ファイル毎の最初に「ファイルパス」を出力し、以降「 行番号 : 行内容」の形式で検索結果を出力します。
（マッチ行に関しては行番号の後にアスタリスクを付けて出力します。）

.PARAMETER CaseSensitive
Patternパラメータに指定した文字列でマッチさせる際に大文字小文字を区別するかを指定します。
このパラメータを指定した場合には区別します。
#>
    param (
        [Parameter(ValueFromPipeline)][string]$Path=".",
        [string]$PathPattern=".*",
        [Parameter(Mandatory)]$Pattern,
        [Int]$Before,
        [Int]$After,
        [string]$Encoding="UTF-8",
        [scriptblock]$Writer={
            param($info)
            if($info.IsFileFirst) {
                Write-Output -InputObject "";
                Write-Output -InputObject "[ $($info.FilePath) ]";
                Write-Output -InputObject "";
            } elseif($info.IsMatchLinesFirst -and ($Before -gt 0 -or $After -gt 0)) {
                Write-Output -InputObject "";
            }
            $accent = if($info.MatchLineDistance -eq 0) { "*" } else { " " };
            Write-Output -InputObject " $($info.LineNumber.ToString().PadLeft(5, "0")) ${accent}: $($info.Line)";
        }.GetNewClosure(),
        [switch]$CaseSensitive
    )
    Process {
        try {
            $resolve_path = (Resolve-Path -Path $Path -ErrorAction Stop).Path;
        } catch [System.Management.Automation.ItemNotFoundException] {
            throw "${Path} が見つかりません。";
        }
        if([System.IO.File]::Exists($resolve_path)) {
            Search-StringPrivate -Path $resolve_path -Pattern $Pattern -Before $Before -After $After -Encoding $Encoding -Writer $Writer -CaseSensitive:$CaseSensitive;
        } else {
            Get-ChildItem -Path $resolve_path -File -Recurse | Where-Object {$_.FullName -match $PathPattern} | ForEach-Object {
                Search-StringPrivate -Path $_.FullName -Pattern $Pattern -Before $Before -After $After -Encoding $Encoding -Writer $Writer -CaseSensitive:$CaseSensitive;
            }
        }
    }
}