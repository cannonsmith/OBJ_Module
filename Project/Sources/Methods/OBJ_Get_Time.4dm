//%attributes = {"folder":"Objects Get and Set","lang":"en"}
//Returns a time value. It expects it to be formatted as "HH:MM:SS" JSON string.

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_TIME($0; $hValue)

$oObject:=$1
$tKey:=$2
$hValue:=?00:00:00?

C_TEXT($tLastKey; $tValue)
C_LONGINT($lIndex)
C_OBJECT($oSubObject)
ARRAY TEXT($atArray; 0)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; False)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	If ($lIndex=0)
		$tValue:=OB Get($oSubObject; $tLastKey; Is text)
		$hValue:=Time($tValue)
	Else   //The last key refers to an index within an array
		OB GET ARRAY($oSubObject; $tLastKey; $atArray)
		If ($lIndex<=Size of array($atArray))
			$hValue:=Time($atArray{$lIndex})
		End if 
	End if 
End if 

$0:=$hValue
