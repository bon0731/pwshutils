Import-Module "$PSScriptRoot/../../pwshutils.psm1" -Force;
. "$PSScriptRoot/../../Private/Resource/Get-ErrorMessage.ps1";

Describe "基本置換処理" {
    It "ファイル名置換" {
        try {
            $old_path = "$PSScriptRoot/Test123.tmp";
            New-Item -Path $old_path -ItemType File;
            Rename-ItemByPattern -Path $old_path -Pattern "[0-9]+" -Replacement "A";
            $true | Should -Be (Test-Path -Path "$PSScriptRoot/TestA.tmp");
        } finally {
            Get-ChildItem -Path $PSScriptRoot -Filter "*.tmp" | ForEach-Object {
                $_.Delete();
            }
        }
    }
    It "ディレクトリ名置換" {
        try {
            $old_path = "$PSScriptRoot/Test123.tmp";
            New-Item -Path $old_path -ItemType Directory;
            Rename-ItemByPattern -Path $old_path -Pattern "[0-9]+" -Replacement "A";
            $true | Should -Be (Test-Path -Path "$PSScriptRoot/TestA.tmp");
        } finally {
            Get-ChildItem -Path $PSScriptRoot -Filter "*.tmp" | ForEach-Object {
                $_.Delete();
            }
        }
    }
    It "置換パラメータ使用" {
        try {
            $old_path = "$PSScriptRoot/Test123.tmp";
            New-Item -Path $old_path -ItemType File;
            Rename-ItemByPattern -Path $old_path -Pattern "([0-9])([0-9])([0-9])" -Replacement "`$1_`$2_`$3";
            $true | Should -Be (Test-Path -Path "$PSScriptRoot/Test1_2_3.tmp");
        } finally {
            Get-ChildItem -Path $PSScriptRoot -Filter "*.tmp" | ForEach-Object {
                $_.Delete();
            }
        }
    }
}
Describe "パイプ処理" {
    It "パイプ処理" {
        try {
            New-Item -Path "$PSScriptRoot/Test1.tmp" -ItemType File;
            New-Item -Path "$PSScriptRoot/Test2.tmp" -ItemType File;
            Get-ChildItem -Path $PSScriptRoot -Filter "*.tmp" | Rename-ItemByPattern -Pattern "Test" -Replacement "A";
            $true | Should -Be (Test-Path -Path "$PSScriptRoot/A1.tmp");
            $true | Should -Be (Test-Path -Path "$PSScriptRoot/A2.tmp");
        } finally {
            Get-ChildItem -Path $PSScriptRoot -Filter "*.tmp" | ForEach-Object {
                $_.Delete();
            }
        }
    }
}
Describe "例外" {
    It "ファイルがない" {
        try {
            $path = "$PSScriptRoot/not_found.tmp";
            Rename-ItemByPattern -Path $path -Pattern "not_found" -Replacement "found";
            throw "";
        } catch {
            $_.Exception.Message | Should -Be (Get-ErrorMessage -Code NOT_FOUND -Params @($Path));
        } finally {
            Get-ChildItem -Path $PSScriptRoot -Filter "*.tmp" | ForEach-Object {
                $_.Delete();
            }
        }
    }
}