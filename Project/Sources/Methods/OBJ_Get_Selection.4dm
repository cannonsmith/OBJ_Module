//%attributes = {}
//Returns an object array of records. You can inspect each record manually or use OBJ_ToRecord
//to place each one in a record. This method does not automatically update records in the database.
//It is left to you to decide how to do that.

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_POINTER($3; $pSelectionArray)  //The records will be returned in this array

$oObject:=$1
$tKey:=$2
$pSelectionArray:=$3

C_TEXT($tLastKey)
C_LONGINT($lIndex)
C_OBJECT($oSubObject)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; False)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	OB GET ARRAY($oSubObject; $tLastKey; $pSelectionArray->)  //Get directly
End if 
