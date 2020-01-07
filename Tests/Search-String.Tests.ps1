Import-Module "$PSScriptRoot/../pwshutils.psm1" -Force;

Describe "基本検索処理" {
    It "マッチ行表示" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "aaa`nbbb`nccc`nddd`neee";
            $result = Search-String -Path $temp_file.FullName -Pattern "c";
            $result | Should -Be "$($temp_file.FullName) 00003 *: ccc";
        } finally {
            $temp_file.Delete();
        }
    }
    It "前方行表示" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "aaa`nbbb`nccc`nddd`neee";
            $result = Search-String -Path $temp_file.FullName -Pattern "c" -Before 2;
            $result[0] | Should -Be "$($temp_file.FullName) 00001  : aaa";
            $result[1] | Should -Be "$($temp_file.FullName) 00002  : bbb";
            $result[2] | Should -Be "$($temp_file.FullName) 00003 *: ccc";
        } finally {
            $temp_file.Delete();
        }
    }
    It "前方行表示（ファイル行数以上指定）" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "aaa`nbbb`nccc`nddd`neee";
            $result = Search-String -Path $temp_file.FullName -Pattern "c" -Before 100;
            $result[0] | Should -Be "$($temp_file.FullName) 00001  : aaa";
            $result[1] | Should -Be "$($temp_file.FullName) 00002  : bbb";
            $result[2] | Should -Be "$($temp_file.FullName) 00003 *: ccc";
        } finally {
            $temp_file.Delete();
        }
    }
    It "後方行表示" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "aaa`nbbb`nccc`nddd`neee";
            $result = Search-String -Path $temp_file.FullName -Pattern "c" -After 2;
            $result[0] | Should -Be "$($temp_file.FullName) 00003 *: ccc";
            $result[1] | Should -Be "$($temp_file.FullName) 00004  : ddd";
            $result[2] | Should -Be "$($temp_file.FullName) 00005  : eee";
        } finally {
            $temp_file.Delete();
        }
    }
    It "後方行表示（ファイル行数以上指定）" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "aaa`nbbb`nccc`nddd`neee";
            $result = Search-String -Path $temp_file.FullName -Pattern "c" -After 2;
            $result[0] | Should -Be "$($temp_file.FullName) 00003 *: ccc";
            $result[1] | Should -Be "$($temp_file.FullName) 00004  : ddd";
            $result[2] | Should -Be "$($temp_file.FullName) 00005  : eee";
        } finally {
            $temp_file.Delete();
        }
    }
    It "前後行表示" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "aaa`nbbb`nccc`nddd`neee";
            $result = Search-String -Path $temp_file.FullName -Pattern "c" -Before 1 -After 2;
            $result[0] | Should -Be "$($temp_file.FullName) 00002  : bbb";
            $result[1] | Should -Be "$($temp_file.FullName) 00003 *: ccc";
            $result[2] | Should -Be "$($temp_file.FullName) 00004  : ddd";
            $result[3] | Should -Be "$($temp_file.FullName) 00005  : eee";
        } finally {
            $temp_file.Delete();
        }
    }
}
Describe "出力フォーマット" {
    It "フォーマット変更" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "aaa`nbbb`nccc`nddd`neee";
            $result = Search-String -Path $temp_file.FullName -Pattern "c" -Before 1 -After 2 -Writer {
                param($info)
                Write-Output "$($info.LineNumber)行目 : $($info.Line) $($info.MatchLineDistance)";
            };
            $result[0] | Should -Be "2行目 : bbb -1";
            $result[1] | Should -Be "3行目 : ccc 0";
            $result[2] | Should -Be "4行目 : ddd 1";
            $result[3] | Should -Be "5行目 : eee 2";
        } finally {
            $temp_file.Delete();
        }
    }
}
Describe "エンコード" {
    It "SJISから検索" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "あいうえお`nかきくけこ`nさしすせそ`nたちつてと`nなにぬねの" -Encoding SJIS;
            $result = Search-String -Path $temp_file.FullName -Pattern "す" -Before 1 -After 2 -Encoding SJIS;
            $result[0] | Should -Be "$($temp_file.FullName) 00002  : かきくけこ";
            $result[1] | Should -Be "$($temp_file.FullName) 00003 *: さしすせそ";
            $result[2] | Should -Be "$($temp_file.FullName) 00004  : たちつてと";
            $result[3] | Should -Be "$($temp_file.FullName) 00005  : なにぬねの";
        } finally {
            $temp_file.Delete();
        }
    }
    It "UTF-8から検索" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "あいうえお`nかきくけこ`nさしすせそ`nたちつてと`nなにぬねの" -Encoding UTF8;
            $result = Search-String -Path $temp_file.FullName -Pattern "す" -Before 1 -After 2 -Encoding UTF-8;
            $result[0] | Should -Be "$($temp_file.FullName) 00002  : かきくけこ";
            $result[1] | Should -Be "$($temp_file.FullName) 00003 *: さしすせそ";
            $result[2] | Should -Be "$($temp_file.FullName) 00004  : たちつてと";
            $result[3] | Should -Be "$($temp_file.FullName) 00005  : なにぬねの";
        } finally {
            $temp_file.Delete();
        }
    }
    It "Unicodeから検索" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "あいうえお`nかきくけこ`nさしすせそ`nたちつてと`nなにぬねの" -Encoding Unicode;
            $result = Search-String -Path $temp_file.FullName -Pattern "す" -Before 1 -After 2 -Encoding Unicode;
            $result[0] | Should -Be "$($temp_file.FullName) 00002  : かきくけこ";
            $result[1] | Should -Be "$($temp_file.FullName) 00003 *: さしすせそ";
            $result[2] | Should -Be "$($temp_file.FullName) 00004  : たちつてと";
            $result[3] | Should -Be "$($temp_file.FullName) 00005  : なにぬねの";
        } finally {
            $temp_file.Delete();
        }
    }
}
Describe "パイプ処理" {
    It "パイプ入力" {
        # このテストスクリプト自体から検索
        $result = Get-ChildItem $PSScriptRoot | Search-String -Pattern "パイプ入力";
        $result[0] | Should -Match ".*パイプ入力";
    }
}
Describe "例外" {
    It "Path、PathPattern両方未指定" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "aaa`nbbb`nccc`nddd`neee";
            Search-String -Pattern "c";
            throw "";
        } catch {
            $_.Exception.Message | Should -Be "-Path または -PathPattern パラメータは必須です。";
        } finally {
            $temp_file.Delete();
        }
    }
}