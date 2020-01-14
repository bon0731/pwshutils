function Get-ErrorMessage() {
    param($Code, $Params)

    $message = switch($Code) {
        NOT_FOUND {{ "$($Args[0]) が見つかりません。" }}
        REQUIRED_OR {{ "$($Args -join "、") のいずれかを指定してください。" }}
        NEED_DIRECTORY {{ "$($Args[0]) にはディレクトリを指定してください。" }}
    }

    return $message.Invoke($Params);
}