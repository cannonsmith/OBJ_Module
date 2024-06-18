//%attributes = {"folder":"Objects Get and Set","lang":"en"}
//Returns a boolean value

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_BOOLEAN($0; $fValue)

$oObject:=$1
$tKey:=$2
$fValue:=False

C_TEXT($tLastKey)
C_LONGINT($lIndex)
C_OBJECT($oSubObject)
ARRAY BOOLEAN($afArray; 0)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; False)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	If ($lIndex=0)
		$fValue:=OB Get($oSubObject; $tLastKey; Is boolean)
	Else   //The last key refers to an index within an array
		OB GET ARRAY($oSubObject; $tLastKey; $afArray)
		If ($lIndex<=Size of array($afArray))
			$fValue:=$afArray{$lIndex}
		End if 
	End if 
End if 

$0:=$fValue
