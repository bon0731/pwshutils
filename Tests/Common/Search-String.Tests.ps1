Import-Module "$PSScriptRoot/../../pwshutils.psm1" -Force;

Describe "基本検索処理" {
    It "マッチ行表示" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "aaa`nbbb`nccc`nddd`neee";
            $result = Search-String -Path $temp_file.FullName -Pattern "c";
            $result[0] | Should -Be "";
            $result[1] | Should -Be "[ $($temp_file.FullName) ]";
            $result[2] | Should -Be "";
            $result[3] | Should -Be " 00003 *: ccc";
        } finally {
            $temp_file.Delete();
        }
    }
    It "マッチ行表示（複数行マッチ）" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "aaa`nbbb`nccc`nddd`neee";
            $result = Search-String -Path $temp_file.FullName -Pattern "a|c|e";
            $result[0] | Should -Be "";
            $result[1] | Should -Be "[ $($temp_file.FullName) ]";
            $result[2] | Should -Be "";
            $result[3] | Should -Be " 00001 *: aaa";
            $result[4] | Should -Be " 00003 *: ccc";
            $result[5] | Should -Be " 00005 *: eee";
        } finally {
            $temp_file.Delete();
        }
    }
    It "マッチ行表示（大文字小文字区別）" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "Aaa`naAa`nAaA`naAa`naaA";
            $result = Search-String -Path $temp_file.FullName -Pattern "aAa" -CaseSensitive;
            $result[0] | Should -Be "";
            $result[1] | Should -Be "[ $($temp_file.FullName) ]";
            $result[2] | Should -Be "";
            $result[3] | Should -Be " 00002 *: aAa";
            $result[4] | Should -Be " 00004 *: aAa";
        } finally {
            $temp_file.Delete();
        }
    }
    It "前方行表示" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "aaa`nbbb`nccc`nddd`neee";
            $result = Search-String -Path $temp_file.FullName -Pattern "c" -Before 2;
            $result[0] | Should -Be "";
            $result[1] | Should -Be "[ $($temp_file.FullName) ]";
            $result[2] | Should -Be "";
            $result[3] | Should -Be " 00001  : aaa";
            $result[4] | Should -Be " 00002  : bbb";
            $result[5] | Should -Be " 00003 *: ccc";
        } finally {
            $temp_file.Delete();
        }
    }
    It "前方行表示（ファイル行数以上指定）" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "aaa`nbbb`nccc`nddd`neee";
            $result = Search-String -Path $temp_file.FullName -Pattern "c" -Before 100;
            $result[0] | Should -Be "";
            $result[1] | Should -Be "[ $($temp_file.FullName) ]";
            $result[2] | Should -Be "";
            $result[3] | Should -Be " 00001  : aaa";
            $result[4] | Should -Be " 00002  : bbb";
            $result[5] | Should -Be " 00003 *: ccc";
        } finally {
            $temp_file.Delete();
        }
    }
    It "後方行表示" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "aaa`nbbb`nccc`nddd`neee";
            $result = Search-String -Path $temp_file.FullName -Pattern "c" -After 2;
            $result[0] | Should -Be "";
            $result[1] | Should -Be "[ $($temp_file.FullName) ]";
            $result[2] | Should -Be "";
            $result[3] | Should -Be " 00003 *: ccc";
            $result[4] | Should -Be " 00004  : ddd";
            $result[5] | Should -Be " 00005  : eee";
        } finally {
            $temp_file.Delete();
        }
    }
    It "後方行表示（ファイル行数以上指定）" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "aaa`nbbb`nccc`nddd`neee";
            $result = Search-String -Path $temp_file.FullName -Pattern "c" -After 100;
            $result[0] | Should -Be "";
            $result[1] | Should -Be "[ $($temp_file.FullName) ]";
            $result[2] | Should -Be "";
            $result[3] | Should -Be " 00003 *: ccc";
            $result[4] | Should -Be " 00004  : ddd";
            $result[5] | Should -Be " 00005  : eee";
        } finally {
            $temp_file.Delete();
        }
    }
    It "前後行表示" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "aaa`nbbb`nccc`nddd`neee";
            $result = Search-String -Path $temp_file.FullName -Pattern "c" -Before 1 -After 2;
            $result[0] | Should -Be "";
            $result[1] | Should -Be "[ $($temp_file.FullName) ]";
            $result[2] | Should -Be "";
            $result[3] | Should -Be " 00002  : bbb";
            $result[4] | Should -Be " 00003 *: ccc";
            $result[5] | Should -Be " 00004  : ddd";
            $result[6] | Should -Be " 00005  : eee";
        } finally {
            $temp_file.Delete();
        }
    }
    It "前後行表示（複数行マッチ）" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "aaa`nbbb`nccc`nddd`neee";
            $result = Search-String -Path $temp_file.FullName -Pattern "a|c|e" -Before 1 -After 2;
            $result[0] | Should -Be "";
            $result[1] | Should -Be "[ $($temp_file.FullName) ]";
            $result[2] | Should -Be "";
            $result[3] | Should -Be " 00001 *: aaa";
            $result[4] | Should -Be " 00002  : bbb";
            $result[5] | Should -Be " 00003  : ccc";
            $result[6] | Should -Be "";
            $result[7] | Should -Be " 00002  : bbb";
            $result[8] | Should -Be " 00003 *: ccc";
            $result[9] | Should -Be " 00004  : ddd";
            $result[10] | Should -Be " 00005  : eee";
            $result[11] | Should -Be "";
            $result[12] | Should -Be " 00004  : ddd";
            $result[13] | Should -Be " 00005 *: eee";
        } finally {
            $temp_file.Delete();
        }
    }
    It "PathPattern複数ファイル" {
        try {
            $temp_file = New-TemporaryFile;
            $temp_dir = Split-Path -Path $temp_file.FullName -Parent;
            New-Item -Path "$temp_dir/test_dir" -ItemType Directory;
            Set-Content -Path "$temp_dir/test_dir/a.tmp" -Value "aaa`nbbb`nccc`nddd`neee";
            Set-Content -Path "$temp_dir/test_dir/b.tmp" -Value "aaa`nbbb`nccc`nddd`neee";
            $result = Search-String -Path "$temp_dir/test_dir" -PathPattern ".*tmp" -Pattern "c" -Before 1 -After 2;
            $result[0] | Should -Be "";
            $result[1] | Should -Be "[ $temp_dir/test_dir/a.tmp ]";
            $result[2] | Should -Be "";
            $result[3] | Should -Be " 00002  : bbb";
            $result[4] | Should -Be " 00003 *: ccc";
            $result[5] | Should -Be " 00004  : ddd";
            $result[6] | Should -Be " 00005  : eee";
            $result[7] | Should -Be "";
            $result[8] | Should -Be "[ $temp_dir/test_dir/b.tmp ]";
            $result[9] | Should -Be "";
            $result[10] | Should -Be " 00002  : bbb";
            $result[11] | Should -Be " 00003 *: ccc";
            $result[12] | Should -Be " 00004  : ddd";
            $result[13] | Should -Be " 00005  : eee";
        } finally {
            $temp_file.Delete();
            Remove-Item "$temp_dir/test_dir" -Recurse;
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
            $result[0] | Should -Be "";
            $result[1] | Should -Be "[ $($temp_file.FullName) ]";
            $result[2] | Should -Be "";
            $result[3] | Should -Be " 00002  : かきくけこ";
            $result[4] | Should -Be " 00003 *: さしすせそ";
            $result[5] | Should -Be " 00004  : たちつてと";
            $result[6] | Should -Be " 00005  : なにぬねの";
        } finally {
            $temp_file.Delete();
        }
    }
    It "UTF-8から検索" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "あいうえお`nかきくけこ`nさしすせそ`nたちつてと`nなにぬねの" -Encoding UTF8;
            $result = Search-String -Path $temp_file.FullName -Pattern "す" -Before 1 -After 2 -Encoding UTF-8;
            $result[0] | Should -Be "";
            $result[1] | Should -Be "[ $($temp_file.FullName) ]";
            $result[2] | Should -Be "";
            $result[3] | Should -Be " 00002  : かきくけこ";
            $result[4] | Should -Be " 00003 *: さしすせそ";
            $result[5] | Should -Be " 00004  : たちつてと";
            $result[6] | Should -Be " 00005  : なにぬねの";
        } finally {
            $temp_file.Delete();
        }
    }
    It "Unicodeから検索" {
        try {
            $temp_file = New-TemporaryFile;
            Set-Content -Path $temp_file.FullName -Value "あいうえお`nかきくけこ`nさしすせそ`nたちつてと`nなにぬねの" -Encoding Unicode;
            $result = Search-String -Path $temp_file.FullName -Pattern "す" -Before 1 -After 2 -Encoding Unicode;
            $result[0] | Should -Be "";
            $result[1] | Should -Be "[ $($temp_file.FullName) ]";
            $result[2] | Should -Be "";
            $result[3] | Should -Be " 00002  : かきくけこ";
            $result[4] | Should -Be " 00003 *: さしすせそ";
            $result[5] | Should -Be " 00004  : たちつてと";
            $result[6] | Should -Be " 00005  : なにぬねの";
        } finally {
            $temp_file.Delete();
        }
    }
}
Describe "パイプ処理" {
    It "パイプ入力" {
        # このテストスクリプト自体から検索
        $result = "$PSScriptRoot/Search-String.Tests.ps1" | Search-String -Pattern "パイプ入力";
        $result[0] | Should -Be "";
        $result[1] | Should -Be "[ $PSScriptRoot/Search-String.Tests.ps1 ]";
        $result[2] | Should -Be "";
        $result[3] | Should -Match ".*パイプ入力";
    }
}
Describe "例外" {
    It "Pathが存在しない" {
        try {
            $path = "not_found";
            Search-String -Path $path -Pattern "c";
            throw "";
        } catch {
            $_.Exception.Message | Should -Be "${path} が見つかりません。";
        }
    }
}