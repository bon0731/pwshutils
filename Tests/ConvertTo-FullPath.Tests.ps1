Import-Module "$PSScriptRoot/../pwshutils.psm1" -Force;

Describe "基本検索処理" {
    It "通常変換" {
        $actual = ConvertTo-FullPath -Path ".";
        $actual | Should -Be (Resolve-Path -Path ".").Path;
    }
    It "パイプ入力" {
        $actual = "." | ConvertTo-FullPath;
        $actual | Should -Be (Resolve-Path -Path ".").Path;
    }
    It "存在しないパス" {
        $actual = "./unknown" | ConvertTo-FullPath;
        $sep = [System.IO.Path]::DirectorySeparatorChar;
        $actual | Should -Be "$((Resolve-Path -Path ".").Path)${sep}unknown";
    }
}