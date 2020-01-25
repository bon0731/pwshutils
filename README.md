# pwshutils
PowerShellのユーティリティ  
`PowerShell Core 6.2.3` 以上推奨

## 使用方法

```powershell
Import-Module ./pwshutils.psm1 -Force
```

## 追加される関数

### 汎用系関数

* Convert-Encoding (ファイルエンコード変更)
* Convert-NewLine (ファイル改行コード変更)
* ConvertTo-FullPath (相対パスの絶対パス変換)
* Rename-ItemByPattern (正規表現によるファイル名変更)
* Search-Directory (ディレクトリ名検索)
* Search-File (ファイル名検索)
* Search-String (ファイル内文字列検索)
* Watch-Directory (ディレクトリ内変更の検知)

### 画像系関数

* ConvertTo-Jpeg (画像ファイルのJPEG形式変換)
* ConvertTo-Png (画像ファイルのPNG形式変換)
* Get-ImageFormat (画像ファイルの保存形式を確認)
* Invoke-DrawArc (画像ファイルへ弧を描画)
* Invoke-DrawCurve (画像ファイルへ曲線を描画)
* Invoke-DrawEllipse (画像ファイルへ円・楕円を描画)
* Invoke-DrawPie (画像ファイルへ扇形を描画)
* Invoke-DrawPolygon (画像ファイルへ線を描画)
* Invoke-DrawRectangle (画像ファイルへ矩形を描画)
* Invoke-DrawString (画像ファイルへテキストを描画)
* Invoke=DrawStringInRectangle (画像ファイルへ指定矩形範囲内にテキストを描画)
* Invoke-FillEllipse (画像ファイルへ円・楕円を塗りつぶして描画)
* Invoke-FillPie (画像ファイルへ扇形を塗りつぶして描画)
* Invoke-FillPolygon (画像ファイルへ多角形を塗りつぶして描画)
* Invoke-FillRectangle (画像ファイルへ矩形を塗りつぶして描画)
* Invoke-NewImage (空の画像ファイルを生成)

## 使用方法

詳しくは、各関数について

```powershell
Get-Help 関数 -Detailed
```

または、`Tests` ディレクトリ配下のテストコードを参照のこと。

## テストの実行

```powershell
Invoke-Pester ./Tests/*
```
