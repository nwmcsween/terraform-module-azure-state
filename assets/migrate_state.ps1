if (!$env:TF_BACKEND_CONFIG_FILENAME) {
    Write-Error "Environment variable TF_BACKEND_CONFIG_FILENAME is not set!"
    exit 1
}

if (!$env:TF_WORK_DIR) {
    Write-Error "Environment variable TF_WORK_DIR is not set!"
    exit 1
}

$env:TF_PPID = (Get-CimInstance -className win32_process | Where-Object { $_.ProcessId -eq $PID } | Select-Object -ExpandProperty ParentProcessId)
$Script = {
    Wait-Process -Id $env:TF_PPID -ErrorAction Ignore # We ignore in case terraform has exited already.
    & terraform init -migrate-state -force-copy -backend-config="""$env:TF_BACKEND_CONFIG_FILENAME"""
}

Start-Process powershell -ArgumentList "-NoProfile -NoLogo -NoExit -Command (Invoke-Command -ScriptBlock { $script })" -WorkingDirectory $env:TF_WORK_DIR -NoNewWindow

exit 0