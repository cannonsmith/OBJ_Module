//%attributes = {"folder":"Objects General","lang":"en"}
//Removes the key (which may be to a value or another object) from the
//passed in object.

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation

$oObject:=$1
$tKey:=$2

C_TEXT($tLastKey)
C_LONGINT($lIndex)
C_OBJECT($oSubObject)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; False)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#"") & ($lIndex=0))
	OB REMOVE($oSubObject; $tLastKey)
End if 
