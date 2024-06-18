//%attributes = {}
//Creates or updates a key with the passed in value

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_LONGINT($3; $lValue)

$oObject:=$1
$tKey:=$2
$lValue:=$3

C_TEXT($tLastKey)
C_LONGINT($lIndex)
C_OBJECT($oSubObject)
ARRAY LONGINT($alArray; 0)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; True)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	If ($lIndex=0)  //No [x] on the last element, so set directly
		OB SET($oSubObject; $tLastKey; $lValue)
	Else   //The last key refers to an index within an array
		OB GET ARRAY($oSubObject; $tLastKey; $alArray)  //Get the array out
		If ($lIndex>Size of array($alArray))  //Then need to add elements to the array
			INSERT IN ARRAY($alArray; Size of array($alArray)+1; $lIndex-Size of array($alArray))
		End if 
		$alArray{$lIndex}:=$lValue  //Set the value in the array
		OB SET ARRAY($oSubObject; $tLastKey; $alArray)  //Put the array back into the object
	End if 
Else 
	BEEP
	TRACE  //Developer error
End if 
