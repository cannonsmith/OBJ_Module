//%attributes = {"folder":"Objects Get and Set","lang":"en"}
//Returns a date and time value. It expects it to be formatted as
//"YYYY-MM-DDTHH:MM:SSZ" JSON string.

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_POINTER($3; $pTime)  //The time portion is returned here
C_DATE($0; $dValue)

$oObject:=$1
$tKey:=$2
$pTime:=$3
$dValue:=!00-00-00!
$pTime->:=?00:00:00?  //Default if something goes wrong

C_TEXT($tLastKey; $tValue)
C_LONGINT($lIndex)
C_OBJECT($oSubObject)
ARRAY TEXT($atArray; 0)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; False)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	If ($lIndex=0)
		$tValue:=OB Get($oSubObject; $tLastKey; Is text)
		If (Length($tValue)=20)
			$dValue:=OBJP_ConvertToDate(Substring($tValue; 1; 10))
			$pTime->:=Time(Substring($tValue; 12; 8))
		End if 
	Else   //The last key refers to an index within an array
		OB GET ARRAY($oSubObject; $tLastKey; $atArray)
		If ($lIndex<=Size of array($atArray))
			$tValue:=$atArray{$lIndex}
			If (Length($tValue)=20)
				$dValue:=OBJP_ConvertToDate(Substring($tValue; 1; 10))
				$pTime->:=Time(Substring($tValue; 12; 8))
			End if 
		End if 
	End if 
End if 

$0:=$dValue
