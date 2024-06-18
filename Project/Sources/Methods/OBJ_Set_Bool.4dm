//%attributes = {}
//Creates or updates a key with the passed in value

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_BOOLEAN($3; $fValue)

$oObject:=$1
$tKey:=$2
$fValue:=$3

C_TEXT($tLastKey)
C_LONGINT($lIndex)
C_OBJECT($oSubObject)
ARRAY BOOLEAN($afArray; 0)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; True)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	If ($lIndex=0)  //No [x] on the last element, so set directly
		OB SET($oSubObject; $tLastKey; $fValue)
	Else   //The last key refers to an index within an array
		OB GET ARRAY($oSubObject; $tLastKey; $afArray)  //Get the array out
		If ($lIndex>Size of array($afArray))  //Then need to add elements to the array
			INSERT IN ARRAY($afArray; Size of array($afArray)+1; $lIndex-Size of array($afArray))
		End if 
		$afArray{$lIndex}:=$fValue  //Set the value in the array
		OB SET ARRAY($oSubObject; $tLastKey; $afArray)  //Put the array back into the object
	End if 
Else 
	BEEP
	TRACE  //Developer error
End if 
