Import-Module "$PSScriptRoot/../../pwshutils.psm1" -Force;
. "$PSScriptRoot/../../Private/Resource/Get-ErrorMessage.ps1";

Describe "正常系" {
    It "Ctrl+C で停止する必要があるため割愛する" {
        $true | Should -Be $true;
    }
}
Describe "例外" {
    It "Pathが存在しない" {
        try {
            $path = "not_found";
            Watch-Directory -Path $path -ScriptBlock {};
            throw "";
        } catch {
            $_.Exception.Message | Should -Be (Get-ErrorMessage -Code NOT_FOUND -Params @($Path));
        }
    }
    It "Pathがファイル" {
        try {
            $temp_file = New-TemporaryFile;
            Watch-Directory -Path $path -ScriptBlock {};
            throw "";
        } catch {
            $_.Exception.Message | Should -Be (Get-ErrorMessage -Code NEED_DIRECTORY -Params @("-Path"));
        } finally {
            $temp_file.Delete();
        }
    }
}