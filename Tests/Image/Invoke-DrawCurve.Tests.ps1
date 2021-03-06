Import-Module "$PSScriptRoot/../../pwshutils.psm1" -Force;
. "$PSScriptRoot/../../Private/Resource/Get-ErrorMessage.ps1";

Describe "基本処理" {
    It "描画" {
        try {
            $temp_file = New-TemporaryFile;
            New-Image -Path $temp_file.FullName -Width 100 -Height 100;
            Invoke-DrawCurve -Path $temp_file.FullName -Points @(
                @{x=20;y=20};
                @{x=80;y=30};
                @{x=30;y=40};
                @{x=70;y=50};
                @{x=40;y=60};
                @{x=60;y=70};
                @{x=50;y=80};
            ) -R 0xFF -G 0xFF -B 0xFF -A 0x7F -LineWidth 5;
            Copy-Item -Path $temp_file.FullName -Destination "$PSScriptRoot/Outputs/DrawCurve_$(++$script:count;$script:count).bmp";
        } finally {
            $temp_file.Delete();
        }
    }
    It "パイプ入力" {
        try {
            $temp_file = New-TemporaryFile;
            New-Image -Path $temp_file.FullName -Width 100 -Height 100 -PassThru `
                | Invoke-DrawCurve -Points @(
                    @{x=20;y=20};
                    @{x=80;y=30};
                    @{x=30;y=40};
                    @{x=70;y=50};
                    @{x=40;y=60};
                    @{x=60;y=70};
                    @{x=50;y=80};
                ) -R 0xFF -G 0xFF -B 0xFF -A 0x7F -LineWidth 5;
            Copy-Item -Path $temp_file.FullName -Destination "$PSScriptRoot/Outputs/DrawCurve_$(++$script:count;$script:count).bmp";
        } finally {
            $temp_file.Delete();
        }
    }
}
Describe "例外" {
    It "Pathが存在しない" {
        try {
            $path = "not_found";
            Invoke-DrawCurve -Path $path -Points @(
                @{x=20;y=20};
                @{x=80;y=30};
                @{x=30;y=40};
                @{x=70;y=50};
                @{x=40;y=60};
                @{x=60;y=70};
                @{x=50;y=80};
            ) -R 0xFF -G 0xFF -B 0xFF -A 0x7F -LineWidth 5;
            throw "";
        } catch {
            $_.Exception.Message | Should -Be (Get-ErrorMessage -Code NOT_FOUND -Params @($Path));
        }
    }
}