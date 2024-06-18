//%attributes = {"folder":"Objects Get and Set","lang":"en"}
//Returns a long value

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_LONGINT($0; $lValue)

$oObject:=$1
$tKey:=$2
$lValue:=0

C_TEXT($tLastKey)
C_LONGINT($lIndex)
C_OBJECT($oSubObject)
ARRAY LONGINT($alArray; 0)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; False)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	If ($lIndex=0)
		$lValue:=OB Get($oSubObject; $tLastKey; Is longint)
	Else   //The last key refers to an index within an array
		OB GET ARRAY($oSubObject; $tLastKey; $alArray)
		If ($lIndex<=Size of array($alArray))
			$lValue:=$alArray{$lIndex}
		End if 
	End if 
End if 

$0:=$lValue
