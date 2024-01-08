#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=ICONS\Skull.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Adobe-GenP-3.0.3
#AutoIt3Wrapper_Res_Description=Adobe-GenP-3.0.3
#AutoIt3Wrapper_Res_Fileversion=3.0.3.0
#AutoIt3Wrapper_Res_ProductName=Adobe-GenP
#AutoIt3Wrapper_Res_ProductVersion=3.0.3
#AutoIt3Wrapper_Res_CompanyName=uncia
#AutoIt3Wrapper_Res_LegalCopyright=uncia
#AutoIt3Wrapper_Res_LegalTradeMarks=uncia
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****


#include <AdobeStringRegExpPatterns.au3>
#include <WinAPIConstants.au3>
#include <File.au3>
#include <array.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>
#include <FileConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GuiEdit.au3>
#include <GuiButton.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <WinAPIProc.au3>
#include <WinAPISys.au3>
#include <GDIPlus.au3>
#include <WM_NOTIFY.au3>
#include <GuiStatusBar.au3>
#include <GuiImageList.au3>
#include <GuiScrollBars.au3>


AutoItSetOption ("TrayAutoPause", 0)
AutoItSetOption ("TrayIconHide", 1)
AutoItSetOption ("GUICloseOnESC", 1) ;1=ESC  closes, 0=ESC won't close
HotKeySet("{ESC}", "ShowEscMessage")

Global Const $g_AppWndTitle = "Adobe-GenP-3.0.3"

If _Singleton($g_AppWndTitle, 1) = 0 Then
    Exit
EndIf


FileDelete(@TempDir&"\RunFromToken32.exe")
FileDelete(@TempDir&"\RunFromToken64.exe")








Global $g_hGraphics, $g_hBitmap, $g_hGfxCtxt, $g_hPen , $MyLVGroupIsExpanded=1


	Global $Dlg_Margin = 24
	Global $Dlg_DeltaMarginRight = 6
	Global $Dlg_Width = 746
	Global $Dlg_Height = $Dlg_Width*1.16
	Global $BT_Width  =	80
	Global $BT_Height =  24
	Global $Dlg_ListViewWidth = $Dlg_Width-$Dlg_Margin*2-$Dlg_DeltaMarginRight




Global $FilesToPatch[0][1],$FilesToPatchNull[0][1]
Global $FilesToRestore[0][1]
Global $MyhGUI,$idMsg,$idListview,$g_idListview,$idButton_Search,$idButtonCustomFolder,$idBtnCure,$idBtnDeselectAll,$ListViewSelectFlag=1,$idBtnChillMode,$timestamp
Global $MyDefPath = "C:\Program Files"

Global $MyRegExpGlobalPatternSearchCount=0 ,$Count=0 , $MyOwnidProgress
Global $aOutHexGlobalArray[0],$aNullArray[0], $aInHexArray[0]
Global	$MyFileToParse = "" ,$MyFileToParsSweatPea= "",$MyFileToParseEaclient= ""


MainGui()

WinWait($g_AppWndTitle, "",5)
$hWndParentWindow = WinGetHandle($g_AppWndTitle)
$hWnd_Progress = ControlGetHandle($hWndParentWindow,"","msctls_progress321")


	While 1
		$idMsg = GUIGetMsg()

		Select
			Case $idMsg = $GUI_EVENT_CLOSE
				ShowEscMessage()


            Case $idMsg = $idButton_Search
				GUICtrlSetState ($idBtnDeselectAll, 128 )
				GUICtrlSetState ($idBtnChillMode, 128 )
				GUICtrlSetState ($idListview, 128 )
				GUICtrlSetState ($idButton_Search, 128 )
				GUICtrlSetState ($idBtnCure, 128 )
				GUICtrlSetState ($idButtonCustomFolder,128)
				;Search through all files and folders in directory and fill ListView
				_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($idListview))
				_GUICtrlListView_SetExtendedListViewStyle($idListview, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_DOUBLEBUFFER))
				_GUICtrlListView_AddItem($idListview, "", 0)
				_GUICtrlListView_AddItem($idListview, "", 1)
				_GUICtrlListView_AddItem($idListview, "", 2)
				_GUICtrlListView_AddItem($idListview, "", 2)

				_GUICtrlListView_RemoveAllGroups($idListview)
				_GUICtrlListView_InsertGroup($idListview, -1, 1, "",1) ; Group 1
				_GUICtrlListView_SetGroupInfo ( $idListview, 1, "Info" , 1 , $LVGS_COLLAPSIBLE )


				_GUICtrlListView_AddSubItem($idListview, 0, "", 1)
				_GUICtrlListView_AddSubItem($idListview, 1, "Preparing...", 1)
				_GUICtrlListView_AddSubItem($idListview, 2, "", 1)
				_GUICtrlListView_AddSubItem($idListview, 3, "Be patient, please.", 1)
				_GUICtrlListView_SetItemGroupID($idListview, 0, 1)
				_GUICtrlListView_SetItemGroupID($idListview, 1, 1)
				_GUICtrlListView_SetItemGroupID($idListview, 2, 1)
				_GUICtrlListView_SetItemGroupID($idListview, 3, 1)

				_Expand_All_Click()
				_GUICtrlListView_SetGroupInfo ( $idListview, 1, "Info" , 1,$LVGS_COLLAPSIBLE )


				; Clear previous results
				$FilesToPatch   = $FilesToPatchNULL
				$FilesToRestore = $FilesToPatchNULL

				$timestamp = TimerInit()

				Local $aSize = DirGetSize($MyDefPath, $DIR_EXTENDED) ; extended mode
				local $FileCount= $ASIZE[1]

				Global $ProgressFileCountScale = 100 / $FileCount
				Global $FileSearchedCount = 0

				ProgressWrite(0)
				RecursiveFileSearch($MyDefPath,0,$aSize[1]) ;Search through all files and folders
				Sleep(100)
				ProgressWrite(0)


				_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($idListview))

				FillListViewWithFiles()

				If _GUICtrlListView_GetItemCount($idListview)>0 Then

					_Assign_Groups_To_Found_Files()

					$ListViewSelectFlag=1 ; Set Flag to Selected State
					GUICtrlSetState ($idButton_Search, 128 )
					GUICtrlSetState ($idBtnCure, 64 )
					GUICtrlSetState ($idBtnCure,256) ; Set focus
				Else
					$ListViewSelectFlag=0 ; Set Flag to Deselected State
					FillListViewWithInfo ()
					GUICtrlSetState ($idBtnCure, 128 )
					GUICtrlSetState ($idButton_Search,256) ; Set focus
				EndIf

					;_Collapse_All_Click()
					_Expand_All_Click()

				GUICtrlSetState ($idBtnDeselectAll, 64 )
				GUICtrlSetState ($idBtnChillMode, 64 )
				GUICtrlSetState ($idListview, 64 )
				GUICtrlSetState ($idButton_Search, 64 )
				GUICtrlSetState ($idButtonCustomFolder,64)



            Case $idMsg = $idButtonCustomFolder ; Select Custom Path

				MyFileOpenDialog()
					_Expand_All_Click()

				GUICtrlSetState ($idButton_Search,256) ; Set focus

            Case $idMsg = $idBtnDeselectAll ; Deselect-Select  All
				If $ListViewSelectFlag=1 Then
					For $iI = 0 To _GUICtrlListView_GetItemCount($idListview) - 1
						_GUICtrlListView_SetItemChecked($idListview, $iI,0)
					Next
					$ListViewSelectFlag=0 ; Set Flag to Deselected State
				Else
					For $iI = 0 To _GUICtrlListView_GetItemCount($idListview) - 1
						_GUICtrlListView_SetItemChecked($idListview, $iI,1)
					Next
					$ListViewSelectFlag=1 ; Set Flag to Selected State
				EndIf


            Case $idMsg = $idBtnChillMode ; Patternes Editor button
						ChillMode()

            Case $idMsg = $idBtnCure

				GUICtrlSetState ($idListview, 128 )
				GUICtrlSetState ($idBtnDeselectAll, 128 )
				GUICtrlSetState ($idButton_Search, 128 )
				GUICtrlSetState ($idBtnCure, 128 )
				GUICtrlSetState ($idBtnChillMode, 128 )
				GUICtrlSetState ($idButtonCustomFolder,128)
									_Expand_All_Click()
				;_GUICtrlListView_Scroll($idListview, 0, -10000)
				_GUICtrlListView_EnsureVisible($idListview, 0,0)

				For $iI = 0 To _GUICtrlListView_GetItemCount($idListview) - 1


					If _GUICtrlListView_GetItemChecked($idListview, $iI) = True Then

					_GUICtrlListView_SetItemSelected($idListview, $iI)
						Local $ItemFromList = _GUICtrlListView_GetItemText($idListview, $iI,1)

							MyGlobalPatternSearch($ItemFromList)
							ProgressWrite(0)
							Sleep(100)
							MemoWrite(@CRLF & "Path" & @CRLF  & "---" & @CRLF & $ItemFromList & @CRLF & "---" & @CRLF & "medication :)")
							Sleep(100)

							MyGlobalPatternPatch(_GUICtrlListView_GetItemText($idListview, $iI,1),$aOutHexGlobalArray)
							; Scroll control 10 pixels - 1 line
							_GUICtrlListView_Scroll($idListview, 0, 10)
							_GUICtrlListView_EnsureVisible($idListview, $iI,0)
							Sleep(100)

					EndIf

					_GUICtrlListView_SetItemChecked($idListview, $iI,False)
				Next

				_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($idListview))
				_GUICtrlListView_SetExtendedListViewStyle($idListview, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_DOUBLEBUFFER))


				_GUICtrlListView_RemoveAllGroups($idListview)
				_GUICtrlListView_InsertGroup($idListview, -1, 1, "",1) ; Group 1
				_GUICtrlListView_SetGroupInfo ( $idListview, 1, "Info" , 1 , $LVGS_COLLAPSIBLE )


				MemoWrite(@CRLF & "Path" & @CRLF & "---" & @CRLF & $MyDefPath & @CRLF & "---" & @CRLF & "waiting for user action" )
				GUICtrlSetState ($idListview, 64 )
				GUICtrlSetState ($idButton_Search, 64 )
				GUICtrlSetState ($idButtonCustomFolder,64)
				GUICtrlSetState ($idBtnChillMode, 64 )
				GUICtrlSetState ($idBtnCure, 128 )
				GUICtrlSetState ($idButton_Search,256) ; Set focus
				FillListViewWithInfo ()

		EndSelect

		Sleep(10)
	WEnd


