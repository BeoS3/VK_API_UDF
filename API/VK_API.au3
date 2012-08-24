#include-once
#include <IE.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <Array.au3>


;Opt("MustDeclareVars",1)
#cs
	photos.editAlbum � ��������� ������ ������� ��� ����������.
	photos.edit � �������� �������� � ��������� ����������.
	photos.move � ��������� ���������� �� ������ ������� � ������.
	photos.makeCover � ������ ���������� �������� �������.
	photos.reorderAlbums � ������ ������� ������� � ������ �������� ������������.
	audio.getById � ���������� ���������� �� ������������ �� �� ���������������.
	audio.getLyrics - ���������� ����� �����������.
	audio.getUploadServer � ���������� ����� ������� ��� �������� ������������.
	audio.save � ��������� ����������� ����� �������� ��������.
	audio.search � ������������ ����� �� ������������.
	audio.add � �������� ������������ ����������� �� �������� ������������ ��� ������.
	audio.delete � ������� ����������� �� �������� ������������ ��� ������.
#ce

; #FUNCTION# =================================================================================================
; Name...........: _VK_SignIn()
; Description ...: ��������� ����������� �� ����� ���������
; Syntax.........: _VK_SignIn($iAppID, $sScope, $sRedirect_uri = "http://api.vkontakte.ru/blank.html", $sDisplay = "wap", $sResponse_type = "token")
; Parameters ....: $iAppID - App ID ���������� ����������� �� ����� ���������
;    			   $sScope - ������� ����� ��� ������� � ������ ������������ ��������� (����� ������� � ��������� �������)
;				   $sRedirect_uri -
;				   $sDisplay -
;				   $sResponse_type -
; Return values .: ��� ������� ����������� ���������� ���� ������� ��� ������������ ��������� �������
; Author ........: Fever
; Remarks .......: �����������
; ============================================================================================================
Func _VK_SignIn($iAppID, $sScope, $sRedirect_uri = "http://api.vkontakte.ru/blank.html", $sDisplay = "popup", $sResponse_type = "token")
	Local $sOAuth_url = "http://api.vkontakte.ru/oauth/authorize?client_id=" & $iAppID & "&scope=" & $sScope & "&redirect_uri=" & $sRedirect_uri & "&display=" & $sDisplay & "&response_type=" & $sResponse_type
	Return __guiAccessToken($sOAuth_url, "��������� | ����", $sRedirect_uri)
EndFunc   ;==>_VK_SignIn

#region Users Functions

; #FUNCTION# =================================================================================================
; Name...........: _VK_getProfiles()
; Description ...: ���������� ����������� ���������� � �������������.
; Syntax.........: _VK_getProfiles($_sAccessToken, $_sUIDs, $_sFields = "", $_sName_case = "")
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������
;                  $_sUIDs - �������������� ������������� ��� �� �������� ����� (screen_name). �������� 1000 �������������.
;				   �������� ����� ���� �������� ���� � ���� ������, ��� �������������� ����������� ����� �������, ���� � ���� �������
;                  $_sFields - ������������� ����� ������� ���� �����, ������� ���������� ��������. �� ��������� ��� ��������� ����.
;				   $_sName_case - ����� ��� ��������� ����� � ������� ������������. �� ��������� ������������ �����.
;						��������� ��������: ������������ � nom, ����������� � gen, ��������� � dat, ����������� � acc, ������������ � ins, ���������� � abl.
; Return values .: ����� - ������ � ������� aFullArray[$Count][$CountFields] - ���
;						$Count - ���������� ����� ����������� ������������
;						$CountFields - ���������� ����� ����, ������� ���� �� �������, ��� �� ��� ������. �� ���������:
;							0 - uid (������������� ������������)
;							1 - first_name (���)
;							2 - last_name (�������)
;							3 - sex (���: 1 - �������, 2 - �������, 0 - ��� �������� ����. )
;							4 - online (������:  0 - ������������ �� � ����, 1 - ������������ � ����. )
;							5 - bdate (���� ��������. ������� � �������: "23.11.1981" ��� "21.9" (���� ��� �����). ���� ���� �������� ������ �������, �� ������ ������)
;							6 - city (������� id ������. �������� ������ �� ��� id ����� ������ ��� ������ ������� getCities. ���� ����� �� ������, �� ������ ������)
;							7 - country (������� id ������. �������� ������ �� � id ����� ������ ��� ������ ������ getCountries. ���� ������ �� �������, �� ������ ������)
;							8 - photo (������� url ���������� ������������, ������� ������ 50 ��������.)
;							9 - photo_medium (������� url ���������� ������������, ������� ������ 100 ��������.)
;							10 - photo_medium_rec (������� url ���������� ���������� ������������, ������� ������ 50 ��������.)
;							11 - photo_big (������� url ���������� ������������, ������� ������ 200 ��������.)
;							12 - photo_rec (������� url ���������� ���������� ������������, ������� ������ 50 ��������.)
;							13 - screen_name (���������� �������� ����� �������� (������������ ������ ��� ������, �������� andrew). ���� ������������ �� ����� ����� ����� ��������, ������������ 'id'+uid, �������� id35828305)
;							14 - has_mobile (����������, �������� �� ����� ���������� �������� ������������. ������������ ��������: 1 - ��������, 0 - �� ��������. )
;							15 - rate (������� ������������)
;							16 - home_phone (�������� ������� ������������)
;							17 - mobile_phone (��������� ������� ������������)
;							18 - university (��� ������������)
;							19 - university_name (�������� ������������)
;							20 - faculty (��� ����������)
;							21 - faculty_name (��� ����������)
;							22 - graduation (��� ��������� ��������)
;							23 - can_post (��������� �� ��������� ������ �� ����� � ������� ������������.)
;							24 - can_write_private_message (��������� �� ��������� ������ ��������� ������� ������������. )
;							25 - activity (���������� ������, ������������� � �������, ��� ������ ������������ )
;							26 - relation (���������� �������� ��������� ������������: 1 - �� �����/�� ������� 2 - ���� ����/���� ������� 3 - ���������/���������� 4 - �����/������� 5 - �� ������ 6 - � �������� ������ 7 - ������/�������� )
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Fever, Medic84
; Remarks .......: ���������: http://vkontakte.ru/pages?oid=-1&p=getProfiles
;				   ���� � ������ ��� � ������� ����� ����� 1000 �������������, �� ����� ������ ������ ������ 1000
;				   ���� � $_sFields ����� ������� ���� contacts, �� ����� ���������� 1 �������������� ����
;				   ���� � $_sFields ����� ������� ���� education, �� ����� ���������� 4 �������������� ����
; ============================================================================================================
Func _VK_getProfiles($_sAccessToken, $_sUIDs, $_sFields = "", $_sName_case = "")
	Local $sUIDsDots = "", $sResponse, $aFields, $aUIDs, $nCount, $aTemp, $aUsers

	If $_sFields = "" Then $_sFields = "uid,first_name,last_name,sex,online,bdate,city,country,photo,photo_medium,photo_medium_rec," _
			 & "photo_big,photo_rec,screen_name,has_mobile,rate,contacts,education,can_post,can_write_private_message,activity,relation"

	$aFields = StringReplace($_sFields, "contacts", "home_phone,mobile_phone")
	$aFields = StringReplace($aFields, "education", "university,university_name,faculty,faculty_name,graduation")

	$aFields = StringSplit($aFields, ",", 2)

	If Not IsArray($_sUIDs) Then
		$aUIDs = StringRegExpReplace($_sUIDs, "^[,\h]+|[,\h]+$", "")
		$aUIDs = StringSplit($aUIDs, ",", 2)
	Else
		$aUIDs = $_sUIDs
	EndIf

	If UBound($aUIDs) > 1000 Then
		$nCount = 1000
	Else
		$nCount = UBound($aUIDs)
	EndIf

	For $i = 0 To $nCount - 1
		If $aUIDs[$i] <> "" Then
			$sUIDsDots &= StringStripWS($aUIDs[$i], 8) & ","
		EndIf
	Next

	$sUIDsDots = StringRegExpReplace($sUIDsDots, "^[,\h]+|[,\h]+$", "")
	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/getProfiles.xml?uids=" & $sUIDsDots & "&fields=" & $_sFields & "&name_case=" & $_sName_case & "&access_token=" & $_sAccessToken), 4)

	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		Dim $aFullArray[$nCount][UBound($aFields)]

		$aUsers = _CreateArray($sResponse, "user")

		For $i = 0 To UBound($aFields) - 1
			For $j = 0 To UBound($aUsers) - 1
				$aTemp = _CreateArray($aUsers[$j], StringStripWS($aFields[$i], 8))
				If IsArray($aTemp) Then $aFullArray[$j][$i] = $aTemp[0]
			Next
		Next

		Return $aFullArray
	EndIf
EndFunc   ;==>_VK_getProfiles

