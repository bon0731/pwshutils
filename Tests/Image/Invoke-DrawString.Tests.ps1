Import-Module "$PSScriptRoot/../../pwshutils.psm1" -Force;

Describe "基本処理" {
    It "描画" {
        try {
            $temp_file = New-TemporaryFile;
            New-Image -Path $temp_file.FullName -Width 100 -Height 100;
            Invoke-DrawString -Path $temp_file.FullName -X 40 -Y 40 -Text "ABC" -FontSize 16 -R 0xFF -G 0xFF -B 0xFF -A 0x7F;
            Copy-Item -Path $temp_file.FullName -Destination "$PSScriptRoot/Outputs/DrawString_$(++$script:count;$script:count).bmp";
        } finally {
            $temp_file.Delete();
        }
    }
    It "パイプ入力" {
        try {
            $temp_file = New-TemporaryFile;
            New-Image -Path $temp_file.FullName -Width 100 -Height 100 -PassThru `
                | Invoke-DrawString -X 40 -Y 40 -Text "ABC" -FontSize 16 -R 0xFF -G 0xFF -B 0xFF -A 0x7F;
            Copy-Item -Path $temp_file.FullName -Destination "$PSScriptRoot/Outputs/DrawString_$(++$script:count;$script:count).bmp";
        } finally {
            $temp_file.Delete();
        }
    }
}
Describe "例外" {
    It "Pathが存在しない" {
        try {
            $path = "not_found";
            Invoke-DrawString -Path $path -X 40 -Y 40 -Text "ABC" -FontSize 16 -R 0xFF -G 0xFF -B 0xFF -A 0x7F;
            throw "";
        } catch {
            $_.Exception.Message | Should -Be "${path} が見つかりません。";
        }
    }
}
