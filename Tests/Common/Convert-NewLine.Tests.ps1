Import-Module "$PSScriptRoot/../../pwshutils.psm1" -Force;

Describe "基本変換処理" {
    @("SJIS", "UTF-8", "UTF-16BE", "UTF-16LE", "UTF-32BE", "UTF-32LE") | ForEach-Object {
        # Set-Contentが勝手に付加する末尾改行は消して比較する
        It "$_ CRLF => LF" {
            try {
                $temp_file = New-TemporaryFile;
                Set-Content -Path $temp_file.FullName -Value "あいうえお`r`nかきくけこ`r`nさしすせそ" -Encoding ([System.Text.Encoding]::GetEncoding($_));
                Convert-NewLine -Path $temp_file.FullName -Encoding $_ -LF;
                (Get-Content -Path $temp_file.FullName -Encoding ([System.Text.Encoding]::GetEncoding($_)) -Raw).TrimEnd(@("`r","`n")) | Should -Be "あいうえお`nかきくけこ`nさしすせそ";
            } finally {
                $temp_file.Delete();
            }
        }
        It "$_ LF => CRLF" {
            try {
                $temp_file = New-TemporaryFile;
                Set-Content -Path $temp_file.FullName -Value "あいうえお`nかきくけこ`nさしすせそ" -Encoding ([System.Text.Encoding]::GetEncoding($_));
                Convert-NewLine -Path $temp_file.FullName -Encoding $_ -CRLF;
                (Get-Content -Path $temp_file.FullName -Encoding ([System.Text.Encoding]::GetEncoding($_)) -Raw).TrimEnd(@("`r","`n")) | Should -Be "あいうえお`r`nかきくけこ`r`nさしすせそ";
            } finally {
                $temp_file.Delete();
            }
        }
        It "$_ CRLF => LF （パイプ入力）" {
            try {
                $temp_file = New-TemporaryFile;
                Set-Content -Path $temp_file.FullName -Value "あいうえお`r`nかきくけこ`r`nさしすせそ" -Encoding ([System.Text.Encoding]::GetEncoding($_));
                $temp_file.FullName | Convert-NewLine -Encoding $_ -LF;
                (Get-Content -Path $temp_file.FullName -Encoding ([System.Text.Encoding]::GetEncoding($_)) -Raw).TrimEnd(@("`r","`n")) | Should -Be "あいうえお`nかきくけこ`nさしすせそ";
            } finally {
                $temp_file.Delete();
            }
        }
        It "$_ LF => CRLF （パイプ入力）" {
            try {
                $temp_file = New-TemporaryFile;
                Set-Content -Path $temp_file.FullName -Value "あいうえお`nかきくけこ`nさしすせそ" -Encoding ([System.Text.Encoding]::GetEncoding($_));
                $temp_file.FullName | Convert-NewLine -Encoding $_ -CRLF;
                (Get-Content -Path $temp_file.FullName -Encoding ([System.Text.Encoding]::GetEncoding($_)) -Raw).TrimEnd(@("`r","`n")) | Should -Be "あいうえお`r`nかきくけこ`r`nさしすせそ";
            } finally {
                $temp_file.Delete();
            }
        }
    }
}
Describe "例外" {
    It "引数不足" {
        try {
            $path = "$PSScriptRoot/not_found.tmp";
            Convert-NewLine -Path $path;
            throw "";
        } catch {
            $_.Exception.Message | Should -Be "-CRLF、-LF のいずれかを指定してください。";
        }
    }
    It "ファイルがない" {
        try {
            $path = "$PSScriptRoot/not_found.tmp";
            Convert-NewLine -Path $path -CRLF;
            throw "";
        } catch {
            $_.Exception.Message | Should -Be "${path} が見つかりません。";
        }
    }
}