Func MainGui()



	$MyhGUI=GUICreate($g_AppWndTitle,  $Dlg_Width , $Dlg_Height ,-1,-1, $WS_MINIMIZEBOX +  $WS_SYSMENU )
	$idListview = GUICtrlCreateListView("", $Dlg_Margin, $Dlg_Margin, $Dlg_ListViewWidth, $Dlg_Height / 1.5)
	$g_idListview = GUICtrlGetHandle($idListview) ; get the handle for use in the notify events
	_GUICtrlListView_SetExtendedListViewStyle($idListview, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_DOUBLEBUFFER,$LVS_EX_CHECKBOXES))

	; Add columns
	_GUICtrlListView_SetItemCount($idListview, UBound($FilesToPatch))
	_GUICtrlListView_AddColumn($idListview, "", $Dlg_Margin*2)
	_GUICtrlListView_AddColumn($idListview, "for collapsing or expanding all groups, please click here", $Dlg_ListViewWidth-$Dlg_Margin*4, 2)
	; Build groups
	_GUICtrlListView_EnableGroupView($idListview)
	_GUICtrlListView_InsertGroup($idListview, -1, 1, "",1) ; Group 1
	_GUICtrlListView_SetGroupInfo ( $idListview, 1, "Info" , 1 , $LVGS_COLLAPSIBLE )

	FillListViewWithInfo ()


		$idButtonCustomFolder = GUICtrlCreateButton("Custom Path", _
		$Dlg_Margin, 	60 + $Dlg_Height / 1.5 ,	$BT_Width, 		$BT_Height )
		GUICtrlSetTip(	-1, "Select Path that You want -> press Search -> press Patch button")

		$idBtnDeselectAll  = GUICtrlCreateButton("De/Select All", _
		($Dlg_Width/2 - $Dlg_Margin)/2, 	60 + $Dlg_Height / 1.5, 	$BT_Width, 		$BT_Height )
			;GUICtrlSetState(	-1, $GUI_DISABLE)
			GUICtrlSetTip(		-1, "De/Select All")

		$idBtnCure  = GUICtrlCreateButton("Patch Files", _
		$Dlg_Width/2 - $BT_Width/2 , 	60 + $Dlg_Height / 1.5, 	$BT_Width, 		$BT_Height )
			GUICtrlSetState(	-1, $GUI_DISABLE)
			GUICtrlSetTip(		-1, "Cure")

		$idButton_Search = GUICtrlCreateButton("Search Files", _
		$Dlg_Width/2 +$Dlg_Width/4 +  $Dlg_Margin/2 - $BT_Width , 	60 + $Dlg_Height / 1.5, 	$BT_Width, 		$BT_Height )

		GUICtrlSetTip(	-1, "Let GenP find Apps automatically in current path")

		$idBtnChillMode  = GUICtrlCreateButton("Chill Mode", _
		$Dlg_Width - ($Dlg_Width - $Dlg_ListViewWidth) +  $Dlg_Margin - $BT_Width , 	60 + $Dlg_Height / 1.5, 	$BT_Width, 		$BT_Height )
			;GUICtrlSetState(	-1, $GUI_DISABLE)
			GUICtrlSetTip(		-1, "Chill Mode")



		$MyOwnidProgress = GUICtrlCreateProgress( _
		$Dlg_Margin, 										40 + $Dlg_Height / 1.5,  		$Dlg_ListViewWidth , 	$BT_Height/3,	 _
			$PBS_SMOOTHREVERSE)


		Global $g_idMemo = GUICtrlCreateEdit("" , $Dlg_Margin ,$Dlg_Height / 1.5 + $Dlg_Margin*4, $Dlg_ListViewWidth, $Dlg_Height - ($Dlg_Height / 1.5 + $Dlg_Margin*4) - $Dlg_Margin*2, $ES_READONLY + $ES_CENTER + $WS_DISABLED )


		GUICtrlCreateLabel("By original creator Uncia with some improvements from GitHub :)", $Dlg_Margin, $Dlg_Height - $Dlg_Margin*2 , $Dlg_ListViewWidth, $BT_Height, $ES_CENTER)

		MemoWrite(@CRLF & "Path" & @CRLF & "---" & @CRLF & $MyDefPath & @CRLF & "---" & @CRLF & "waiting for user action" )




	GUICtrlSetState ($idButton_Search,256) ; Set focus
	GUISetState(@SW_SHOW)
		_WM_NOTIFY_Register()

EndFunc ; MyGui