; #FUNCTION# =================================================================================================
; Name...........: _VK_getUserSettings()
; Description ...: �������� ��������� �������� ������������ � ������ ����������.
; Syntax.........: _VK_getUserSettings($_sAccessToken)
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������
;				   $_sUID - ������������� ������������. �� ��������� ������������� �������� ������������.
; Return values .: ����� - ������ � ������� ������ � @error = 0.
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Fever, Medic84
; Remarks .......: �����������
; ============================================================================================================
Func _VK_getUserSettings($_sAccessToken, $_sUID = "")
	Local $sReturn, $sResponse

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/getUserSettings.xml?access_token=" & $_sAccessToken & "&uid=" & $_sUID), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sReturn = _CreateArray($sResponse, "settings")
		Return $sReturn[0]
	EndIf
EndFunc   ;==>_VK_getUserSettings

; #FUNCTION# =================================================================================================
; Name...........: _VK_getUserBalance()
; Description ...: ���������� ������ �������� ������������ �� ����� ���������� � ����� ����� ������.
; Syntax.........: _VK_getUserBalance($_sAccessToken)
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
; Return values .: ����� - ������ � �������� ������������ � @error = 0.
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Medic84
; Remarks .......: ���� ������� ���������� 350, ��� ��������, ��� �� ������� ������������ � ������ ���������� ��� � ��������� ������.
; ============================================================================================================
Func _VK_getUserBalance($_sAccessToken)
	Local $sReturn, $sResponse

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/getUserBalance.xml?access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sReturn = _CreateArray($sResponse, "balance")
		Return $sReturn[0]
	EndIf
EndFunc   ;==>_VK_getUserBalance

#endregion Users Functions

#region Friends Functions

; #FUNCTION# =================================================================================================
; Name...........: _VK_friendsGet()
; Description ...: ���������� ������ ��������������� ������ ������������ ��� ����������� ���������� � ������� ������������
; Syntax.........: _VK_friendsGet($_sAccessToken, $_sUID = "", $_sFields = "", $_sName_case = "", $_iCount = "", $_sOffset = "")
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
;                  $_sUID - ������������� ������������, ������ �������� ���������� ��������. �� ��������� - ������� ������������
;                  $_sFields - ���� �����, ������� ���������� ��������. �� ��������� ������ �������������� �������������. ���� ������� full �� ������ ��������� ������ �� 27 �����
;                  $_sName_case - ����� ��� ��������� ����� � ������� ������������. �� ��������� ������������ �����.
;						��������� ��������: ������������ � nom, ����������� � gen, ��������� � dat, ����������� � acc, ������������ � ins, ���������� � abl.
;                  $_iCount - ���������� ������, ������� ����� �������. �� ��������� � ��� ������
;                  $_sOffset - ��������, ����������� ��� ������� ������������� ������������ ������.
; Return values .: ����� - ������ � ������� aFullArray[$Count][$CountFields] - ���:
;						$Count - ���������� ����� ����������� ������������
;						$CountFields - ���������� ����� ����. �� ���������:
;							0 - uid (������������� ������������)(���� $_sFields = "", �� ������� ������ ���� ������)
;							1 - first_name (���)
;							2 - last_name (�������)
;							3 - sex (���: 1 - �������, 2 - �������, 0 - ��� �������� ����. )
;							4 - online (������:  0 - ������������ �� � ����, 1 - ������������ � ����. )
;							5 - bdate (���� ��������. ������� � �������: "23.11.1981" ��� "21.9" (���� ��� �����). ���� ���� �������� ������ �������, �� ������ ������)
;							6 - city (������� id ������. �������� ������ �� ��� id ����� ������ ��� ������ ������� getCities. ���� ����� �� ������, �� ������ ������)
;							7 - country (������� id ������. �������� ������ �� � id ����� ������ ��� ������ ������ getCountries. ���� ������ �� �������, �� ������ ������)
;							8 - photo (������� url ���������� ������������, ������� ������ 50 ��������.)
;							9 - photo_medium (������� url ���������� ������������, ������� ������ 100 ��������.)
;							10 - photo_medium_rec (������� url ���������� ���������� ������������, ������� ������ 50 ��������.)
;							11 - photo_big (������� url ���������� ������������, ������� ������ 200 ��������.)
;							12 - photo_rec (������� url ���������� ���������� ������������, ������� ������ 50 ��������.)
;							13 - screen_name (���������� �������� ����� �������� (������������ ������ ��� ������, �������� andrew). ���� ������������ �� ����� ����� ����� ��������, ������������ 'id'+uid, �������� id35828305)
;							14 - has_mobile (����������, �������� �� ����� ���������� �������� ������������. ������������ ��������: 1 - ��������, 0 - �� ��������. )
;							15 - rate (������� ������������)
;							16 - home_phone (�������� ������� ������������)
;							17 - mobile_phone (��������� ������� ������������)
;							18 - university (��� ������������)
;							19 - university_name (�������� ������������)
;							20 - faculty (��� ����������)
;							21 - faculty_name (��� ����������)
;							22 - graduation (��� ��������� ��������)
;							23 - can_post (��������� �� ��������� ������ �� ����� � ������� ������������.)
;							24 - can_write_private_message (��������� �� ��������� ������ ��������� ������� ������������. )
;							25 - activity (���������� ������, ������������� � �������, ��� ������ ������������ )
;							26 - relation (���������� �������� ��������� ������������: 1 - �� �����/�� ������� 2 - ���� ����/���� ������� 3 - ���������/���������� 4 - �����/������� 5 - �� ������ 6 - � �������� ������ 7 - ������/�������� )
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Fever, Medic84
; Remarks .......: ��� ������ ���� ������� ���������� ������ ����� ����� � ������� ������, ���������� 2.
;				   ���� � $_sFields ����� ������� ���� contacts, �� ����� ���������� 1 �������������� ����
;				   ���� � $_sFields ����� ������� ���� education, �� ����� ���������� 4 �������������� ����
; ============================================================================================================
Func _VK_friendsGet($_sAccessToken, $_sUID = "", $_sFields = "", $_sName_case = "", $_iCount = "", $_sOffset = "")
	Local $aFields, $sResponse, $aTemp, $aUsers

	If $_sFields = "" Then
		$_sFields = "uid"
	ElseIf $_sFields = "full" Then
		$_sFields = "uid,first_name,last_name,sex,online,bdate,city,country,photo,photo_medium,photo_medium_rec," _
				 & "photo_big,photo_rec,screen_name,has_mobile,rate,contacts,education,can_post,can_write_private_message,activity,relation"
	EndIf

	$aFields = StringReplace($_sFields, "contacts", "home_phone,mobile_phone")
	$aFields = StringReplace($aFields, "education", "university,university_name,faculty,faculty_name,graduation")

	$aFields = StringSplit($aFields, ",", 2)


	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/friends.get.xml?uid=" & $_sUID & "&fields=" & $_sFields & "&name_case=" & $_sName_case & "&count=" & $_iCount & "&offset=" & $_sOffset & "&access_token=" & $_sAccessToken), 4)

	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$aUsers = _CreateArray($sResponse, "user")

		Dim $aFullArray[UBound($aUsers)][UBound($aFields)]

		For $i = 0 To UBound($aFields) - 1
			For $j = 0 To UBound($aUsers) - 1
				$aTemp = _CreateArray($aUsers[$j], StringStripWS($aFields[$i], 8))
				If IsArray($aTemp) Then $aFullArray[$j][$i] = $aTemp[0]
			Next
		Next

		Return $aFullArray
	EndIf
EndFunc   ;==>_VK_friendsGet

; #FUNCTION# =================================================================================================
; Name...........:  _VK_friendsGetOnline()
; Description ...: ���������� ������ ���������������, ����������� �� ����� ������, �������� ������������.
; Syntax.........: _VK_friendsGetOnline($_sAccessToken, $_sUID = "")
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
;                  $_sUID - ������������� ������������, ������ �������� ���������� ��������. �� ��������� - ������� ������������
; Return values .: ����� - ������ ��������������� � @error = 0.
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Fever, Medic84
; Remarks .......: ��� ������ ���� ������� ���������� ������ ����� ����� � ������� ������, ���������� 2.
; ============================================================================================================
Func _VK_friendsGetOnline($_sAccessToken, $_sUID = "")
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/friends.getOnline.xml?uid=" & $_sUID & "&access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsGetOnline

; #FUNCTION# =================================================================================================
; Name...........: _VK_friendsGetMutual()
; Description ...: ���������� ������ ��������������� ����� ������ ����� ����� �������������.
; Syntax.........: _VK_friendsGetMutual($_sAccessToken, $_sTarget_uid, $_sSource_uid = "")
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
;                  $_sTarget_uid - ������������� ������������, � ������� ���������� ������ ����� ������.
;                  $_sSource_uid - ������������� ������������, ��� ������ ������������ � �������� ������������ � ��������������� target_uid
;				   �� ��������� - ������� ������������
; Return values .: ����� - ������ ��������������� � @error = 0.
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Medic84
; Remarks .......: ��� ������ ���� ������� ���������� ������ ����� ����� � ������� ������, ���������� 2.
; ============================================================================================================
Func _VK_friendsGetMutual($_sAccessToken, $_sTarget_uid, $_sSource_uid = "")
	Local $sResponse, $asReturn

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/friends.getMutual.xml?access_token=" & $_sAccessToken & "&target_uid=" & $_sTarget_uid & "&source_uid=" & $_sSource_uid), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$asReturn = _CreateArray($sResponse, "uid")
		Return $asReturn
	EndIf
