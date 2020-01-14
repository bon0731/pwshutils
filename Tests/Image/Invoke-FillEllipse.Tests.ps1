Import-Module "$PSScriptRoot/../../pwshutils.psm1" -Force;
. "$PSScriptRoot/../../Private/Resource/Get-ErrorMessage.ps1";

Describe "基本処理" {
    It "描画" {
        try {
            $temp_file = New-TemporaryFile;
            New-Image -Path $temp_file.FullName -Width 100 -Height 100;
            Invoke-FillEllipse -Path $temp_file.FullName -Left 0 -Top 0 -Width 100 -Height 100 -R 0xFF -G 0xFF -B 0xFF -A 0x7F;
            Copy-Item -Path $temp_file.FullName -Destination "$PSScriptRoot/Outputs/FillEllipse_$(++$script:count;$script:count).bmp";
        } finally {
            $temp_file.Delete();
        }
    }
    It "パイプ入力" {
        try {
            $temp_file = New-TemporaryFile;
            New-Image -Path $temp_file.FullName -Width 100 -Height 100 -PassThru `
                | Invoke-FillEllipse -Left 0 -Top 0 -Width 100 -Height 100 -R 0xFF -G 0xFF -B 0xFF -A 0x7F;
            Copy-Item -Path $temp_file.FullName -Destination "$PSScriptRoot/Outputs/FillEllipse_$(++$script:count;$script:count).bmp";
        } finally {
            $temp_file.Delete();
        }
    }
}
Describe "例外" {
    It "Pathが存在しない" {
        try {
            $path = "not_found";
            Invoke-FillEllipse -Path $path -Left 0 -Top 0 -Width 100 -Height 100 -R 0xFF -G 0xFF -B 0xFF -A 0x7F;
            throw "";
        } catch {
            $_.Exception.Message | Should -Be (Get-ErrorMessage -Code NOT_FOUND -Params @($Path));
        }
    }
}