Func RecursiveFileSearch($INSTARTDIR, $DEPTH, $FILECOUNT)
	;_FileListToArrayEx
	_GUICtrlListView_SetItemText($idListview, 1, "Searching for files.", 1)
		;_GUICtrlListView_SetItemGroupID($idListview, 0, 1)

	Dim $RecursiveFileSearch_MaxDeep = 6
	Dim $RecursiveFileSearch_WhenFoundRaiseToLevel = 0  ;0 to disable raising
	if $DEPTH > $RecursiveFileSearch_MaxDeep then return

	Local $TargetFileList_Adobe = [ _
	 "AppsPanelBL.dll",		 _
	 "Acrobat.dll",		 _
	 "acrodistdll.dll",		 _
	 "acrotray.exe",		 _
	 "Aero.exe",		 _
	 "AfterFXLib.dll",		 _
	 "Animate.exe",		 _
	 "auui.dll",		 _
	 "bridge.exe",		 _
	 "animator.exe",		 _
	 "dreamweaver.exe",		 _
	 "illustrator.exe",		 _
	 "public.dll",		 _
	 "lightroomcc.exe",		 _
	 "lightroom.exe",		 _
	 "Encoder.exe",		 _
	 "photoshop.exe",		 _
	 "registration.dll",		 _
	 "euclid-core",		 _
	 "XD.exe",		 _
	 "gemini_uwp_bridge.dll",		 _
	 "ngl-lib.dll",		 _
	 "Designer.exe",		 _
	 "Modeler.exe",		 _
	 "Painter.exe",		 _
	 "Sampler.exe",		 _
	 "Stager.exe",		 _
	 "SweetPeaSupport.dll",		 _
	 "dvaappsupport.dll"		 _
	]


	Local $STARTDIR = $INSTARTDIR & "\"
	$FileSearchedCount +=1

	dim $HSEARCH = FileFindFirstFile($STARTDIR & "*.*")
	If @error Then Return

	While 1
		Local $NEXT = FileFindNextFile($HSEARCH)
		$FileSearchedCount +=1

		If @error Then ExitLoop
		local $isDir = StringInStr(FileGetAttrib($STARTDIR & $NEXT), "D")

		If $isDir Then
			local $targetDepth
			$targetDepth = RecursiveFileSearch($STARTDIR & $NEXT, $DEPTH + 1, $FILECOUNT)
			; raise up in recursion to wanted level
;~ 			if ( $targetDepth > 0 ) and _
;~ 			   ( $targetDepth < $DEPTH ) Then _
;~ 				Return $targetDepth
		Else
			Local $IPATH = $STARTDIR & $NEXT

			For $AdobeFileTarget In $TargetFileList_Adobe
				local $FileNameCropped = StringSplit ( StringLower( $IPATH ),StringLower( $AdobeFileTarget ), $STR_ENTIRESPLIT )
				If  @error <> 1 then
					if not StringInStr($IPATH, ".bak"        ) Then
						;_ArrayAdd( $FilesToPatch, $DEPTH & " - " & $IPATH )
						If StringInStr($IPATH, "Adobe") Then
						_ArrayAdd( $FilesToPatch, $IPATH )
						EndIf
					Else
						_ArrayAdd( $FilesToRestore, $IPATH )
					EndIf

				  ; File Found and stored - Quit search in current dir
;~ 					return $RecursiveFileSearch_WhenFoundRaiseToLevel
				EndIf
			Next

		EndIf
	WEnd

	;Lazy screenupdates
	If 1 = Random ( 0, 10, 1) then
		MEMOWRITE(@CRLF &	"Searching in " & $FILECOUNT & " files" & @TAB & @TAB & "Found : " & UBound( $FilesToPatch ) & @CRLF & _
							"---" 			& @CRLF & _
							"Level: " & $DEPTH & "  Time elapsed : " & Round(TimerDiff($TIMESTAMP) / 1000, 0) & " second(s)" & @TAB & @TAB & "Excluded because of *.bak: " & UBound( $FilesToRestore ) &  @CRLF & _
							"---" 			& @CRLF & _
							$INSTARTDIR _
					)
		ProgressWrite( $ProgressFileCountScale * $FileSearchedCount )
	EndIf

	FileClose($HSEARCH)
EndFunc   ;==>RecursiveFileSearch

Func FillListViewWithInfo ()

				_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($idListview))
				_GUICtrlListView_SetExtendedListViewStyle($idListview, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_DOUBLEBUFFER))

				_Expand_All_Click()
				_GUICtrlListView_SetGroupInfo ( $idListview, 1, "Info" , 1,$LVGS_COLLAPSIBLE )



        ; Add items
		For $i=0 to 24
        _GUICtrlListView_AddItem($idListview, "", $i)
		_GUICtrlListView_SetItemGroupID($idListview, $i, 1)
		Next

        _GUICtrlListView_AddSubItem($idListview, 0, "", 1)
        _GUICtrlListView_AddSubItem($idListview, 1, "To patch all Adobe apps in default location:", 1)
        _GUICtrlListView_AddSubItem($idListview, 2, "Press 'Search Files' - Press 'Patch Files'", 1)
		_GUICtrlListView_AddSubItem($idListview, 3, "Default path - C:\Program Files", 1)
        _GUICtrlListView_AddSubItem($idListview, 4, '-------------------------------------------------------------', 1)
        _GUICtrlListView_AddSubItem($idListview, 5, "For patching Creative Cloud App", 1)
        _GUICtrlListView_AddSubItem($idListview, 6, "Press 'Custom path' - Select folder", 1)
        _GUICtrlListView_AddSubItem($idListview, 7, "C:\Program Files (x86)\Common Files\Adobe", 1)
        _GUICtrlListView_AddSubItem($idListview, 8, "Press 'Search Files' - Press 'Patch Files'", 1)
        _GUICtrlListView_AddSubItem($idListview, 9, '-------------------------------------------------------------', 1)
        _GUICtrlListView_AddSubItem($idListview, 10, "What's new in GenP:", 1)
        _GUICtrlListView_AddSubItem($idListview, 11, "Can patch apps from 2019 version to current and future releases", 1)
        _GUICtrlListView_AddSubItem($idListview, 12, "Automatic search and patch in selected folder", 1)
        _GUICtrlListView_AddSubItem($idListview, 13, "New patching logic", 1)
        _GUICtrlListView_AddSubItem($idListview, 14, "Support for all Substance products", 1)
        _GUICtrlListView_AddSubItem($idListview, 15, '-------------------------------------------------------------', 1)
        _GUICtrlListView_AddSubItem($idListview, 16, "Known issues:", 1)
        _GUICtrlListView_AddSubItem($idListview, 17, "InDesign and InCopy will have high Cpu usage", 1)
        _GUICtrlListView_AddSubItem($idListview, 18, "Animate will have some problems with home screen if Signed Out", 1)
        _GUICtrlListView_AddSubItem($idListview, 19, "Lightroom Classic will partially work if Signed Out", 1)
		_GUICtrlListView_AddSubItem($idListview, 20, "XD, Acrobat, Premiere Rush, Lightroom Online, Photosop Express", 1)
		_GUICtrlListView_AddSubItem($idListview, 21, "Won't be fully unlocked", 1)
        _GUICtrlListView_AddSubItem($idListview, 22, '-------------------------------------------------------------', 1)
		_GUICtrlListView_AddSubItem($idListview, 23, "Some Apps demand Creative Cloud App and mandatory SignIn", 1)
		_GUICtrlListView_AddSubItem($idListview, 24, "XD, Fresco, Aero, Lightroom Online, Premiere Rush, Photoshop Express", 1)


EndFunc

