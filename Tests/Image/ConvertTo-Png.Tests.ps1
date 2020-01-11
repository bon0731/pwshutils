Import-Module "$PSScriptRoot/../../pwshutils.psm1" -Force;

Describe "基本処理" {
    It "変換" {
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
            New-Image -Path $temp_file.FullName -Width 100 -Height 100 -PassThru | ConvertTo-Png;
            "Png" | Should -Be (Get-ImageFormat -Path $temp_file.FullName);
        } finally {
            $temp_file.Delete();
        }
    }
}
Describe "例外" {
    It "Pathが存在しない" {
        try {
            $path = "not_found";
            ConvertTo-Png -Path $path;
            throw "";
        } catch {
            $_.Exception.Message | Should -Be "${path} が見つかりません。";
        }
    }
}