EndFunc   ;==>_VK_friendsGetMutual

; #FUNCTION# =================================================================================================
; Name...........: _VK_friendsAddList()
; Description ...: ������� ����� ������ ������ � �������� ������������.
; Syntax.........: _VK_friendsAddList($_sAccessToken, $sName, $_sUIDs)
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
;                  $sName - ��� ������
;                  $_sUIDs - �������������� ������, ������� ���������� ������� � ������
;				   		����� �������� ��� ��������, ��� � ������������� ��������������� ����� �������
; Return values .: ����� - ������������� ������ � @error = 0.
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Medic84
; Remarks .......: ��� ������ ���� ������� ���������� ������ ����� ����� � ������� ������, ���������� 2.
; ============================================================================================================
Func _VK_friendsAddList($_sAccessToken, $sName, $_sUIDs)
	Local $sUIDsDots = "", $sResponse, $aUIDs, $sReturn

	If Not IsArray($_sUIDs) Then
		$aUIDs = StringRegExpReplace($_sUIDs, "^[,\h]+|[,\h]+$", "")
		$aUIDs = StringSplit($aUIDs, ",", 2)
	Else
		$aUIDs = $_sUIDs
	EndIf

	For $i = 0 To UBound($aUIDs) - 1
		If $aUIDs[$i] <> "" Then
			$sUIDsDots &= StringStripWS($aUIDs[$i], 8) & ","
		EndIf
	Next

	$sUIDsDots = StringRegExpReplace($sUIDsDots, "^[,\h]+|[,\h]+$", "")

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/friends.addList.xml?access_token=" & $_sAccessToken & "&name=" & $sName & "&uids=" & $sUIDsDots), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sReturn = _CreateArray($sResponse, "lid")
		Return $sReturn[0]
	EndIf
EndFunc   ;==>_VK_friendsAddList

#endregion Friends Functions

#region Group Functions

; #FUNCTION# =================================================================================================
; Name...........: _VK_groupsGet()
; Description ...: ���������� ������ ����� ���������� ������������.
; Syntax.........: _VK_groupsGet($_sAccessToken, $iExtended = 0, $_sUID = "")
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
;                  $iExtended - ����������� ������ ���������� � ������� ������������. �� ��������� - ���
;                  $_sUID - ������������� ������������ � �������� ����� �������� ������ �����
; Return values .: ����� - ������ � �������  aFullArray[$Count][$CountFields] - ���:
;						$Count - ���������� ����� ���������� ������
;						$CountFields - ���������� ����� ����:
;							0 - gid (���� $iExtended = 0, �� ������� ������ ��� ����)
;							1 - name
;							2 - screen_name
;							3 - is_closed
;							4 - is_admin
;							5 - photo
;							6 - photo_medium
;							7 - photo_big
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Medic84
; Remarks .......: ��� ������ ���� ������� ���������� ������ ����� ����� � ������� ������, ���������� 262144.
; ============================================================================================================
Func _VK_groupsGet($_sAccessToken, $iExtended = 0, $_sUID = "")
	Local $Temp, $sResponse, $sReturn0, $asFields[8] = ["gid", "name", "screen_name", "is_closed", "is_admin", "photo", "photo_medium", "photo_big"]

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/groups.get.xml?uid=" & $_sUID & "&access_token=" & $_sAccessToken & "&extended=" & $iExtended), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sReturn0 = _CreateArray($sResponse, $asFields[0])

		If $iExtended Then
			For $i = 1 To UBound($asFields) - 1
				$Temp = _CreateArray($sResponse, $asFields[$i])
				Assign('sReturn' & $i, $Temp)
			Next
		EndIf

		Dim $aFullArray[UBound($sReturn0)][UBound($asFields)]

		For $i = 0 To UBound($sReturn0) - 1
			For $j = 0 To UBound($asFields) - 1
				$aFullArray[$i][$j] = Execute('$sReturn' & $j & '[$i]')
			Next
		Next

		Return $aFullArray
	EndIf
EndFunc   ;==>_VK_groupsGet

; #FUNCTION# =================================================================================================
; Name...........: _VK_groupsGetByID()
; Description ...: ���������� ���������� � �������� ������ ��� � ���������� �������.
; Syntax.........: _VK_groupsGetByID($_sAccessToken, $_sGIDs)
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
;                  $_sGIDs - �������������� �����, ���������� � ������� ���������� ��������. ����� ���� ������������ �������� ����� �����.
;			       �������� ����� ���� �������� ���� � ���� ������, ��� �������������� ����������� ����� �������, ���� � ���� �������. �������� 500 �����.
; Return values .: ����� - ������ � �������  aFullArray[$Count][$CountFields] - ���:
;						$Count - ���������� ����� ���������� ������
;						$CountFields - ���������� ����� ����:
;							0 - gid
;							1 - name
;							2 - screen_name
;							3 - is_closed
;							4 - is_admin
;							5 - photo
;							6 - photo_medium
;							7 - photo_big
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Medic84
; Remarks .......: ��� ������ ���� ������� ���������� ������ ����� ����� � ������� ������, ���������� 262144.
;				   ���� � ������ ��� � ������� ����� ����� 500 �����, �� ����� ������ ������ ������ 500
; ============================================================================================================
Func _VK_groupsGetByID($_sAccessToken, $_sGIDs)
	Local $sResponse, $asFields[8] = ["gid", "name", "screen_name", "is_closed", "is_admin", "photo", "photo_medium", "photo_big"]
	Local $sGIDsDots, $aGIDs, $nCount, $Temp

	If Not IsArray($_sGIDs) Then
		$aGIDs = StringSplit($_sGIDs, ",", 2)
	Else
		$aGIDs = $_sGIDs
	EndIf

	If UBound($aGIDs) > 500 Then
		$nCount = 500
	Else
		$nCount = UBound($aGIDs)
	EndIf

	For $i = 0 To $nCount - 1
		If $aGIDs[$i] <> "" Then
			$sGIDsDots &= StringStripWS($aGIDs[$i], 8) & ","
		EndIf
	Next

	$sGIDsDots = StringRegExpReplace($sGIDsDots, "^[,\h]+|[,\h]+$", "")
	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/groups.getById.xml?gids=" & $sGIDsDots & "&access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else

		$aGroups = _CreateArray($sResponse, "group")

		Dim $aFullArray[UBound($aGroups)][UBound($asFields)]

		For $i = 0 To UBound($asFields) - 1
			For $j = 0 To UBound($aGroups) - 1
				$aTemp = _CreateArray($aGroups[$j], StringStripWS($asFields[$i], 8))
				If IsArray($aTemp) Then $aFullArray[$j][$i] = $aTemp[0]
			Next
		Next

		Return $aFullArray
	EndIf
EndFunc   ;==>_VK_groupsGetByID

#endregion Group Functions

#region Audio Functions

; #FUNCTION# =================================================================================================
; Name...........: _VK_audioGet()
; Description ...: ���������� ������ ������������ ������������ ��� ������.
; Syntax.........: _VK_audioGet($_sAccessToken, $_sUID = "", $_sGID = "")
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
;                  $_iNeed_User - ���� ���� �������� ����� 1, ������ ��������� ������� ���������� � ��������� ������������
;                  $_sUID - id ������������, �������� ����������� ����������� (�� ��������� � ������� ������������)
;                  $_sGID - id ������, ������� ����������� �����������. ���� ������ �������� gid, uid ������������.
;                  $_iAlbumID - id �������, ����������� �������� ���������� ������� (�� ��������� ������������ ����������� �� ���� ��������).
;                  $_sAIDs - ������������� ����� ������� id ������������, �������� � ������� �� uid ��� gid.
;                  $_iCount - ���������� ������������ ������������.
;                  $_iOffset - �������� ������������ ������ ��������� ����������� ��� ������� ������������� ������������.
; Return values .: ����� - ������ � �������  aFullArray[$Count][$CountFields] - ���:
;						$Count - ���������� ����� ���������� ����������� (������� � 1, ������� ������� ������ ����)
;						$CountFields - ���������� ����� ����. �� ���������:
;							0 - aid (������������� �����������)
;							1 - owner_id (id ������������, �������� ����������� �����������)
;							2 - artist (����������� �����������)
;							3 - title (�������� �����������)
;							4 - duration (������������ ����������� � ��������)
;							5 - url (������ �� �����������)
;						[0][0] - ���������� ���������� ������������.
;						���� $_iNeed_User = 1, �� ���������� � ������������ ����� � 0 ������:
;							[0][1] - id (������������� ������������)
;							[0][2] - photo (������� url ���������� ������������, ������� ������ 50 ��������.)
;							[0][3] - name (��� ������� ������������)
;							[0][4] - name_gen (��� ������������ � ����������� ������)
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Medic84
; Remarks .......: ��� ������ ���� ������� ���������� ������ ����� ����� � ������� ������, ���������� 8.
;				   �������� ��������, ��� ������ �� ����������� ��������� � ip ������.
; ============================================================================================================
Func _VK_audioGet($_sAccessToken, $_iNeed_User = 0, $_sUID = "", $_sGID = "", $_iAlbumID = "", $_sAIDs = "", $_iCount = "", $_iOffset = "")
	Local $Temp, $sResponse, $asFields[6] = ["aid", "owner_id", "artist", "title", "duration", "url"]
	Local $aOwnerFields[4] = ["id", "photo", "name", "name_gen"]

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/audio.get.xml?access_token=" & $_sAccessToken & "&uid=" & $_sUID & "&gid=" & $_sGID & "&aids=" & $_sAIDs & "&need_user=" & $_iNeed_User & "&album_id=" & $_iAlbumID & "&count=" & $_iCount & "&offset=" & $_iOffset), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else

		$aAudio = _CreateArray($sResponse, "audio")

		Dim $aFullArray[UBound($aAudio) + 1][UBound($asFields)]

		$aFullArray[0][0] = UBound($aAudio)

		If $_iNeed_User Then
			$aOwner = _CreateArray($sResponse, "user")
			If IsArray($aOwner) Then
				For $i = 0 To UBound($aOwnerFields) - 1
					$Temp = _CreateArray($aOwner[0], $aOwnerFields[$i])
					$aFullArray[0][$i + 1] = $Temp[0]
				Next
			EndIf
		EndIf

		For $i = 0 To UBound($asFields) - 1
			For $j = 0 To UBound($aAudio) - 1
				$aTemp = _CreateArray($aAudio[$j], StringStripWS($asFields[$i], 8))
				If IsArray($aTemp) Then $aFullArray[$j + 1][$i] = $aTemp[0]
			Next
		Next

		Return $aFullArray
	EndIf