Func FillListViewWithFiles()

				_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($idListview))
				_GUICtrlListView_SetExtendedListViewStyle($idListview, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_DOUBLEBUFFER,$LVS_EX_CHECKBOXES))

		; Two column load
		if UBound($FilesToPatch)>0 Then
        Global $aItems[UBound($FilesToPatch)][2]
        For $iI = 0 To UBound($aItems) - 1
                $aItems[$iI][0] = $iI
                $aItems[$iI][1] = $FilesToPatch[$iI][0]

        Next
		_GUICtrlListView_AddArray($idListview, $aItems)

		MemoWrite( @CRLF & UBound($FilesToPatch) & " File(s) were found in " & Round(TimerDiff($timestamp) / 1000,0) & " second(s) at:" & @CRLF & "---" & @CRLF & $MyDefPath  & @CRLF & "---" & @CRLF & "Press the 'Patch Files'")
		;_ArrayDisplay($FilesToPatch)
		Else
		MemoWrite(@CRLF & "Nothing was found in" & @CRLF & "---" & @CRLF & $MyDefPath & @CRLF & "---" & @CRLF & "waiting for user action" )

		EndIf

EndFunc   ;==>FillListViewWithFiles

; Write a line to the memo control
Func MemoWrite($sMessage)
	GUICtrlSetData($g_idMemo, $sMessage)
EndFunc   ;==>MemoWrite

; Send a message to the Progress control
Func ProgressWrite($msg_Progress)
_SendMessage($hWnd_Progress,$PBM_SETPOS,$msg_Progress)
EndFunc   ;==>MemoWrite1


Func MyFileOpenDialog()

	 ; Set the state of the Notepad window to "hide".


	; Create a constant variable in Local scope of the message to display in FileOpenDialog.
	Local Const $sMessage = "Select a Path"

	; Display an open dialog to select a file.
	FileSetAttrib("C:\Program Files\WindowsApps", "-H")
	Local $MyTempPath = FileSelectFolder ($sMessage, $MyDefPath, 0,$MyDefPath,$MyhGUI)


        If @error Then
                ; Display the error message.
                ;MsgBox($MB_SYSTEMMODAL, "", "No folder was selected.")
				FileSetAttrib("C:\Program Files\WindowsApps", "+H")
				MemoWrite(@CRLF & "Path" & @CRLF & "---" & @CRLF & $MyDefPath & @CRLF & "---" & @CRLF & "waiting for user action" )

		Else
				GUICtrlSetState ($idBtnCure, 128 )
				$MyDefPath=$MyTempPath
				_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($idListview))
				_GUICtrlListView_SetExtendedListViewStyle($idListview, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_SUBITEMIMAGES))
				_GUICtrlListView_AddItem($idListview, "", 0)
				_GUICtrlListView_AddItem($idListview, "", 1)
				_GUICtrlListView_AddItem($idListview, "", 2)
				_GUICtrlListView_AddItem($idListview, "", 3)
				_GUICtrlListView_AddItem($idListview, "", 4)
				_GUICtrlListView_AddItem($idListview, "", 5)
				_GUICtrlListView_AddItem($idListview, "", 6)
				_GUICtrlListView_AddSubItem($idListview, 0, "", 1)
				_GUICtrlListView_AddSubItem($idListview, 1, "Path:", 1)
				_GUICtrlListView_AddSubItem($idListview, 2, "   " & $MyDefPath, 1)
				_GUICtrlListView_AddSubItem($idListview, 3, "Step 1:", 1)
				_GUICtrlListView_AddSubItem($idListview, 4, "   Press 'Search Files' - wait until GenP finds all files", 1)
				_GUICtrlListView_AddSubItem($idListview, 5, "Step 2:", 1)
				_GUICtrlListView_AddSubItem($idListview, 6, "   Press 'Patch Files' - wait until GenP will do it's job", 1)
				_GUICtrlListView_SetItemGroupID($idListview, 0, 1)
				_GUICtrlListView_SetItemGroupID($idListview, 1, 1)
				_GUICtrlListView_SetItemGroupID($idListview, 2, 1)
				_GUICtrlListView_SetItemGroupID($idListview, 3, 1)
				_GUICtrlListView_SetItemGroupID($idListview, 4, 1)
				_GUICtrlListView_SetItemGroupID($idListview, 5, 1)
				_GUICtrlListView_SetItemGroupID($idListview, 6, 1)
				_GUICtrlListView_SetGroupInfo ( $idListview, 1, "Info" , 1 , $LVGS_COLLAPSIBLE )

				FileSetAttrib("C:\Program Files\WindowsApps", "+H")
				MemoWrite(@CRLF & "Path" & @CRLF & "---" & @CRLF & $MyDefPath & @CRLF & "---" & @CRLF & "Press the Search button" )
                ; Display the selected folder.
                ;MsgBox($MB_SYSTEMMODAL, "", "You chose the following folder:" & @CRLF & $MyDefPath)
        EndIf
