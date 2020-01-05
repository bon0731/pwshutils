function Search-String() {
<#
.SYNOPSIS
指定ファイル内に指定パターン文字列が存在するか検索します。

.DESCRIPTION
指定ファイル内に指定パターン文字列が存在するか検索します。
存在する場合、存在する行番号及び行の内容を出力します。
出力フォーマットはWriterパラメータにより調整できます。

.PARAMETER Path
文字列検索対象のファイルへのパスを指定します。
このパラメータを指定しない場合は、PathPatternパラメータを指定する必要があります。

.PARAMETER PathPattern
カレントディレクトリを基準に、配下のファイルのファイル名に対しマッチさせる正規表現を指定します。
マッチしたファイルに対し、検索対象文字列が存在するか検索します。
このパラメータを指定しない場合は、Pathパラメータを指定する必要があります。

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
スクリプトブロックには以下のパラメータが渡されます。

第一引数：ファイル名のフルパス
第二引数：出力行番号
第三引数：出力行内容
第四引数：マッチ行までの距離（例えば、-1ならマッチ行の直前行、0ならマッチ行、1なら直後の行）

例：（省略時のデフォルト処理）

-Writer {
    param($Filename, $LineNumber, $Line, $MatchLineDistance)
    if($MatchLineDistance -eq 0) {
        Write-Output -InputObject "${Filename} $($LineNumber.ToString().PadLeft(5, "0")) *: ${Line}";
    } else {
        Write-Output -InputObject "${Filename} $($LineNumber.ToString().PadLeft(5, "0"))  : ${Line}";
    }
}

この例では「ファイル名 行番号 : 行内容」の形式で出力し、
マッチ行に関しては行番号の後にアスタリスクを付けて出力します。

.PARAMETER CaseSensitive
Patternパラメータに指定した文字列でマッチさせる際に大文字小文字を区別するかを指定します。
このパラメータを指定した場合には区別します。
#>
    param (
        [Parameter(ValueFromPipeline)][string]$Path,
        [string]$PathPattern,
        [Parameter(Mandatory)]$Pattern,
        [Int]$Before,
        [Int]$After,
        [string]$Encoding="UTF-8",
        [scriptblock]$Writer={
            param($Filename, $LineNumber, $Line, $MatchLineDistance)
            if($MatchLineDistance -eq 0) {
                Write-Output -InputObject "${Filename} $($LineNumber.ToString().PadLeft(5, "0")) *: ${Line}";
            } else {
                Write-Output -InputObject "${Filename} $($LineNumber.ToString().PadLeft(5, "0"))  : ${Line}";
            }
        },
        [switch]$CaseSensitive
    )
    Process {
        if(-not [string]::IsNullOrEmpty($PathPattern)) {
            Get-ChildItem -File -Recurse | Where-Object {$_.FullName -match $PathPattern} | ForEach-Object {
                Search-StringPrivate -Path $_.FullName -Pattern $Pattern -Before $Before -After $After -Encoding $Encoding -Writer $Writer -CaseSensitive:$CaseSensitive;
            }
        } elseif (-not [string]::IsNullOrEmpty($Path)) {
            $resolve_path = (Resolve-Path -Path $Path).Path;
            if([System.IO.File]::Exists($resolve_path)) {
                Search-StringPrivate -Path $resolve_path -Pattern $Pattern -Before $Before -After $After -Encoding $Encoding -Writer $Writer -CaseSensitive:$CaseSensitive;
            }
        } else {
            throw "-Path または -PathPattern パラメータは必須です。";
        }
    }
}