EndFunc   ;==>_VK_audioGet

#endregion Audio Functions

#region Status Functions

; #FUNCTION# =================================================================================================
; Name...........: _VK_statusGet()
; Description ...: �������� ������ ������������.
; Syntax.........: _VK_statusGet($_sAccessToken, $_sUID = "")
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
;                  $_sUID - UID ������������ � �������� ��������� �������� ������. �� ��������� - ������� ������������
; Return values .: ����� - ������ �� �������� � @error = 0.
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Fever, Medic84
; Remarks .......: ��� ������ ���� ������� ���������� ������ ����� ����� � ������� ������, ���������� 1024.
; ============================================================================================================
Func _VK_statusGet($_sAccessToken, $_sUID = "")
	Local $sStatus, $sResponse

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/status.get.xml?uid=" & $_sUID & "&access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sStatus = _CreateArray($sStatus, "text")
		Return $sStatus[0]
	EndIf
EndFunc   ;==>_VK_statusGet

; #FUNCTION# =================================================================================================
; Name...........: _VK_statusSet()
; Description ...: ������������� ����� ������ �������� ������������.
; Syntax.........: _VK_statusSet($_sAccessToken, $_sText = "")
; Parameters ....: $_sAccessToken - ������������ ���������� �������� ��� ���������� ����� � ���������
;                  $_sText - ����� �������, ������� ���������� ����������.  �� ��������� - �������� �������
; Return values .: ����� - 1 � @error = 0.
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Fever, Medic84
; Remarks .......: ��� ������ ���� ������� ���������� ������ ����� ����� � ������� ������, ���������� 1024.
; ============================================================================================================
Func _VK_statusSet($_sAccessToken, $_sText = "")
	Local $sStatus, $sResponse

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/status.set.xml?text=" & $_sText & "&access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sStatus = _CreateArray($sResponse, "response")
		Return $sStatus[0]
	EndIf
EndFunc   ;==>_VK_statusSet

#endregion Status Functions

#region Photos Functions

; #FUNCTION# =================================================================================================
; Name...........: _VK_photosGetAlbums()
; Description ...: ���������� ������ �������� ������������.
; Syntax.........:  _VK_photosGetAlbums($_sAccessToken, $_iNeed_Covers = 0 , $_sUID = "", $_sGID = "", $_sAIDs = "")
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
;                  $_iNeed_Covers - ����� ���������� �������������� ���� thumb_src. �� ��������� ���� thumb_src �� ������������.
;                  $_sUID - ID ������������, �������� ����������� �������. �� ��������� � ID �������� ������������.
;				   $_sGID - ID ������, ������� ����������� �������.
;				   $_sAIDs - ������������� ����� ������� ID ��������.
; Return values .: ����� - ������ � �������  aFullArray[$Count][$CountFields] - ���:
;						$Count - ���������� ����� ���������� ����������
;						$CountFields - ���������� ����� ����. �� ���������:
;							0 - aid (������������� �������)
;							1 - owner_id (������������� ���������)
;							2 - title (�������� �������)
;							3 - description (�������� �������)
;							4 - created (���� ��������)
;							5 - updated (���� ����������)
;							6 - size (���������� ���������� � �������)
;							7 - privacy (������� ������� � �������. ��������: 0 � ��� ������������, 1 � ������ ������, 2 � ������ � ������ ������, 3 - ������ �.)
;							8 - thumb_id (������������� ���������� �������)
;							9 - thumb_src (url ���������� �������. ���� �������� ������ ���� $_iNeed_Covers ����� 1)
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Fever, Medic84
; Remarks .......: ��� ������ ���� ������� ���������� ������ ����� ����� � ������� ������, ���������� 4.
; ============================================================================================================
Func _VK_photosGetAlbums($_sAccessToken, $_iNeed_Covers = 0, $_sUID = "", $_sGID = "", $_sAIDs = "")
	Local $aTemp, $sResponse, $Temp, $aAlbums

	If $_iNeed_Covers Then
		Dim $asFields[10] = ["aid", "owner_id", "title", "description", "created", "updated", "size", "privacy", "thumb_id", "thumb_src"]
	Else
		Dim $asFields[9] = ["aid", "owner_id", "title", "description", "created", "updated", "size", "privacy", "thumb_id"]
	EndIf

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/photos.getAlbums.xml?uid=" & $_sUID & "&aids=" & $_sAIDs & "&gid=" & $_sGID & "&need_covers=" & $_iNeed_Covers & "&access_token=" & $_sAccessToken), 4)

	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$aAlbums = _CreateArray($sResponse, "album")

		Dim $aFullArray[UBound($aAlbums)][UBound($asFields)]

		For $i = 0 To UBound($asFields) - 1
			For $j = 0 To UBound($aAlbums) - 1
				$aTemp = _CreateArray($aAlbums[$j], StringStripWS($asFields[$i], 8))
				If IsArray($aTemp) Then
					If ($i = 5) Or ($i = 4) Then $aTemp[0] = _StringFormatTime("%d.%m.%y %H:%M", $aTemp[0])
					$aFullArray[$j][$i] = $aTemp[0]
				EndIf
			Next
		Next

		Return $aFullArray
	EndIf
EndFunc   ;==>_VK_photosGetAlbums

; #FUNCTION# =================================================================================================
; Name...........: _VK_photosGet
; Description ...: ���������� ������ ���������� � �������.
; Syntax.........: _VK_photosGet($_sAccessToken, $_sUID, $_sGID, $_sAID, $_iExtended = 0, $_iPIDs = "", $_iLimit = "", $_iOffset = "")
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
;                  $_sUID - ID ������������, �������� ����������� ������ � ������������.
;                  $_sGID - ID ������, ������� ����������� ������ � ������������.
;                  $_sAID - ID ������� � ������������.
;                  $_iExtended - ���� ����� 1, �� ����� ���������� �������������� ���� likes. �� ��������� ���� likes �� ������������.
;                  $_iPIDs - ������������� ����� ������� ID ����������.
;                  $_iLimit - ���������� ����������, ������� ����� �������. (�� ��������� � ��� ����������)
;                  $_iOffset - ��������, ����������� ��� ������� ������������� ������������ ����������.
; Return values .: ����� - ������ � �������  aFullArray[$Count][$CountFields] - ���:
;						$Count - ���������� ����� ���������� ����������
;						$CountFields - ���������� ����� ����. �� ���������:
;							0 - aid (������������� �������)
;							1 - owner_id (������������� ���������)
;							2 - src 		====|
;							3 - src_small 		|===|
;							4 - src_big 			|====> url'� ����������� ������� ��������
;							5 - src_xbig 		|===|
;							6 - src_xxbig 	====|
;							7 - text (������� � ����������)
;							8 - created (���� ��������)
;							9 - count (���������� likes ����������. ���� �������� ������ ���� $_iExtended ����� 1)
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Fever, Medic84
; Remarks .......: ��� ������ ���� ������� ���������� ������ ����� ����� � ������� ������, ���������� 4.
; ============================================================================================================
Func _VK_photosGet($_sAccessToken, $_sUID, $_sGID, $_sAID, $_iExtended = 0, $_iPIDs = "", $_iLimit = "", $_iOffset = "")
	Local $sReturn0, $sResponse, $Temp

	If Not $_sUID Then $_sUID = ""
	If Not $_sGID Then $_sGID = ""

	If $_iExtended Then
		Dim $asFields[10] = ["aid", "owner_id", "src", "src_small", "src_big", "src_xbig", "src_xxbig", "text", "created", "count"]
	Else
		Dim $asFields[9] = ["aid", "owner_id", "src", "src_small", "src_big", "src_xbig", "src_xxbig", "text", "created"]
	EndIf

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/photos.get.xml?uid=" & $_sUID & "&aid=" & $_sAID & "&gid=" & $_sGID & "&pids=" & $_iPIDs & "&extended=" & $_iExtended & "&limit=" & $_iLimit & "&offset=" & $_iOffset & "&access_token=" & $_sAccessToken), 4)

	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else

		$aPhotos = _CreateArray($sResponse, "photo")

		Dim $aFullArray[UBound($aPhotos)][UBound($asFields)]

		For $i = 0 To UBound($asFields) - 1
			For $j = 0 To UBound($aPhotos) - 1
				$aTemp = _CreateArray($aPhotos[$j], StringStripWS($asFields[$i], 8))
				If IsArray($aTemp) Then
					If $i = 8 Then $aTemp[0] = _StringFormatTime("%d.%m.%y %H:%M", $aTemp[0])
					$aFullArray[$j][$i] = $aTemp[0]
				EndIf
			Next
		Next

		Return $aFullArray
	EndIf