EndFunc   ;==>Example


	Func _ProcessCloseEx($sPIDhandle)
    If IsString($sPIDhandle) Then $sPIDhandle = ProcessExists($sPIDhandle)
    If Not $sPIDhandle Then Return SetError(1, 0, 0)

    Return Run(@ComSpec & " /c taskkill /F /PID " & $sPIDhandle & " /T", @SystemDir, @SW_HIDE)
	EndFunc


	Func ShowEscMessage()

        ; Retrieve the window title of the active window.
        ;Local $sText = WinGetTitle("[ACTIVE]")

		; Display the window title.
        ;MsgBox($MB_SYSTEMMODAL, "", $sText)


		Local $iState = WinGetState($MyhGUI)
		If $iState =  15 Then
			;MsgBox($MB_SYSTEMMODAL, "",$iState)
			Local $exitMessage=MsgBox(20, "", "Do you want to terminate ?",0,$MyhGUI)
			If $exitMessage=6 Then
				_ExitChillMode()
				_ProcessCloseEx(WinGetProcess($g_AppWndTitle))

			Else

			EndIf
		EndIf
	EndFunc   ;==>ShowMessage



	Func MyGlobalPatternSearch($MyFileToParse)
		Sleep(100)
		ConsoleWrite($MyFileToParse & @CRLF)
		$aInHexArray=$aNullArray ; Nullifay Array that will contain Hex later
		$aOutHexGlobalArray = $aNullArray ; Nullifay Array that will contain Hex later

		ProgressWrite(0)
 		$MyRegExpGlobalPatternSearchCount=0
		$Count=15

		MemoWrite( @CRLF & $MyFileToParse & @CRLF &  "---" & @CRLF & "Preparing to Analyze" & @CRLF & "---" & @CRLF & "*****")

	If StringInStr($MyFileToParse,"AppsPanelBL.dll")>0 Or  StringInStr($MyFileToParse,"SweetPeaSupport.dll")>0 Or  StringInStr($MyFileToParse,"dvaappsupport.dll")>0  Or  StringInStr($MyFileToParse,"bridge.exe")>0 Or  StringInStr($MyFileToParse,"Acrobat.dll")>0 Then

		If StringInStr($MyFileToParse,"AppsPanelBL.dll")>0 Then

						; extra Process kill
						Local $sPIDhandle1 =	ProcessExists ( "Creative Cloud.exe" )
 						ProcessClose($sPIDhandle1)
 						_ProcessCloseEx($sPIDhandle1)
						 $sPIDhandle1 =	ProcessExists ( "Creative Cloud.exe" )
						ProcessClose($sPIDhandle1)
						_ProcessCloseEx($sPIDhandle1)
						$sPIDhandle1 = _WinAPI_OpenProcess(0x1,0,$sPIDhandle1)
 						DllCall("kernel32.dll","int","TerminateProcess","int",$sPIDhandle1,"int",1)

						 $sPIDhandle1 =	ProcessExists ( "Adobe Desktop Service.exe" )
 						ProcessClose($sPIDhandle1)
 						_ProcessCloseEx($sPIDhandle1)
						 $sPIDhandle1 =	ProcessExists ( "Adobe Desktop Service.exe" )
						ProcessClose($sPIDhandle1)
						_ProcessCloseEx($sPIDhandle1)
						$sPIDhandle1 = _WinAPI_OpenProcess(0x1,0,$sPIDhandle1)
 						DllCall("kernel32.dll","int","TerminateProcess","int",$sPIDhandle1,"int",1)


		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternACC1S,$iPatternACC1R,       "$iPatternACC1S")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternACC2S,$iPatternACC2R,       "$iPatternACC2S")






		EndIf

		If StringInStr($MyFileToParse,"SweetPeaSupport.dll")>0 Then
		;MsgBox($MB_SYSTEMMODAL,"","SweetPeaSupport.dll")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternHevcMpegEnabler1S,$iPatternHevcMpegEnabler1R,       "$iPatternHevcMpegEnabler1S")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternHevcMpegEnabler2S,$iPatternHevcMpegEnabler2R,       "$iPatternHevcMpegEnabler2S")


		EndIf

		If StringInStr($MyFileToParse,"dvaappsupport.dll")>0 Then
		;MsgBox($MB_SYSTEMMODAL,"","dvaappsupport.dll")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternTeamProjectEnablerAS,$iPatternTeamProjectEnablerAR,   "$iPatternTeamProjectEnablerAS")
		EndIf

		If StringInStr($MyFileToParse,"bridge.exe")>0 Then
		;MsgBox($MB_SYSTEMMODAL,"","bridge.exe")

		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternPROFILE_EXPIREDS,$iPatternPROFILE_EXPIREDR,      "$iPatternPROFILE_EXPIREDS")

		;_ArrayDisplay($aOutHexGlobalArray,"Initial Search Check")
		If UBound($aOutHexGlobalArray)>0 Then

		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternValidateLicenseS,$iPatternValidateLicenseR,         "$iPatternValidateLicenseS")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternValidateLicense1S,$iPatternValidateLicense1R,         "$iPatternValidateLicense1S")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternValidateLicense2S,$iPatternValidateLicense2R,         "$iPatternValidateLicense2S")

		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternCmpEax61S,$iPatternCmpEax61r,         				"$iPatternCmpEax61S")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternCmpEax62S,$iPatternCmpEax62r,         				"$iPatternCmpEax62S")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternCmpEax63S,$iPatternCmpEax63r,         				"$iPatternCmpEax63S")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternCmpEax64S,$iPatternCmpEax64r,         				"$iPatternCmpEax64S")

		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternProcessV2Profile1aS,$iPatternProcessV2Profile1aR,    "$iPatternProcessV2Profile1aS")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternProcessV2Profile1a1S,$iPatternProcessV2Profile1a1R,    "$iPatternProcessV2Profile1a1S")

		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternBannerS,$iPatternBannerR,         "$iPatternBannerS")


		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternBridgeCamRaw1S,$iPatternBridgeCamRaw1R,   "$iPatternBridgeCamRaw1S")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternBridgeCamRaw2S,$iPatternBridgeCamRaw2R,   "$iPatternBridgeCamRaw2S")


		;_ArrayDisplay($aOutHexGlobalArray,"Global Search Check")

 		$MyRegExpGlobalPatternSearchCount=0
		$Count=0
		ProgressWrite(0)

		Else
  		MemoWrite(@CRLF & $MyFileToParse & @CRLF & "---" & @CRLF & "File was already patched?. Aborting..." & @CRLF & "---")
		Sleep(100)
  		$MyRegExpGlobalPatternSearchCount=0
		$Count=0
  		ProgressWrite(0)
		EndIf

		EndIf

		If StringInStr($MyFileToParse,"Acrobat.dll")>0 Then
		;MsgBox($MB_SYSTEMMODAL,"","bridge.exe")

		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternPROFILE_EXPIREDS,$iPatternPROFILE_EXPIREDR,      "$iPatternPROFILE_EXPIREDS")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternPROFILE_EXPIRED1S,$iPatternPROFILE_EXPIRED1R,      "$iPatternPROFILE_EXPIRED1S")

		;_ArrayDisplay($aOutHexGlobalArray,"Initial Search Check")
		If UBound($aOutHexGlobalArray)>0 Then

		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternValidateLicenseS,$iPatternValidateLicenseR,         "$iPatternValidateLicenseS")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternValidateLicense1S,$iPatternValidateLicense1R,         "$iPatternValidateLicense1S")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternValidateLicense2S,$iPatternValidateLicense2R,         "$iPatternValidateLicense2S")

		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternCmpEax61S,$iPatternCmpEax61r,         				"$iPatternCmpEax61S")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternCmpEax62S,$iPatternCmpEax62r,         				"$iPatternCmpEax62S")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternCmpEax63S,$iPatternCmpEax63r,         				"$iPatternCmpEax63S")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternCmpEax64S,$iPatternCmpEax64r,         				"$iPatternCmpEax64S")

		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternProcessV2Profile1aS,$iPatternProcessV2Profile1aR,    "$iPatternProcessV2Profile1aS")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternProcessV2Profile1a1S,$iPatternProcessV2Profile1a1R,    "$iPatternProcessV2Profile1a1S")

		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternBannerS,$iPatternBannerR,         "$iPatternBannerS")


		;MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternBridgeCamRaw1S,$iPatternBridgeCamRaw1R,   "$iPatternBridgeCamRaw1S")
		;MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternBridgeCamRaw2S,$iPatternBridgeCamRaw2R,   "$iPatternBridgeCamRaw2S")


		;_ArrayDisplay($aOutHexGlobalArray,"Global Search Check")

 		$MyRegExpGlobalPatternSearchCount=0
		$Count=0
		ProgressWrite(0)

		Else
  		MemoWrite( @CRLF & $MyFileToParse & @CRLF & "---" & @CRLF & "File was already patched?. Aborting..." & @CRLF & "---")
		Sleep(100)
  		$MyRegExpGlobalPatternSearchCount=0
		$Count=0
  		ProgressWrite(0)
		EndIf

		EndIf


	Else


		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternPROFILE_EXPIREDS,$iPatternPROFILE_EXPIREDR,      "$iPatternPROFILE_EXPIREDS")
		;_ArrayDisplay($aOutHexGlobalArray,"Initial Search Check")
		If UBound($aOutHexGlobalArray)>0 Then

		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternValidateLicenseS,$iPatternValidateLicenseR,         "$iPatternValidateLicenseS")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternValidateLicense1S,$iPatternValidateLicense1R,         "$iPatternValidateLicense1S")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternValidateLicense2S,$iPatternValidateLicense2R,         "$iPatternValidateLicense2S")

		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternCmpEax61S,$iPatternCmpEax61r,         				"$iPatternCmpEax61S")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternCmpEax62S,$iPatternCmpEax62r,         				"$iPatternCmpEax62S")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternCmpEax63S,$iPatternCmpEax63r,         				"$iPatternCmpEax63S")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternCmpEax64S,$iPatternCmpEax64r,         				"$iPatternCmpEax64S")

		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternProcessV2Profile1aS,$iPatternProcessV2Profile1aR,    "$iPatternProcessV2Profile1aS")
		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternProcessV2Profile1a1S,$iPatternProcessV2Profile1a1R,    "$iPatternProcessV2Profile1a1S")

		MyRegExpGlobalPatternSearch($MyFileToParse,$iPatternBannerS,$iPatternBannerR,         "$iPatternBannerS")


		;_ArrayDisplay($aOutHexGlobalArray,"Global Search Check")

 		$MyRegExpGlobalPatternSearchCount=0
		$Count=0
		ProgressWrite(0)

		Else
  		MemoWrite( @CRLF & $MyFileToParse & @CRLF & "---" & @CRLF & "File was already patched?. Aborting..." & @CRLF & "---")
		Sleep(100)
  		$MyRegExpGlobalPatternSearchCount=0
		$Count=0
  		ProgressWrite(0)
		EndIf
	EndIf

	EndFunc


	Func MyRegExpGlobalPatternSearch($FileToParse,$PatternToSearch,$PatternToReplace,$PatternName) ; Path to a file to parse
		;MsgBox($MB_SYSTEMMODAL, "Path", $FileToParse)
		;ConsoleWrite($FileToParse & @CRLF)
		Local $hFileOpen = FileOpen($FileToParse, $FO_READ + $FO_BINARY)
		Local $sFileRead = FileRead($hFileOpen)
		Local $iSearchPattern = $PatternToSearch  ;string
		Local $aReplacePattern = $PatternToReplace   ;array
		Local $iNewSearchConstruct = "", $iNewReplaceConstruct = "",$iNewReplaceConstruct1 = ""
		Local $aInHexTempArray[0]
		Local $sString1 = "", $sString2 = ""

		$aInHexTempArray=$aNullArray
		$aInHexTempArray = StringRegExp($sFileRead, $iSearchPattern, $STR_REGEXPARRAYGLOBALFULLMATCH, 1)


		For $iI=0 To UBound($aInHexTempArray)-1

		$aInHexArray = $aNullArray
		$sString1 = ""
		$sString2 = ""
		$iNewSearchConstruct = ""
		$iNewReplaceConstruct = ""
		$iNewReplaceConstruct1 = ""


		$aInHexArray = $aInHexTempArray[$iI]
		;_ArrayDisplay($aInHexArray)
		;$aInHexArray = StringRegExp($sFileRead, $iSearchPattern, $STR_REGEXPARRAYFULLMATCH, 1)
		If @error = 0 Then
				$iNewSearchConstruct=$aInHexArray[0] ; full founded Search Pattern index 0

				For $i=0 to UBound($aReplacePattern)-1
					$iNewReplaceConstruct&=$aReplacePattern[$i] ; array to string
				Next

					;MsgBox(-1,"",$iNewSearchConstruct & @CRLF & $iNewReplaceConstruct) ; full search and full patch with ?? symbols

				If StringInStr ( $iNewReplaceConstruct, "?" ) Then
					;MsgBox($MB_SYSTEMMODAL, "Found ? symbol", "Constructing new Replace string")
					For $i=1 to StringLen($iNewReplaceConstruct)+1
							; Retrieve a characters from the $ith position in the string.
							$sString1 = StringMid($iNewSearchConstruct, $i, 1)
							$sString2 = StringMid($iNewReplaceConstruct, $i, 1)

							If $sString2 <> "?" Then
								$iNewReplaceConstruct1&=$sString2
							Else
								$iNewReplaceConstruct1&=$sString1
							EndIf

					Next
				Else
					$iNewReplaceConstruct1=$iNewReplaceConstruct
				EndIf

				_ArrayAdd($aOutHexGlobalArray,$iNewSearchConstruct)
				_ArrayAdd($aOutHexGlobalArray,$iNewReplaceConstruct1)

				ConsoleWrite($PatternName & "---" & @TAB & $iNewSearchConstruct & "	" &@CRLF)
				ConsoleWrite($PatternName & "R" & "--" & @TAB & $iNewReplaceConstruct1 & "	" &@CRLF)
				MemoWrite( @CRLF & $FileToParse & @CRLF  & "---" & @CRLF & $PatternName & @CRLF  & "---" & @CRLF &  $iNewSearchConstruct & @CRLF & $iNewReplaceConstruct1 )

		Else
			ConsoleWrite($PatternName & "---" & @TAB & "No" & "	" &@CRLF)
			MemoWrite( @CRLF & $FileToParse & @CRLF  & "---" & @CRLF & $PatternName & "---" & "No" )
		EndIf
			$MyRegExpGlobalPatternSearchCount+=1

		Next
	FileClose($hFileOpen)
    $sFileRead = ""
	ProgressWrite(Round($MyRegExpGlobalPatternSearchCount / $Count* 100))
	Sleep(100)

	EndFunc


