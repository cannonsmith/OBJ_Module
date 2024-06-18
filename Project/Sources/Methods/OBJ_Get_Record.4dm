//%attributes = {}
//Expects a loaded record in the passed in table. Will replace field values with those from the
//object based on field names. If a key doesn't exist for a field name, the field won't be touched.

//All 4D field types will be converted. The following types should have been encoded as follows:
//   Date --> "YYYY-MM-DD" (same as OBJ_Set_Date)
//   Time --> "HH:MM:SS" (same as OBJ_Set_Time)
//   Picture --> a base64 string. Remember to pass in the codec.
//   Blob --> a base64 string.

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_POINTER($3; $pTable)  //Expects a record to be loaded
C_TEXT($4; $tCodec)  //Optional. Used for picture fields. Extension (".png") or mime type ("image/jpeg")

$oObject:=$1
$tKey:=$2
$pTable:=$3
If (Count parameters>3)
	$tCodec:=$4
Else 
	$tCodec:=".png"  //Default for picture fields
End if 

C_TEXT($tLastKey)
C_LONGINT($lIndex)
C_OBJECT($oSubObject; $oRecordObject)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; False)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	$oRecordObject:=OB Get($oSubObject; $tLastKey; Is object)
	OBJ_ToRecord($oRecordObject; $pTable; $tCodec)
End if 