EndFunc   ;==>_VK_photosGet

; #FUNCTION# =================================================================================================
; Name...........: _VK_photosGetAlbumsCount()
; Description ...: ���������� ���������� ��������� �������� ������������.
; Syntax.........: _VK_photosgetAlbumsCount($_sAccessToken, $_sUID = "", $_sGID = "")
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
;                  $_sUID - ID ������������, �������� ����������� �������. �� ��������� � ID �������� ������������.
;                  $_sGID - ID ������, ������� ����������� �������.
; Return values .: ����� - ������ � ����������� �������� � @error = 0.
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Medic84
; Remarks .......: �����������
; ============================================================================================================
Func _VK_photosGetAlbumsCount($_sAccessToken, $_sUID = "", $_sGID = "")
	Local $sCount, $sResponse

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/photos.getAlbumsCount.xml?uid=" & $_sUID & "&gid=" & $_sGID & "&access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sCount = _CreateArray($sResponse, "response")
		Return $sCount[0]
	EndIf
EndFunc   ;==>_VK_photosgetAlbumsCount

; #FUNCTION# =================================================================================================
; Name...........: _VK_photosGetById()
; Description ...: ���������� ���������� � ����������� �� �� ���������������.
; Syntax.........: _VK_photosGetById($_sAccessToken, $_sPhotos, $_iExtended = 0)
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
;                  $_sPhotos - ������������� ����� ������� �������������� (���� ������), ������� ������������ ����� ������ �����
;				   		���� ������������� id �������������, ������������ ����������, � id ����� ����������. ����� ��������
;				   		���������� � ���������� � ������� ������, ������ id ������������ ������� ������� -id ������.
;                  $_iExtended - ���� ����� 1, �� ����� ���������� �������������� ���� likes. �� ��������� ���� likes �� ������������.
; Return values .: ����� - ������ � �������  aFullArray[$Count][$CountFields] - ���:
;						$Count - ���������� ����� ���������� ����������
;						$CountFields - ���������� ����� ����. �� ���������:
;							0 - aid (������������� �������)
;							1 - owner_id (������������� ���������)
;							2 - src 		====|
;							3 - src_small 		|===|
;							4 - src_big 			|====> url'� ����������� ������� ��������
;							5 - src_xbig 		|===|
;							6 - src_xxbig 	====|
;							7 - text (������� � ����������)
;							8 - created (���� ��������)
;							9 - count (���������� likes ����������. ���� �������� ������ ���� $_iExtended ����� 1)
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Fever, Medic84
; Remarks .......: ��� ������ ���� ������� ���������� ������ ����� ����� � ������� ������, ���������� 4.
; ============================================================================================================
Func _VK_photosGetById($_sAccessToken, $_sPhotos, $_iExtended = 0)
	Local $aPhoto, $sResponse, $aTemp, $sPhotosDots, $aPhotos

	If $_iExtended Then
		Dim $asFields[10] = ["aid", "owner_id", "src", "src_small", "src_big", "src_xbig", "src_xxbig", "text", "created", "count"]
	Else
		Dim $asFields[9] = ["aid", "owner_id", "src", "src_small", "src_big", "src_xbig", "src_xxbig", "text", "created"]
	EndIf

	If Not IsArray($_sPhotos) Then
		$aPhoto = StringSplit($_sPhotos, ",", 2)
	Else
		$aPhoto = $_sPhotos
	EndIf

	For $i = 0 To UBound($aPhoto) - 1
		If $aPhoto[$i] <> "" Then
			$sPhotosDots &= StringStripWS($aPhoto[$i], 8) & ","
		EndIf
	Next

	$sPhotosDots = StringRegExpReplace($sPhotosDots, "^[,\h]+|[,\h]+$", "")


	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/photos.getById.xml?photos=" & $sPhotosDots & "&extended=" & $_iExtended & "&access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$aPhotos = _CreateArray($sResponse, "photo")

		Dim $aFullArray[UBound($aPhotos)][UBound($asFields)]

		For $i = 0 To UBound($asFields) - 1
			For $j = 0 To UBound($aPhotos) - 1
				$aTemp = _CreateArray($aPhotos[$j], StringStripWS($asFields[$i], 8))
				If IsArray($aTemp) Then
					If $i = 8 Then $aTemp[0] = _StringFormatTime("%d.%m.%y %H:%M", $aTemp[0])
					$aFullArray[$j][$i] = $aTemp[0]
				EndIf
			Next
		Next

		Return $aFullArray
	EndIf
EndFunc   ;==>_VK_photosGetById

; #FUNCTION# =================================================================================================
; Name...........: _VK_photosGetAll()
; Description ...: ���������� ��� ���������� ������������ ��� ������ � ������������������� �������.
; Syntax.........: _VK_photosGetAll($_sAccessToken, $_iExtended = 0, $_sCount = "", $_sOffset = "")
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
;                  $_iExtended - ���� ����� 1, �� ����� ���������� �������������� ���� likes. �� ��������� ���� likes �� ������������.
;                  $_sOwnerID -������������� ������������ (�� ��������� - ������� ������������). ���� �������� ������������� ��������,
;								������ ���������� ������������ ����� ���������� ��� ���������� ������ � ��������������� -owner_id.
;                  $_sCount - ���������� ����������, ������� ���������� �������� (�� �� ����� 100). �� ��������� 100
;                  $_sOffset - ��������, ����������� ��� ������� ������������� ������������ ����������.
; Return values .: ����� - ������ � �������  aFullArray[$Count][$CountFields] - ���:
;						$Count - ���������� ����� ���������� ����������
;						$CountFields - ���������� ����� ����. �� ���������:
;							1 - pid (������������� ����������)
;							1 - aid (������������� �������)
;							2 - owner_id (������������� ���������)
;							3 - src 		====|
;							4 - src_small 		|===|
;							5 - src_big 			|====> url'� ����������� ������� ��������
;							6 - src_xbig 		|===|
;							7 - src_xxbig 	====|
;							8 - text (������� � ����������)
;							9 - created (���� ��������)
;							10 - count (���������� likes ����������. ���� �������� ������ ���� $_iExtended ����� 1)
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Medic84
; Remarks .......: ��� ������ ���� ������� ���������� ������ ����� ����� � ������� ������, ���������� 4.
; ============================================================================================================
Func _VK_photosGetAll($_sAccessToken, $_iExtended = 0, $_sOwnerID = "", $_sCount = 100, $_sOffset = "")
	Local $sResponse, $aTemp

	If $_sCount > 100 Then $_sCount = 100

	If $_iExtended Then
		Dim $asFields[11] = ["pid", "aid", "owner_id", "src", "src_small", "src_big", "src_xbig", "src_xxbig", "text", "created", "count"]
	Else
		Dim $asFields[10] = ["pid", "aid", "owner_id", "src", "src_small", "src_big", "src_xbig", "src_xxbig", "text", "created"]
	EndIf

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/photos.getAll.xml?access_token=" & $_sAccessToken & "&count=" & $_sCount & "&owner_id=" & $_sOwnerID & "&extended=" & $_iExtended & "&offset=" & $_sOffset), 4)
	ConsoleWrite($sResponse)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$aPhotos = _CreateArray($sResponse, "photo")

		Dim $aFullArray[UBound($aPhotos) + 1][UBound($asFields)]

		$aFullArray[0][0] = UBound($aPhotos)

		For $i = 0 To UBound($asFields) - 1
			For $j = 0 To UBound($aPhotos) - 1
				$aTemp = _CreateArray($aPhotos[$j], StringStripWS($asFields[$i], 8))
				If IsArray($aTemp) Then
					If $i = 9 Then $aTemp[0] = _StringFormatTime("%d.%m.%y %H:%M", $aTemp[0])
					$aFullArray[$j + 1][$i] = $aTemp[0]
				EndIf
			Next
		Next

		Return $aFullArray
	EndIf
EndFunc   ;==>_VK_photosGetAll