;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Func MyGlobalPatternPatch ($MyFileToPatch,$MyArrayToPatch)
	;MsgBox($MB_SYSTEMMODAL, "", $MyFileToPatch)
	;_ArrayDisplay($MyArrayToPatch)
	ProgressWrite(0)
	;MemoWrite("Current path" & @CRLF  & "---" & @CRLF & $MyFileToPatch & @CRLF & "---" & @CRLF & "medication :)")
	Local $iRows1=0
	$iRows1 = UBound($MyArrayToPatch) ; Total number of rows
	If $iRows1>0 Then
		MemoWrite(@CRLF & "Path" & @CRLF  & "---" & @CRLF & $MyFileToPatch & @CRLF & "---" & @CRLF & "medication :)")
		Local $hFileOpen = FileOpen($MyFileToPatch, $FO_READ + $FO_BINARY)
		Local $sFileRead = FileRead($hFileOpen)

		For $i = 0 To $iRows1-1 Step 2
			Local $sStringOut= StringReplace($sFileRead, $MyArrayToPatch[$i], $MyArrayToPatch[$i+1], 0, 1)
			$sFileRead = $sStringOut
			$sStringOut = $sFileRead
			ProgressWrite( Round($i / $iRows1 * 100))
		Next

			;MsgBox($MB_SYSTEMMODAL, "", "binary: " & Binary($sStringOut))
			FileClose($hFileOpen)
			FileMove($MyFileToPatch, $MyFileToPatch & ".bak",$FC_OVERWRITE)
			Local $hFileOpen1 = FileOpen($MyFileToPatch, $FO_OVERWRITE + $FO_BINARY)
			FileWrite($hFileOpen1, Binary($sStringOut))
			FileClose($hFileOpen1)
			ProgressWrite(0)
			Sleep(100)
			;MemoWrite1(@CRLF & "---" & @CRLF & "Waitng for your command :)" & @CRLF & "---")



	Else
			;Empty array - > no search-replace patterns
			;File is already patched or no patterns were found .
			MemoWrite( @CRLF & "No patterns were found" & @CRLF & "---" & @CRLF & "or" & @CRLF & "---" & @CRLF & "file is already patched.")
			Sleep(100)

	EndIf
			;Sleep(100)
			;MemoWrite2("***")
