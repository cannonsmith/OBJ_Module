//%attributes = {"folder":"Objects Get and Set","lang":"en"}
//Returns a real value

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_REAL($0; $rValue)

$oObject:=$1
$tKey:=$2
$rValue:=0

C_TEXT($tLastKey)
C_LONGINT($lIndex)
C_OBJECT($oSubObject)
ARRAY REAL($arArray; 0)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; False)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	If ($lIndex=0)
		$rValue:=OB Get($oSubObject; $tLastKey; Is real)
	Else   //The last key refers to an index within an array
		OB GET ARRAY($oSubObject; $tLastKey; $arArray)
		If ($lIndex<=Size of array($arArray))
			$rValue:=$arArray{$lIndex}
		End if 
	End if 
End if 

$0:=$rValue