; #FUNCTION# =================================================================================================
; Name...........: _VK_photos�reateAlbum()
; Description ...: ������� ������ ������ ��� ����������.
; Syntax.........: _VK_photos�reateAlbum($_sAccessToken, $_sTitle, $_sDescription = "", $_iPrivacy = 0, $_iComment_Privacy = 0)
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
;                  $_sTitle - �������� �������.
;                  $_sDescription - ����� �������� �������.
;                  $_iPrivacy - ������� ������� � �������. ��������: 0 � ��� ������������, 1 � ������ ������, 2 � ������ � ������ ������, 3 - ������ �.
;                  $_iComment_Privacy - ������� ������� � ��������������� �������. ��������: 0 � ��� ������������, 1 � ������ ������, 2 � ������ � ������ ������, 3 - ������ �.
; Return values .: ����� - ������ � �������  aFullArray[$CountFields] - ���:
;						$CountFields - ���������� ����� ����. �� ���������:
;							0 - aid (������������� �������)
;							1 - thumb_id (������������� ���������� �������)
;							2 - owner_id (������������� ���������)
;							3 - title (�������� �������)
;							4 - description (�������� �������)
;							5 - created (���� ��������)
;							6 - updated (���� ����������)
;							7 - size (���������� ���������� � �������)
;							8 - privacy (������� ������� � �������. ��������: 0 � ��� ������������, 1 � ������ ������, 2 � ������ � ������ ������, 3 - ������ �.)
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Medic84
; Remarks .......: ��� ������ ���� ������� ���������� ������ ����� ����� � ������� ������, ���������� 4.
; ============================================================================================================
Func _VK_photosCreateAlbum($_sAccessToken, $_sTitle, $_sDescription = "", $_iPrivacy = 0, $_iComment_Privacy = 0)
	Local $aRetArray, $sResponse
	Dim $asFields[9] = ["aid","thumb_id","owner_id","title","description","created","updated","size","privacy"]

	If Not $_sDescription = "" Then $_sDescription = BinaryToString(StringToBinary($_sDescription, 4))

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/photos.createAlbum.xml?title=" & $_sTitle & "&description=" & $_sDescription & "&privacy=" & $_iPrivacy & "&comment_privacy=" & $_iComment_Privacy & "&access_token=" & $_sAccessToken), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else

		For $i = 0 to UBound($asFields) - 1
			$aTemp = _CreateArray($sResponse, $asFields[$i])
			If $i = 6 or $i = 7 Then $aTemp[0] = _StringFormatTime("%d.%m.%y %H:%M", $aTemp[0])
			$aRetArray[$i] = $aTemp[0]
		Next

		Return $aRetArray
	EndIf
EndFunc   ;==>_VK_photosgetAlbumsCount

; #FUNCTION# =================================================================================================
; Name...........: _VK_photosEditAlbum()
; Description ...: ������� ������ ������ ��� ����������.
; Syntax.........: _VK_photosEditAlbum($_sAccessToken, $_sAID, $_sTitle, $_sDescription = -1, $_iPrivacy = -1, $_iComment_Privacy = -1)
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
;                  $_sAID - ������������� �������������� �������.
;                  $_sTitle - ����� �������� �������.
;                  $_sDescription - ����� ����� �������� �������.
;                  $_iPrivacy - ����� ������� ������� � �������. ��������: 0 � ��� ������������, 1 � ������ ������, 2 � ������ � ������ ������, 3 - ������ �.
;                  $_iComment_Privacy - ����� ������� ������� � ��������������� �������. ��������: 0 � ��� ������������, 1 � ������ ������, 2 � ������ � ������ ������, 3 - ������ �.
; Return values .: ����� - 1 � @error = 0.
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Medic84
; Remarks .......: ��� ������ ���� ������� ���������� ������ ����� ����� � ������� ������, ���������� 4.
; ============================================================================================================
Func _VK_photosEditAlbum($_sAccessToken, $_sAID, $_sTitle, $_sDescription = -1, $_iPrivacy = -1, $_iComment_Privacy = -1)
	Local $sRet, $sResponse, $sQuery = ""

	If Not $_sDescription = -1 Then
		$_sDescription = BinaryToString(StringToBinary($_sDescription, 4))
		$sQuery &= "&description=" & $_sDescription
	EndIf
	If Not $_iPrivacy = -1 Then $sQuery &= "&privacy=" & $_iPrivacy
	If Not $_iComment_Privacy = -1 Then $sQuery &= "&comment_privacy=" & $_iComment_Privacy

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/photos.editAlbum.xml?title=" & $_sTitle & "&access_token=" & $_sAccessToken & $sQuery), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sRet = _CreateArray($sResponse, "response")

		Return $sRet[0]
	EndIf
EndFunc   ;==>_VK_photosgetAlbumsCount
#endregion Photos Functions

#region Wall Functions
; #FUNCTION# =================================================================================================
; Name...........: _VK_wallPost()
; Description ...: ���������� ��� ���������� ������������ ��� ������ � ������������������� �������.
; Syntax.........: _VK_wallPost($_sAccessToken, $_sMessage = "", $_sAttashments = "", $_sOwner_ID = "", $_sServices = "", $_sFrom_Group = 0, $_sFriends_Only = 0)
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
;                  $_sMessage - ����� ��������� (�������� ������������, ���� �� ����� �������� attachment)
;                  $_sAttashments - ������ ��������, ����������� � ������ � ���������� �������� ",". ���� attachments �������������� � �������:
;						<type><owner_id>_<media_id>,<type><owner_id>_<media_id> ���:
;							<type> - ��� �����-����������:
;								photo - ����������
;								video - �����������
;								audio - �����������
;								doc - ��������
;						<owner_id> - ������������� ��������� �����-����������
;						<media_id> - ������������� �����-����������.
;				   $_sOwner_ID - ������������� ������������, � �������� ������ ���� ������������ ������. ���� �������� �� �����, �� ���������, ��� �� ����� �������������� �������� ������������.
;                  $_sServices - ������ �������� ��� ������, �� ������� ���������� �������������� ������, � ������ ���� ������������ �������� ��������������� �����. �������� twitter, facebook.
;                  $_sFrom_Group - ������ �������� �����������, ���� owner_id < 0 (������ ����������� �� ����� ������). 1 - ������ ����� ����������� �� ����� ������, 0 - ������ ����� ����������� �� ����� ������������ (�� ���������).
;                  $_sFriends_Only - 1 - ������ ����� �������� ������ �������, 0 - ���� �������������. �� ��������� ����������� ������� �������� ���� �������������.
; Return values .: ����� - ������ � ��������������� ������ � @error = 0.
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Medic84
; Remarks .......: ��� ������ ���� ������� ���������� ������ ����� ����� � ������� ������, ���������� 8192.
; ============================================================================================================
Func _VK_wallPost($_sAccessToken, $_sMessage = "", $_sAttashments = "", $_sOwner_ID = "", $_sServices = "", $_sFrom_Group = 0, $_sFriends_Only = 0)
	Local $sReturn, $sResponse

	If $_sAttashments = "" And $_sMessage = "" Then Return SetError(2, 0, -1)
	If Not $_sMessage = "" Then $_sMessage = BinaryToString(StringToBinary($_sMessage, 4))

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/wall.post.xml?access_token=" & $_sAccessToken & "&message=" & $_sMessage & "&attachments=" & $_sAttashments & "&owner_id=" & $_sOwner_ID & "&services=" & $_sServices & "&from_group=" & $_sFrom_Group & "&friends_only=" & $_sFriends_Only), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sReturn = _CreateArray($sResponse, "post_id")
		Return $sReturn[0]
	EndIf
EndFunc   ;==>_VK_wallPost

; #FUNCTION# =================================================================================================
; Name...........: _VK_wallDelete()
; Description ...: ���������� ��� ���������� ������������ ��� ������ � ������������������� �������.
; Syntax.........: _VK_wallDelete($_sAccessToken, $_sPost_ID, $_sOwner_ID = "")
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
;                  $_sPost_ID - ������������� ������ �� ����� ������������.
;                  $_sOwnerID - ������������� ������������, �� ���� ����� ���������� ������� ������. ���� �������� �� �����, �� �� ��������� ������ �������������� �������� ������������.
; Return values .: ����� - 1 � @error = 0.
;                  ������� - ������ �������� ������ � @error = 1
; Author ........: Medic84
; Remarks .......: ��� ������ ���� ������� ���������� ������ ����� ����� � ������� ������, ���������� 8192.
; ============================================================================================================
Func _VK_wallDelete($_sAccessToken, $_sPost_ID, $_sOwner_ID = "")
	Local $sReturn, $sResponse

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/wall.delete.xml?access_token=" & $_sAccessToken & "&post_id=" & $_sPost_ID & "&owner_id=" & $_sOwner_ID), 4)
	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sReturn = _CreateArray($sResponse, "response")
		Return $sReturn[0]
	EndIf
EndFunc   ;==>_VK_wallDelete
#endregion Wall Functions

#region Likes Functions

