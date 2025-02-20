//%attributes = {"folder":"Objects Get and Set","lang":"en"}
//Creates or updates a key with the value of null

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation

$oObject:=$1
$tKey:=$2

C_TEXT($tLastKey)
C_LONGINT($lIndex)
C_OBJECT($oSubObject; $oNullObject)
ARRAY OBJECT($aoArray; 0)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; True)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	If ($lIndex=0)  //No [x] on the last element, so set directly
		OB SET NULL($oSubObject; $tLastKey)
	Else   //The last key refers to an index within an array
		OB GET ARRAY($oSubObject; $tLastKey; $aoArray)  //Get the array out
		If ($lIndex>Size of array($aoArray))  //Then need to add elements to the array
			INSERT IN ARRAY($aoArray; Size of array($aoArray)+1; $lIndex-Size of array($aoArray))
		End if 
		$aoArray{$lIndex}:=$oNullObject  //Set the value in the array
		OB SET ARRAY($oSubObject; $tLastKey; $aoArray)  //Put the array back into the object
	End if 
Else 
	BEEP
	TRACE  //Developer error
End if 
