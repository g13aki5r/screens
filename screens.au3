#cs ----------------------------------------------------------------------------

 Author:
 јлексей ƒудин
 a.dudin@audiotele.ru

 Script Function:
 скрипт читает:
 каждый период времени в секундах положение курсора сравнивает с предыдущим значением,
 считает щелчки левой и правой кнопки мышки
 считает нажатие пробела и F5
 считает врем€ работы и непродуктива
 запоминает значени€ и вычисл€ет эффективность сотрудника
#ce ----------------------------------------------------------------------------

#NoTrayIcon
#include <Misc.au3> ; дл€ _IsPressed
#include <ScreenCapture.au3>
#include <Date.au3>

;Mouse&KB
Local $oxy[2] = [0, 0], $nxy[2] = [0, 0], $KM = 0, $KB = 0, $KMall = 0, $KBall = 0, $PWR = 0, $PWRall = 0
;Env
Local $nolog = 0, $flog, $capture_path, $hDLL = DllOpen("user32.dll"), $user = "", $flag = "", $effect = 0
;Time
Local $hTimer, $alltime = 0, $worktime = 0, $summertime = 0, $oldmin = @MIN, $whaittime = 60, $logtime = 5, $wSecs, $wMins, $wHours, $dSecs, $dMins, $dHours, $aHours, $aMins, $aSecs

$flog = "C:\temp\screenshot\"


Func _MyProcessExists($proc)
   Local $sRead
   $CMD_PId = Run(@ComSpec & ' /c tasklist  /fi "IMAGENAME eq ' & $proc & '" /fi "username eq %username%" /nh | find /I "' & $proc & '" /C', "C:\temp", @SW_HIDE, 0x2)

   While 1
	   $sBuffer = StdoutRead($CMD_PId)
	   If @error Then ExitLoop
	   If $sBuffer Then
		   $sRead &= $sBuffer
	   EndIf
	   Sleep(2)
   WEnd

   $sRead = StringLeft ( $sRead, 1 )
   If $sRead == 0 Or $sRead == 1 Or $sRead == 2 Then
	  Return $sRead
   Else
	  _Log_MyInfo( $flog, $sRead & ", " & VarGetType($sRead) & ", -->" & $sRead & "<--")
	  Return _MyProcessExists($proc)
   EndIf

EndFunc

If _MyProcessExists(@ScriptName) > 1 Then Exit ;~ «апрещаем множественный запуск

Func _Log_MyInfo($xlog, $myinfo, $mode = 1)
   If $nolog == 0 Then
	  $log = FileOpen($xlog, $mode)
	  If Not( $log == -1 ) Then
		 FileWriteLine ( $log, @HOUR & ":" & @MIN & ":" & @SEC & ";" & $myinfo )
		 FileClose($log)
	  EndIf
   EndIf
EndFunc

Func _ScreenMyCapture( $path )
   $capture_path = $path & "\" & @MDAY & "." & @MON & "." & @YEAR & "\" & @UserName
   If Not FileExists( $capture_path ) Then DirCreate( $capture_path )
   _ScreenCapture_Capture( $capture_path & "\" & @MDAY & "." & @MON & "." & @YEAR & "_" & @HOUR & "." & @MIN & "." & @SEC & "." &  @MSEC & "_" & @ComputerName & "_" & @UserName & ".jpg" )
EndFunc

While 1

   If _MyProcessExists("onexcui.exe") > 0  Then
	  $nxy = MouseGetPos()
	  $flag = 0

	  If _IsPressed("1", $hDLL) Or _IsPressed("2", $hDLL) Then
		 $flag = 1
	  EndIf

	  If _IsPressed("20", $hDLL) Or _IsPressed("74", $hDLL) Then
		 $flag = 1
	  EndIf

	  $nxy = MouseGetPos()
	  If $nxy[0] <> $oxy[0] Or $nxy[1] <> $oxy[1] Then
		 $flag = 1
	  EndIf

	  If $flag == 1 Then
		 _ScreenMyCapture( $flog )
		 Sleep( 300 )
	  Else
		 Sleep( 300 )
	  EndIf

	  $oxy = $nxy
   Else
	  Sleep( 1000 )
   EndIf

WEnd
