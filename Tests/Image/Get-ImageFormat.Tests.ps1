Import-Module "$PSScriptRoot/../../pwshutils.psm1" -Force;
. "$PSScriptRoot/../../Private/Resource/Get-ErrorMessage.ps1";

Describe "基本処理" {
    It "Bmp" {
        try {
            $temp_file = New-TemporaryFile;
            New-Image -Path $temp_file.FullName -Width 100 -Height 100;
            "Bmp" | Should -Be (Get-ImageFormat -Path $temp_file.FullName);
        } finally {
            $temp_file.Delete();
        }
    }
    It "Jpeg" {
        try {
            $temp_file = New-TemporaryFile;
            New-Image -Path $temp_file.FullName -Width 100 -Height 100;
            ConvertTo-Jpeg -Path $temp_file.FullName;
            "Jpeg" | Should -Be (Get-ImageFormat -Path $temp_file.FullName);
        } finally {
            $temp_file.Delete();
        }
    }
    It "Png" {
        try {
            $temp_file = New-TemporaryFile;
            New-Image -Path $temp_file.FullName -Width 100 -Height 100;
            ConvertTo-Png -Path $temp_file.FullName;
            "Png" | Should -Be (Get-ImageFormat -Path $temp_file.FullName);
        } finally {
            $temp_file.Delete();
        }
    }
    It "パイプ入力" {
        try {
            $temp_file = New-TemporaryFile;
            $actual = New-Image -Path $temp_file.FullName -Width 100 -Height 100 -PassThru | ConvertTo-Jpeg -PassThru | Get-ImageFormat;
            "Jpeg" | Should -Be $actual;
        } finally {
            $temp_file.Delete();
        }
    }
}
Describe "例外" {
    It "Pathが存在しない" {
        try {
            $path = "not_found";
            ConvertTo-Jpeg -Path $path;
            throw "";
        } catch {
            $_.Exception.Message | Should -Be (Get-ErrorMessage -Code NOT_FOUND -Params @($Path));
        }
    }
}