EndFunc   ;==>PatchALL

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Func ChillMode()
	GUICtrlSetState($idListview, 32)


	_GDIPlus_Startup() ;initialize GDI+

	Local Const $iWidth = $Dlg_ListViewWidth, $iHeight = $Dlg_Height / 1.5, $iBgColor = 0x303030 ;$iBGColor format RRGGBB

	;create buffered graphics frame set for smoother gfx object movements
	$g_hGraphics = _GDIPlus_GraphicsCreateFromHWND($MyhGUI) ;create a graphics object from a window handle
	$g_hBitmap = _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $g_hGraphics)
	$g_hGfxCtxt = _GDIPlus_ImageGetGraphicsContext($g_hBitmap)
	_GDIPlus_GraphicsSetSmoothingMode($g_hGfxCtxt, $GDIP_SMOOTHINGMODE_HIGHQUALITY) ;sets the graphics object rendering quality (antialiasing)
	$g_hPen = _GDIPlus_PenCreate(0xFFFF8060, 2)
	_GDIPlus_GraphicsSetPixelOffsetMode($g_hGfxCtxt, $GDIP_PIXELOFFSETMODE_HIGHQUALITY)
	;_GDIPlus_GraphicsTranslateTransform($g_hGraphics,$Dlg_Margin, $Dlg_Margin)

	Local $aPoints[11][4], $x, $y
	$aPoints[0][0] = 10

	For $y = 0 To 1
		For $x = 1 To 5
			$aPoints[$y * 5 + $x][0] = 100 + 300 * $y + 50 ;x coordinate of the point
			$aPoints[$y * 5 + $x][1] = 150 + $x * 50 ;y coordinate of the point
			$aPoints[$y * 5 + $x][2] = Random(-2, 2) ;x vector of the point
			$aPoints[$y * 5 + $x][3] = Random(-2, 2) ;y vector of the point
		Next
	Next



	Do
		_GDIPlus_GraphicsClear($g_hGfxCtxt, 0xFF000000 + $iBgColor) ;clear bitmap for repaint
		_GDIPlus_GraphicsDrawClosedCurve2($g_hGfxCtxt, $aPoints, 1.25, $g_hPen) ;draw closed curve
		_GDIPlus_GraphicsDrawImage($g_hGraphics, $g_hBitmap, $Dlg_Margin, $Dlg_Margin) ;copy bitmap to graphic handle (GUI)
		For $y = 1 To $aPoints[0][0]
			$aPoints[$y][0] += $aPoints[$y][2] ;calculate new x position
			If $aPoints[$y][0] < 0 Or $aPoints[$y][0] > $iWidth Then $aPoints[$y][2] *= -1 ;if vertical border is reached invert x vector
			$aPoints[$y][1] += $aPoints[$y][3] ;calculate new y position
			If $aPoints[$y][1] < 0 Or $aPoints[$y][1] > $iHeight Then $aPoints[$y][3] *= -1 ;if horizontal border is reached invert y vector
		Next
		Local $idMsg1 = GUIGetMsg()

	Until $idMsg1 = $idBtnChillMode
	_ExitChillMode()
EndFunc   ;==>Example

Func _ExitChillMode()
	;cleanup GDI+ resources
	_GDIPlus_PenDispose($g_hPen)
	_GDIPlus_GraphicsDispose($g_hGfxCtxt)
	_GDIPlus_GraphicsClear($g_hGfxCtxt)
	_GDIPlus_GraphicsDispose($g_hGraphics)
	_GDIPlus_GraphicsClear($g_hGraphics)
	_GDIPlus_BitmapDispose($g_hBitmap)
	_WinAPI_DeleteObject($g_hGfxCtxt)
	_WinAPI_DeleteObject($g_hGraphics)
	_WinAPI_DeleteObject($g_hBitmap)
	_GDIPlus_Shutdown()
	GUICtrlSetState($idListview, 16 )



EndFunc   ;==>_Exit



Func _ListView_Click()
	Local $aHit

	$aHit = _GUICtrlListView_HitTest($g_idListview)

	If $aHit[0] <> -1 Then
				Local $GroupIdOfHitItem = _GUICtrlListView_GetItemGroupID($idListview, $aHit[0])

			If _GUICtrlListView_GetItemChecked($g_idListview, $aHit[0]) = 1 Then

				For $i = 0 To _GUICtrlListView_GetItemCount($idListview)-1
					If _GUICtrlListView_GetItemGroupID($idListview, $i) = $GroupIdOfHitItem Then
					_GUICtrlListView_SetItemChecked($g_idListview, $i,0)
					EndIf
				Next
			Else
				For $i = 0 To _GUICtrlListView_GetItemCount($idListview)-1
					If _GUICtrlListView_GetItemGroupID($idListview, $i) = $GroupIdOfHitItem Then
					_GUICtrlListView_SetItemChecked($g_idListview, $i,1)
					EndIf
				Next


			EndIf

		;$g_iIndex = $aHit[0]
	EndIf

EndFunc   ;==>_ListView_Click


Func _Assign_Groups_To_Found_Files()

		;_GUICtrlListView_RemoveAllGroups ( $idListview )
		Local $MyListItemCount = _GUICtrlListView_GetItemCount($idListview)

		;MsgBox(-1,"ItemCount",_GUICtrlListView_GetItemCount($idListview))
		;MsgBox(-1,"GroupCount",_GUICtrlListView_GetGroupCount($idListview))

		For $iI = 0 To $MyListItemCount-1
			_GUICtrlListView_SetItemChecked($idListview, $iI)

			; Build groups
			Local $ItemFromList = _GUICtrlListView_GetItemText($idListview, $iI,1)


			Select
				Case StringInStr($ItemFromList, "Acrobat")
					_GUICtrlListView_InsertGroup($idListview, $iI, 1, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 1)
					_GUICtrlListView_SetGroupInfo ( $idListview, 1, "Acrobat" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "Aero")
					_GUICtrlListView_InsertGroup($idListview, $iI, 2, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 2)
					_GUICtrlListView_SetGroupInfo ( $idListview, 2, "Aero" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "After Effects")
					_GUICtrlListView_InsertGroup($idListview, $iI, 3, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 3)
					_GUICtrlListView_SetGroupInfo ( $idListview, 3, "After Effects" , 1 , $LVGS_COLLAPSIBLE )


				Case StringInStr($ItemFromList, "Animate")
					_GUICtrlListView_InsertGroup($idListview, $iI, 4, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 4)
					_GUICtrlListView_SetGroupInfo ( $idListview, 4, "Animate" , 1 , $LVGS_COLLAPSIBLE )


				Case StringInStr($ItemFromList, "Audition")
					_GUICtrlListView_InsertGroup($idListview, $iI, 5, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 5)
					_GUICtrlListView_SetGroupInfo ( $idListview, 5, "Audition" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "Adobe Bridge")
					_GUICtrlListView_InsertGroup($idListview, $iI, 6, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 6)
					_GUICtrlListView_SetGroupInfo ( $idListview, 6, "Bridge" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "Character Animator")
					_GUICtrlListView_InsertGroup($idListview, $iI, 7, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 7)
					_GUICtrlListView_SetGroupInfo ( $idListview, 7, "Character Animator" , 1 , $LVGS_COLLAPSIBLE )


				Case StringInStr($ItemFromList, "AppsPanel")
					_GUICtrlListView_InsertGroup($idListview, $iI, 8, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 8)
					_GUICtrlListView_SetGroupInfo ( $idListview, 8, "Creative Cloud" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "Dimension")
					_GUICtrlListView_InsertGroup($idListview, $iI, 9, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 9)
					_GUICtrlListView_SetGroupInfo ( $idListview, 9, "Dimension" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "Dreamweaver")
					_GUICtrlListView_InsertGroup($idListview, $iI, 10, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 10)
					_GUICtrlListView_SetGroupInfo ( $idListview, 10, "Dreamweaver" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "Illustrator")
					_GUICtrlListView_InsertGroup($idListview, $iI, 11, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 11)
					_GUICtrlListView_SetGroupInfo ( $idListview, 11, "Illustrator" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "InCopy")
					_GUICtrlListView_InsertGroup($idListview, $iI, 12, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 12)
					_GUICtrlListView_SetGroupInfo ( $idListview, 12, "InCopy" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "InDesign")
					_GUICtrlListView_InsertGroup($idListview, $iI, 13, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 13)
					_GUICtrlListView_SetGroupInfo ( $idListview, 13, "InDesign" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "Lightroom CC")
					_GUICtrlListView_InsertGroup($idListview, $iI, 14, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 14)
					_GUICtrlListView_SetGroupInfo ( $idListview, 14, "Lightroom CC" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "Lightroom Classic")
					_GUICtrlListView_InsertGroup($idListview, $iI, 15, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 15)
					_GUICtrlListView_SetGroupInfo ( $idListview, 15, "Lightroom Classic" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "Media Encoder")
					_GUICtrlListView_InsertGroup($idListview, $iI, 16, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 16)
					_GUICtrlListView_SetGroupInfo ( $idListview, 16, "Media Encoder" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "Photoshop")
					_GUICtrlListView_InsertGroup($idListview, $iI, 17, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 17)
					_GUICtrlListView_SetGroupInfo ( $idListview, 17, "Photoshop" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "Premiere Pro")
					_GUICtrlListView_InsertGroup($idListview, $iI, 18, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 18)
					_GUICtrlListView_SetGroupInfo ( $idListview, 18, "Premiere Pro" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "Premiere Rush")
					_GUICtrlListView_InsertGroup($idListview, $iI, 19, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 19)
					_GUICtrlListView_SetGroupInfo ( $idListview, 19, "Premiere Rush" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "Substance 3D Designer")
					_GUICtrlListView_InsertGroup($idListview, $iI, 20, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 20)
					_GUICtrlListView_SetGroupInfo ( $idListview, 20, "Substance 3D Designer" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "Substance 3D Modeler")
					_GUICtrlListView_InsertGroup($idListview, $iI, 21, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 21)
					_GUICtrlListView_SetGroupInfo ( $idListview, 21, "Substance 3D Modeler" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "Substance 3D Painter")
					_GUICtrlListView_InsertGroup($idListview, $iI, 22, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 22)
					_GUICtrlListView_SetGroupInfo ( $idListview, 22, "Substance 3D Painter" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "Substance 3D Sampler")
					_GUICtrlListView_InsertGroup($idListview, $iI, 23, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 23)
					_GUICtrlListView_SetGroupInfo ( $idListview, 23, "Substance 3D Sampler" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "Substance 3D Stager")
					_GUICtrlListView_InsertGroup($idListview, $iI, 24, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 24)
					_GUICtrlListView_SetGroupInfo ( $idListview, 24, "Substance 3D Stager" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "Adobe.Fresco")
					_GUICtrlListView_InsertGroup($idListview, $iI, 25, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 25)
					_GUICtrlListView_SetGroupInfo ( $idListview, 25, "Fresco" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "Adobe.XD")
					_GUICtrlListView_InsertGroup($idListview, $iI, 26, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 26)
					_GUICtrlListView_SetGroupInfo ( $idListview, 26, "XD" , 1 , $LVGS_COLLAPSIBLE )

				Case StringInStr($ItemFromList, "PhotoshopExpress")
					_GUICtrlListView_InsertGroup($idListview, $iI, 27, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI,27)
					_GUICtrlListView_SetGroupInfo ( $idListview, 27, "PhotoshopExpress" , 1 , $LVGS_COLLAPSIBLE )



				Case Else
					_GUICtrlListView_InsertGroup($idListview, $iI, 28, "", 1)
					_GUICtrlListView_SetItemGroupID($idListview, $iI, 28)
					_GUICtrlListView_SetGroupInfo ( $idListview, 28, "Else" , 1 , $LVGS_COLLAPSIBLE )


			EndSelect


		Next

		;MsgBox(-1,"ItemCount",_GUICtrlListView_GetItemCount($idListview))
		;MsgBox(-1,"GroupCount",_GUICtrlListView_GetGroupCount($idListview))


