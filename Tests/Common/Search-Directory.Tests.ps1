Import-Module "$PSScriptRoot/../../pwshutils.psm1" -Force;
. "$PSScriptRoot/../../Private/Resource/Get-ErrorMessage.ps1";

Describe "基本検索処理" {
    It "マッチディレクトリ表示" {
        try {
            $temp_file = New-TemporaryFile;
            $temp_dir = Split-Path -Path $temp_file.FullName -Parent;
            New-Item -Path "$temp_dir/test_dir" -ItemType Directory;
            New-Item -Path "$temp_dir/test_dir/dir1" -ItemType Directory;
            New-Item -Path "$temp_dir/test_dir/dir2" -ItemType Directory;
            New-Item -Path "$temp_dir/test_dir/dir2/dir3" -ItemType Directory;
            Set-Content -Path "$temp_dir/test_dir/abc.tmp" -Value "";
            Set-Content -Path "$temp_dir/test_dir/bcd.tmp" -Value "";
            Set-Content -Path "$temp_dir/test_dir/cde.tmp" -Value "";
            Set-Content -Path "$temp_dir/test_dir/dir2/def.tmp" -Value "";
            $result = Search-Directory "$temp_dir/test_dir" -Pattern "1|3";
            $result[0].Name | Should -Be "dir1";
            $result[1].Name | Should -Be "dir3";
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
            Search-Directory -Path $path -Pattern "c";
            throw "";
        } catch {
            $_.Exception.Message | Should -Be (Get-ErrorMessage -Code NOT_FOUND -Params @($Path));
        }
    }
    It "Pathがファイル" {
        try {
            $temp_file = New-TemporaryFile;
            Search-Directory -Path $temp_file.FullName -Pattern "c";
            throw "";
        } catch {
            $_.Exception.Message | Should -Be (Get-ErrorMessage -Code NEED_DIRECTORY -Params @("-Path"));
        } finally {
            $temp_file.Delete();
        }
    }
}
