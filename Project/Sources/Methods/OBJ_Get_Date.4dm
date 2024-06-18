//%attributes = {}
//Returns a date value. It expects it to be formatted as "YYYY-MM-DD" JSON string.

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_DATE($0; $dValue)

$oObject:=$1
$tKey:=$2
$dValue:=!00-00-00!

C_TEXT($tLastKey; $tValue)
C_LONGINT($lIndex)
C_OBJECT($oSubObject)
ARRAY TEXT($atArray; 0)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; False)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	If ($lIndex=0)
		$tValue:=OB Get($oSubObject; $tLastKey; Is text)
		$dValue:=OBJP_ConvertToDate($tValue)
	Else   //The last key refers to an index within an array
		OB GET ARRAY($oSubObject; $tLastKey; $atArray)
		If ($lIndex<=Size of array($atArray))
			$dValue:=OBJP_ConvertToDate($atArray{$lIndex})
		End if 
	End if 
End if 

$0:=$dValue
