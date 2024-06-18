//%attributes = {}
//Returns true if the passed in key exists.

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_BOOLEAN($0; $fDoesExist)

$oObject:=$1
$tKey:=$2
$fDoesExist:=False

C_TEXT($tLastKey)
C_LONGINT($lIndex)
C_OBJECT($oSubObject)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; False)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#"") & ($lIndex=0))
	$fDoesExist:=(OB Get type($oSubObject; $tLastKey)#Is undefined)
End if 


$0:=$fDoesExist