; #FUNCTION# =================================================================================================
; Name...........: _VK_likesAdd()
; Description ...: ��������� ��������� ������ � ������ ��� �������� �������� ������������.
; Syntax.........: _VK_likesAdd($_sAccessToken, $_sType, $_iItem_id, $_sUID = "")
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
;    			   $_sType - ������������� ���� Like-�������.
;				   $_iItem_id - ������������� Like-�������.
;				   $_sOwnerID - ������������� ��������� Like-�������. ���� �������� �� �����, �� ���������, ��� �� ����� ������������� �������� ������������.
; Return values .: ����� - ������ � ����������� �������������, ������� �������� ������ ������ � ���� ������ ��� �������� � @error = 0.
;				   ������� - ������ �������� ������ � @error = 1
; Author ........: Fever
; Remarks .......: ���� Like-��������:
;					post - ������ �� ����� ������������ ��� ������
;					comment - ����������� � ������ �� �����
;					photo - ����������
;					audio - �����������
;					video - �����������
;					note - �������
;					sitepage - �������� �����, �� ������� ���������� ������ ���� ���������
;
;				   ��� ������ ����� ������ ���� ���������� ������ ����� ����� � ������� ������, ���������� 8192.
; ============================================================================================================
Func _VK_likesAdd($_sAccessToken, $_sType, $_iItem_id, $_sOwnerID = "")
	Local $sLikes, $sResponse

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/likes.add.xml?owner_id=" & $_sOwnerID & "&type=" & $_sType & "&item_id" & $_iItem_id & "&access_token=" & $_sAccessToken), 4)

	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sLikes = _CreateArray($sResponse, "likes")
		Return $sLikes[0]
	EndIf
EndFunc   ;==>_VK_likesAdd

; #FUNCTION# =================================================================================================
; Name...........: _VK_likesDelete()
; Description ...: ������� ��������� ������ �� ������ ��� �������� �������� ������������.
; Syntax.........: _VK_likesDelete($_sAccessToken, $_sType, $_iItem_id, $_sUID = "")
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
;				   $_sType - ������������� ���� Like-�������.
;				   $_iItem_id - ������������� Like-�������.
;				   $_sOwnerID - ������������� ��������� Like-�������. ���� �������� �� �����, �� ���������, ��� �� ����� ������������� �������� ������������.
; Return values .: ����� - ������ � ����������� �������������, ������� �������� ������ ������ � ���� ������ ��� �������� � @error = 0.
;				   ������� - ������ �������� ������ � @error = 1
; Author ........: Fever
; Remarks .......: ���� Like-��������:
;					post - ������ �� ����� ������������ ��� ������
;					comment - ����������� � ������ �� �����
;					photo - ����������
;					audio - �����������
;					video - �����������
;					note - �������
;					sitepage - �������� �����, �� ������� ���������� ������ ���� ���������
;
;				   ��� ������ ����� ������ ���� ���������� ������ ����� ����� � ������� ������, ���������� 8192.
; ============================================================================================================
Func _VK_likesDelete($_sAccessToken, $_sType, $_iItem_id, $_sOwnerID = "")
	Local $sLikes, $sResponse

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/likes.delete.xml?owner_id=" & $_sOwnerID & "&type=" & $_sType & "&item_id" & $_iItem_id & "&access_token=" & $_sAccessToken), 4)

	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sLikes = _CreateArray($sResponse, "likes")
		Return $sLikes[0]
	EndIf
EndFunc   ;==>_VK_likesDelete

; #FUNCTION# =================================================================================================
; Name...........: _VK_likesIsLiked()
; Description ...: ��������� ��������� �� ������ � ������ ��� �������� ��������� ������������.
; Syntax.........: _VK_likesIsLiked($_sAccessToken, $_sType, $_iItem_id, $_sUserID = "", $_sOwnerID = "")
; Parameters ....: $_sAccessToken - ���� ������� �������� �������� �����������.
;				   $_sType - ������������� ���� Like-�������.
;				   $_iItem_id - ������������� Like-�������.
;				   $_sUserID - ������������� ������������ � �������� ���������� ��������� ������� ������� � ������ ��� ��������.
;				   ���� �������� �� �����, �� ���������, ��� �� ����� �������������� �������� ������������.
;				   $_sOwnerID - ������������� ��������� Like-�������. ���� �������� �� �����, �� ���������, ��� �� ����� ������������� �������� ������������.
; Return values .: ����� - @error = 0, ���������� ���� �� ��������� ��������:
;				   		0 � ��������� Like-������ �� ������ � ������ ��� �������� ������������ � ��������������� user_id.
;				   		1 � ��������� Like-������ ��������� � ������ ��� �������� ������������ � ��������������� user_id.
;				   ������� - ������ �������� ������ � @error = 1
; Author ........: Fever
; Remarks .......: ���� Like-��������:
;					post - ������ �� ����� ������������ ��� ������
;					comment - ����������� � ������ �� �����
;					photo - ����������
;					audio - �����������
;					video - �����������
;					note - �������
;					sitepage - �������� �����, �� ������� ���������� ������ ���� ���������
;
;				   ��� ������ ����� ������ ���� ���������� ������ ����� ����� � ������� ������, ���������� 8192.
; ============================================================================================================
Func _VK_likesIsLiked($_sAccessToken, $_sType, $_iItem_id, $_sUserID = "", $_sOwnerID = "")
	Local $sResponse

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/likes.isLiked.xml?user_id=" & $_sUserID & "&owner_id=" & $_sOwnerID & "&type=" & $_sType & "&item_id" & $_iItem_id & "&access_token=" & $_sAccessToken), 4)

	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sResponse = _CreateArray($sResponse, "response")
		Return $sResponse[0]
	EndIf
EndFunc   ;==>_VK_likesIsLiked

; #FUNCTION# =================================================================================================
; Name...........: _VK_likesGetList()
; Description ...: �������� ������ ��������������� �������������, ������� �������� �������� ������ � ���� ������ ��� ��������.
; Syntax.........: _VK_likesGetList($_sType, $_sOwnerID = "", $_iItem_id = "", $_sPageURL = "", $_sFilter = "", $_iFriendsOnly = 0, $_iOffset = 0, $_iCount = 100)
; Parameters ....: $_sType - ������������� ���� Like-�������.
;				   $_sOwnerID - ������������� ��������� Like-������� (id ������������ ��� id ����������).
;				   ���� �������� type ����� sitepage, �� � �������� owner_id ���������� ���������� id ����������.
;				   ���� �������� �� �����, �� ���������, ��� �� ����� ���� �������������� �������� ������������, ���� �������������� �������� ���������� (���� type ����� sitepage).
;				   $_iItem_id - ������������� Like-�������. ���� type ����� sitepage, �� �������� item_id ����� ��������� �������� ��������� page_id, ������������ ��� ������������� ������� ���� ���������.
;				   $_sPageURL - url ��������, �� ������� ���������� ������ ���� ���������. ������������ ������ ��������� item_id.
;				   $_sFilter - ���������, ������� �� ������� ���� �������������, ���������� ������ � ������ "��� ��������" ��� ������ ���, ������� ���������� � ��� �������.
;				   �������� ����� ��������� ��������� ��������:
;						likes � ���������� ���� �������������
;						copies � ���������� ������ �������������, ������������ �� ������� �������
;						�� ��������� ������������ ��� ������������.
;				   $_iFriendsOnly - ���������, ���������� �� ���������� ������ �������������, ������� �������� �������� �������� ������������.
;				   �������� ����� ��������� ��������� ��������:
;						0 � ���������� ���� ������������� � ������� �������� ������� ���������� �������
;						1 � ���������� ������ ������ �������� ������������ � ������� �������� ������� ���������� �������
;						���� ����� ��� ������ ��� ����������� ��� �������� �� ��� �����, �� ���������, ��� �� ����� 0.
;				   $_iOffset - ��������, ������������ ������ ������, ��� ������� ������������� ������������. ���� �������� �� �����, �� ���������, ��� �� ����� 0.
;				   $_iCount - ���������� ������������ ��������������� �������������.
;				   ���� �������� �� �����, �� ���������, ��� �� ����� 100, ���� �� ����� �������� friends_only, � ��������� ������ 10.
;				   ������������ �������� ��������� 1000, ���� �� ����� �������� friends_only, � ��������� ������ 100.
; Return values .: ����� - � ������ ������ ���������� ������:
;					$aVar[0] � ����� ���������� �������������, ������� �������� �������� ������ � ���� ������ ��� ��������.
;					$aVar[1..n] � ������ ���������������� ������������� � ������ ���������� offset � count, ������� �������� �������� ������ � ���� ������ ��� ��������.
;				   ���� �������� type ����� sitepage, �� ����� ��������� ������ �������������, ����������������� �������� ���� ��������� �� ������� �����.
;				   ����� �������� ������� ��� ������ ��������� page_url ��� item_id.
;				   ������� - ������ �������� ������ � @error = 1
; Author ........: Fever
; Remarks .......: ���� Like-��������:
;					post - ������ �� ����� ������������ ��� ������
;					comment - ����������� � ������ �� �����
;					photo - ����������
;					audio - �����������
;					video - �����������
;					note - �������
;					sitepage - �������� �����, �� ������� ���������� ������ ���� ���������
;
;				   ������ ������� ����� ���� ������� ��� ������������� ��������������� ������ (��������� session ��� access_token).
; ============================================================================================================
Func _VK_likesGetList($_sType, $_sOwnerID = "", $_iItem_id = "", $_sPageURL = "", $_sFilter = "likes", $_iFriendsOnly = 0, $_iOffset = 0, $_iCount = 100)
	Local $sResponse, $iCount

	$sResponse = BinaryToString(InetRead("https://api.vkontakte.ru/method/likes.getList.xml?type=" & $_sType & "&owner_id=" & $_sOwnerID & "&item_id=" & $_iItem_id & "&page_url=" & $_sPageURL & "&filter=" & $_sFilter & "&friends_only" & $_iFriendsOnly & "&offset" & $_iOffset & "&count" & $_iCount), 4)

	If _VK_CheckForError($sResponse) Then
		Return SetError(1, 0, _VK_CheckForError($sResponse))
	Else
		$sResponse = _CreateArray($sResponse, "uid")
		$iCount = _CreateArray($sResponse, "count")
		_ArrayInsert($sResponse, 0, $iCount[0])

		Return $sResponse
	EndIf
