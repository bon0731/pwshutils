Import-Module "$PSScriptRoot/../../pwshutils.psm1" -Force;

Describe "基本変換処理" {
    @(
        @{From="SJIS"; To="UTF-8"},
        @{From="SJIS"; To="UTF-16BE"},
        @{From="SJIS"; To="UTF-16LE"},
        @{From="UTF-8"; To="SJIS"},
        @{From="UTF-8"; To="UTF-16BE"},
        @{From="UTF-8"; To="UTF-16LE"},
        @{From="UTF-16BE"; To="SJIS"},
        @{From="UTF-16BE"; To="UTF-8"},
        @{From="UTF-16BE"; To="UTF-16LE"},
        @{From="UTF-16LE"; To="SJIS"},
        @{From="UTF-16LE"; To="UTF-8"},
        @{From="UTF-16LE"; To="UTF-16BE"}
    ) | ForEach-Object {
        # Set-Contentが勝手に付加する末尾改行は消して比較する
        It "$($_["From"]) => $($_["To"])" {
            try {
                $temp_file = New-TemporaryFile;
                Set-Content -Path $temp_file.FullName -Value "あいうえお`r`nかきくけこ`r`nさしすせそ" -Encoding ([System.Text.Encoding]::GetEncoding($_["From"]));
                Convert-Encoding -Path $temp_file.FullName -From $_["From"] -To $_["To"];
                (Get-Content -Path $temp_file.FullName -Encoding ([System.Text.Encoding]::GetEncoding($_["To"])) -Raw).TrimEnd(@("`r","`n")) | Should -Be "あいうえお`r`nかきくけこ`r`nさしすせそ";
            } finally {
                $temp_file.Delete();
            }
        }
        It "$($_["From"]) => $($_["To"]) （パイプ入力）" {
            try {
                $temp_file = New-TemporaryFile;
                Set-Content -Path $temp_file.FullName -Value "あいうえお`r`nかきくけこ`r`nさしすせそ" -Encoding ([System.Text.Encoding]::GetEncoding($_["From"]));
                $temp_file.FullName | Convert-Encoding -From $_["From"] -To $_["To"];
                (Get-Content -Path $temp_file.FullName -Encoding ([System.Text.Encoding]::GetEncoding($_["To"])) -Raw).TrimEnd(@("`r","`n")) | Should -Be "あいうえお`r`nかきくけこ`r`nさしすせそ";
            } finally {
                $temp_file.Delete();
            }
        }
        It "$($_["From"]) => $($_["To"]) （改行コードCRLF）" {
            try {
                $temp_file = New-TemporaryFile;
                Set-Content -Path $temp_file.FullName -Value "あいうえお`nかきくけこ`nさしすせそ" -Encoding ([System.Text.Encoding]::GetEncoding($_["From"]));
                Convert-Encoding -Path $temp_file.FullName -From $_["From"] -To $_["To"] -CRLF;
                (Get-Content -Path $temp_file.FullName -Encoding ([System.Text.Encoding]::GetEncoding($_["To"])) -Raw).TrimEnd(@("`r","`n")) | Should -Be "あいうえお`r`nかきくけこ`r`nさしすせそ";
            } finally {
                $temp_file.Delete();
            }
        }
        It "$($_["From"]) => $($_["To"]) （改行コードLF）" {
            try {
                $temp_file = New-TemporaryFile;
                Set-Content -Path $temp_file.FullName -Value "あいうえお`r`nかきくけこ`r`nさしすせそ" -Encoding ([System.Text.Encoding]::GetEncoding($_["From"]));
                Convert-Encoding -Path $temp_file.FullName -From $_["From"] -To $_["To"] -LF;
                (Get-Content -Path $temp_file.FullName -Encoding ([System.Text.Encoding]::GetEncoding($_["To"])) -Raw).TrimEnd(@("`r","`n")) | Should -Be "あいうえお`nかきくけこ`nさしすせそ";
            } finally {
                $temp_file.Delete();
            }
        }
    }
}
Describe "例外" {
    It "ファイルがない" {
        try {
            $path = "$PSScriptRoot/not_found.tmp";
            Convert-Encoding -Path $path -From UTF-8 -To UTF-8;
            throw "";
        } catch {
            $_.Exception.Message | Should -Be "${path} が見つかりません。";
        }
    }
}