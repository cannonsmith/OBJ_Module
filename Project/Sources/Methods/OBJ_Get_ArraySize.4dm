//%attributes = {}
//Returns the size of the array. If the referred to object isn't an array, -1 is returned.
//NOTE: This method does not work for 2D arrays.

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_LONGINT($0; $lSize)

$oObject:=$1
$tKey:=$2
$lSize:=-1  //Default if not an array

C_TEXT($tLastKey)
C_LONGINT($lIndex)
C_OBJECT($oSubObject)
ARRAY TEXT($atArray; 0)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; False)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	
	If (OB Get type($oSubObject; $tLastKey)=Object array)  //Will be true for any array type
		OB GET ARRAY($oSubObject; $tLastKey; $atArray)  //Any kind of array will be coerced into a text array
		$lSize:=Size of array($atArray)
	End if 
	
End if 

$0:=$lSize
