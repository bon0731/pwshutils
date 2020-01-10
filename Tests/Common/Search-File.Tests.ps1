Import-Module "$PSScriptRoot/../../pwshutils.psm1" -Force;

Describe "基本検索処理" {
    It "マッチファイル表示" {
        try {
            $temp_file = New-TemporaryFile;
            $temp_dir = Split-Path -Path $temp_file.FullName -Parent;
            New-Item -Path "$temp_dir/test_dir" -ItemType Directory;
            New-Item -Path "$temp_dir/test_dir/dir1" -ItemType Directory;
            New-Item -Path "$temp_dir/test_dir/dir2" -ItemType Directory;
            Set-Content -Path "$temp_dir/test_dir/abc.tmp" -Value "";
            Set-Content -Path "$temp_dir/test_dir/bcd.tmp" -Value "";
            Set-Content -Path "$temp_dir/test_dir/cde.tmp" -Value "";
            Set-Content -Path "$temp_dir/test_dir/dir2/def.tmp" -Value "";
            $result = Search-File "$temp_dir/test_dir" -Pattern "d";
            $result[0].Name | Should -Be "bcd.tmp";
            $result[1].Name | Should -Be "cde.tmp";
            $result[2].Name | Should -Be "def.tmp";
        } finally {
            $temp_file.Delete();
            Remove-Item "$temp_dir/test_dir" -Recurse;
        }
    }
}
Describe "例外" {
    It "Pathが存在しない" {
        try {
            $path = "not_found";
            Search-File -Path $path -Pattern "c";
            throw "";
        } catch {
            $_.Exception.Message | Should -Be "${path} が見つかりません。";
        }
    }
    It "Pathがファイル" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "";
        } finally {
            $temp_file.Delete();
        }
    }
}