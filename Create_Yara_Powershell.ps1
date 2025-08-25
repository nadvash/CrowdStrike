$OutputPath = "C:\Windows\Temp\yara_rule.yar"

$YaraRule = @'
rule detect_echo_hello_world {
    strings:
        $echo_hello = "echo hello world"
    condition:
        $echo_hello
}
'@

Set-Content -Path $OutputPath -Value $YaraRule -Encoding ASCII
