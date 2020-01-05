# pwshutils
PowerShellのユーティリティ

## 使用方法

```powershell
Import-Module ./pwshutils.psm1 -Force
```

## 使えるようになる関数

* Search-String （ファイル検索）
* Rename-ItemByPattern （正規表現によるファイル名変更）
* Convert-Encoding (ファイルエンコード変更)
* Convert-NewLine （ファイル改行コード変更）

詳しくは、各関数について

```powershell
Get-Help 関数 -Detailed
```

を参照のこと。

## テストの実行

```powershell
Invoke-Pester ./Tests/*
```