EndFunc   ;==>_VK_likesGetList

#endregion Likes Functions

#region Internal Functions

; #FUNCTION# =================================================================================================
; Name...........: __guiAccessToken()
; Description ...: ��������� ���� ��� ��������� ������� ����������
; Syntax.........: __guiAccessToken($_sURI, $_sGUITitle, $_sRedirect_uri)
; Parameters ....: $_sURI - ������.
;				   $_sGUITitle - �������� ����
;				   $_sRedirect_uri - ������ ���������������
; Return values .: ����� - ��� ������������� ��������
;                  ������� - -1 � @error = -1
; Author ........: Fever
; Remarks .......: �����������
; ============================================================================================================
Func __guiAccessToken($_sURI, $_sGUITitle, $_sRedirect_uri)
	Local $_hATgui, $sResponse, $sURL
	Local $oIE = _IECreateEmbedded()
	Local $hTimer = TimerInit()

	$_hATgui = GUICreate($_sGUITitle, 550, 400, -1, -1, $WS_POPUPWINDOW)
	GUICtrlCreateObj($oIE, 1, 1, 548, 398)

	_IENavigate($oIE, $_sURI)
	$sResponse = _IEBodyReadText($oIE)

	If StringInStr($sResponse, "access_token=") Then
		Return __responseParse($sResponse)
	EndIf

	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				Return SetError(1, 0, 1)
		EndSwitch

		If TimerDiff($hTimer) > 250 Then
			$sURL = _IEPropertyGet($oIE, "locationurl")
			If StringInStr($sURL, $_sRedirect_uri & "#") Then
				GUISetState(@SW_HIDE)
				$sResponse = _IEBodyReadText($oIE)
				If StringInStr($sResponse, "access_token=") Then
					GUIDelete($_hATgui)
					Return __responseParse($sResponse)
				Else
					GUIDelete($_hATgui)
					Return SetError(-1, 0, -1)
				EndIf
			EndIf
			$hTimer = TimerInit()
		EndIf
	WEnd
EndFunc   ;==>__guiAccessToken

; #FUNCTION# =================================================================================================
; Name...........: __responseParse()
; Description ...: ���������� �������� � ��������� ����� ��� ���������� �� ��������� RSA
; Syntax.........:  __responseParse($_sResponse)
; Parameters ....: $_sResponse - ����� �������.
; Return values .: ����� - ���������� ������ access_token � @error = 0.
;                  ������� - ������ �� �� �������������))
; Author ........: Fever
; Remarks .......: �����������
; ============================================================================================================
Func __responseParse($_sResponse)
	Local $aNArray = StringSplit($_sResponse, "&"), $aResArray[UBound($aNArray)], $_sStr
	$aResArray[0] = UBound($aNArray) - 1

	For $i = 1 To $aNArray[0]
		$_sStr = StringSplit($aNArray[$i], "=")
		$aResArray[$i] = $_sStr[2]
	Next

	Return $aResArray[1]
EndFunc   ;==>__responseParse

; #FUNCTION# =================================================================================================
; Name...........: _VK_CheckForError()
; Description ...: �������� �� ��, ������ �� ��� ���� ������
; Syntax.........: _VK_CheckForError($sResponse)
; Parameters ....: $sResponse - ����������������� ����� �������
; Return values .: ����� - ������ � ��������� ������
;                  ������� - 0
; Author ........: Medic84
; Remarks .......: �����������
; ============================================================================================================
Func _VK_CheckForError($sResponse)
	Local $error_Code, $error_Msg

	$error_Code = _CreateArray($sResponse, "error_code")
	$error_Msg = _CreateArray($sResponse, "error_msg")

	If IsArray($error_Code) Then
		Return "Error: " & $error_Code[0] & " - " & $error_Msg[0]
	Else
		Return 0
	EndIf
EndFunc   ;==>_VK_CheckForError

; #FUNCTION# =================================================================================================
; Name...........: _CreateArray()
; Description ...: ������� ������ �� �������� ������ �� �������� �����
; Syntax.........: _CreateArray($sString, $sCodeWord)
; Parameters ....: $sString - �������� ����� - �� ������� ����� ���������
;                  $sCodeWord - ����� ��� ������ - ������� ��������� � �����
; Return values .: ����� -  ������ � ������
;                  ������� - 1
; Author ........: Medic84
; Remarks .......: �����������
; ============================================================================================================
Func _CreateArray($sString, $sCodeWord)
	Dim $aRetArray

	$aRetArray = StringRegExp($sString, "(?s)(?i)<" & $sCodeWord & ">(.*?)</" & $sCodeWord & ">", 3)

	Return $aRetArray
EndFunc   ;==>_CreateArray

;===============================================================================
; Description:      _StringFormatTime - Get a string representation of a timestamp
;					according to the format string given to the function.
; Syntax:			_StringFormatTime( "format", timestamp)
; Parameter(s):     Format String - A format string to convert the timestamp to.
; 									See notes for some of the values that can be
; 									used in this string.
; 					Timestamp     - A timestamp to format, possibly returned from
; 									_TimeMakeStamp. If left empty, default, or less
;									than 0, the current time is used. (default is -1)
; Return Value(s):  On Success - Returns string formatted timestamp.
;		   			On Failure - Returns False, sets @error = 99
; Requirement(s):	CrtDll.dll
; Notes:			The date/time specifiers for the Format String:
; 						%a	- Abbreviated weekday name (Fri)
; 						%A	- Full weekday name (Friday)
; 						%b	- Abbreviated month name (Jul)
; 						%B	- Full month name (July)
; 						%c	- Date and time representation (MM/DD/YY hh:mm:ss)
; 						%d	- Day of the month (01-31)
; 						%H	- Hour in 24hr format (00-23)
; 						%I	- Hour in 12hr format (01-12)
; 						%j	- Day of the year (001-366)
; 						%m	- Month number (01-12)
; 						%M	- Minute (00-59)
; 						%p	- Ante meridiem or Post Meridiem (AM / PM)
; 						%S	- Second (00-59)
; 						%U	- Week of the year, with Sunday as the first day of the week (00 - 53)
; 						%w	- Day of the week as a number (0-6; Sunday = 0)
; 						%W	- Week of the year, with Monday as the first day of the week (00 - 53)
; 						%x	- Date representation (MM/DD/YY)
; 						%X	- Time representation (hh:mm:ss)
; 						%y	- 2 digit year (99)
; 						%Y	- 4 digit year (1999)
; 						%z, %Z	- Either the time-zone name or time zone abbreviation, depending on registry settings; no characters if time zone is unknown
; 						%%	- Literal percent character
;	 				The # character can be used as a flag to specify extra settings:
; 						%#c	- Long date and time representation appropriate for current locale. (ex: "Tuesday, March 14, 1995, 12:41:29")
; 						%#x	- Long date representation, appropriate to current locale. (ex: "Tuesday, March 14, 1995")
; 						%#d, %#H, %#I, %#j, %#m, %#M, %#S, %#U, %#w, %#W, %#y, %#Y	- Remove leading zeros (if any).
;
; User CallTip:		_StringFormatTime($s_Format, $i_Timestamp, $i_MaxLen = 255) - Get a string representation of a timestamp according to the format string given to the function. (required: <_UnixTime.au3>)
; Author(s):        Rob Saunders (admin@therks.com)
;===============================================================================
Func _StringFormatTime($s_Format, $i_Timestamp)
	Local $ptr_Time, $av_StrfTime

	$ptr_Time = DllCall('CrtDll.dll', 'ptr:cdecl', 'localtime', 'long*', $i_Timestamp)
	If @error Then
		Return SetError(99, 0, "Error CrtDLL.dll")
	EndIf

	$av_StrfTime = DllCall('CrtDll.dll', 'int:cdecl', 'strftime', _
			'str', '', _
			'int', 255, _
			'str', $s_Format, _
			'ptr', $ptr_Time[0])
	Return $av_StrfTime[1]
EndFunc   ;==>_StringFormatTime
#endregion Internal Functions