EndFunc

Func _Collapse_All_Click()

		Local $aCount =_GUICtrlListView_GetGroupCount ( $idListview ) ; Group Count

		If $aCount >0  Then
			If $MyLVGroupIsExpanded=1 Then

			; Change group information
			For $iI = 1 To $aCount

			Local $aInfo = _GUICtrlListView_GetGroupInfo($idListview, $iI)
			_GUICtrlListView_SetGroupInfo ( $idListview, $iI, $aInfo[0] , $aInfo[1] , $LVGS_COLLAPSED )
			Next
				$MyLVGroupIsExpanded=0
			Else
				_Expand_All_Click()
				$MyLVGroupIsExpanded=1
			EndIf
		EndIf

EndFunc


Func _Expand_All_Click()

		Local $aCount =_GUICtrlListView_GetGroupCount ( $idListview ) ; Group Count

		If $aCount >0  Then
			; Change group information
			For $iI = 1 To $aCount

			Local $aInfo = _GUICtrlListView_GetGroupInfo($idListview, $iI)
			_GUICtrlListView_SetGroupInfo ( $idListview, $iI, $aInfo[0] , $aInfo[1] , $LVGS_NORMAL )
			_GUICtrlListView_SetGroupInfo ( $idListview, $iI, $aInfo[0] , $aInfo[1] , $LVGS_COLLAPSIBLE )
			Next
		EndIf

EndFunc


Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $wParam
	Local $hWndListView = $g_idListview
	If Not IsHWnd($g_idListview) Then $hWndListView = GUICtrlGetHandle($g_idListview)

	Local $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	Local $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	Local $iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndListView
			Switch $iCode
				Case $LVN_COLUMNCLICK ; A column was clicked
					_WM_NOTIFY_DebugEvent("$LVN_COLUMNCLICK", $tagNMLISTVIEW, $lParam, "IDFrom,,Item,SubItem,NewState,OldState,Changed,ActionX,ActionY,Param")

					_Collapse_All_Click()


					; No return value
				Case $LVN_KEYDOWN ; A key has been pressed
					_WM_NOTIFY_DebugEvent("$LVN_KEYDOWN", $tagNMLVKEYDOWN, $lParam, "IDFrom,,VKey,Flags")
					; No return value

				Case $NM_CLICK ; Sent by a list-view control when the user clicks an item with the left mouse button
					_WM_NOTIFY_DebugEvent("$NM_CLICK", $tagNMITEMACTIVATE, $lParam, "IDFrom,,Index,SubItem,NewState,OldState,Changed,ActionX,ActionY,lParam,KeyFlags")

					_ListView_Click()

					; No return value
				Case $NM_DBLCLK ; Sent by a list-view control when the user double-clicks an item with the left mouse button
					_WM_NOTIFY_DebugEvent("$NM_DBLCLK", $tagNMITEMACTIVATE, $lParam, "IDFrom,,Index,SubItem,NewState,OldState,Changed,ActionX,ActionY,lParam,KeyFlags")
					; No return value

				Case $NM_KILLFOCUS ; The control has lost the input focus
					_WM_NOTIFY_DebugEvent("$NM_KILLFOCUS", $tagNMHDR, $lParam, "hWndFrom,IDFrom")
					; No return value

				Case $NM_RCLICK ; Sent by a list-view control when the user clicks an item with the right mouse button
					_WM_NOTIFY_DebugEvent("$NM_RCLICK", $tagNMITEMACTIVATE, $lParam, "IDFrom,,Index,SubItem,NewState,OldState,Changed,ActionX,ActionY,lParam,KeyFlags")
					;Return 1 ; not to allow the default processing
					Return 0 ; allow the default processing

				Case $NM_RDBLCLK ; Sent by a list-view control when the user double-clicks an item with the right mouse button
					_WM_NOTIFY_DebugEvent("$NM_RDBLCLK", $tagNMITEMACTIVATE, $lParam, "IDFrom,,Index,SubItem,NewState,OldState,Changed,ActionX,ActionY,lParam,KeyFlags")
					; No return value

				Case $NM_RETURN ; The control has the input focus and that the user has pressed the ENTER key
					_WM_NOTIFY_DebugEvent("$NM_RETURN", $tagNMHDR, $lParam, "hWndFrom,IDFrom")
					; No return value

				Case $NM_SETFOCUS ; The control has received the input focus
					_WM_NOTIFY_DebugEvent("$NM_SETFOCUS", $tagNMHDR, $lParam, "hWndFrom,IDFrom")
					; No return value
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY
