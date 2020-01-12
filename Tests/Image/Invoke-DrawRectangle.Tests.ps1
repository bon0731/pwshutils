Import-Module "$PSScriptRoot/../../pwshutils.psm1" -Force;

Describe "基本処理" {
    It "描画" {
        try {
            $temp_file = New-TemporaryFile;
            New-Image -Path $temp_file.FullName -Width 100 -Height 100;
            Invoke-DrawRectangle -Path $temp_file.FullName -Left 25 -Top 15 -Width 50 -Height 70 -R 0xFF -G 0xFF -B 0xFF -A 0x7F -LineWidth 5;
            Copy-Item -Path $temp_file.FullName -Destination "$PSScriptRoot/Outputs/DrawRectangle_$(++$script:count;$script:count).bmp";
        } finally {
            $temp_file.Delete();
        }
    }
    It "パイプ入力" {
        try {
            $temp_file = New-TemporaryFile;
            New-Image -Path $temp_file.FullName -Width 100 -Height 100 -PassThru `
                | Invoke-DrawRectangle -Left 25 -Top 15 -Width 50 -Height 70 -R 0xFF -G 0xFF -B 0xFF -A 0x7F -LineWidth 5;
            Copy-Item -Path $temp_file.FullName -Destination "$PSScriptRoot/Outputs/DrawRectangle_$(++$script:count;$script:count).bmp";
        } finally {
            $temp_file.Delete();
        }
    }
}
Describe "例外" {
    It "Pathが存在しない" {
        try {
            $path = "not_found";
            Invoke-DrawRectangle -Path $path -Left 25 -Top 15 -Width 50 -Height 70 -R 0xFF -G 0xFF -B 0xFF -A 0x7F -LineWidth 5;
            throw "";
        } catch {
            $_.Exception.Message | Should -Be "${path} が見つかりません。";
        }
    }
}