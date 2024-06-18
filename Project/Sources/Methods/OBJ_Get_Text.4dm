//%attributes = {"folder":"Objects Get and Set","lang":"en"}
//Returns a text value

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_TEXT($0; $tValue)

$oObject:=$1
$tKey:=$2
$tValue:=""

C_TEXT($tLastKey)
C_LONGINT($lIndex)
C_OBJECT($oSubObject)
ARRAY TEXT($atArray; 0)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; False)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	If ($lIndex=0)
		$tValue:=OB Get($oSubObject; $tLastKey; Is text)  //Note that typing as text ensures that we get around the weird issue where 4D wants to return a string that looks like a date as a date instead of text.
	Else   //The last key refers to an index within an array
		OB GET ARRAY($oSubObject; $tLastKey; $atArray)
		If ($lIndex<=Size of array($atArray))
			$tValue:=$atArray{$lIndex}
		End if 
	End if 
End if 

$0:=$tValue
