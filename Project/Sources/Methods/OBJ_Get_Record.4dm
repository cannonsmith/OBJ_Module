//%attributes = {"folder":"Objects Get and Set","lang":"en"}
//Expects a loaded record in the passed in table. Will replace field values with those from the
//object based on field names. If a key doesn't exist for a field name, the field won't be touched.

//All 4D field types will be converted. The following types should have been encoded as follows:
//   Date --> "YYYY-MM-DD" (same as OBJ_Set_Date) UNLESS you pass in the native date/time paramater (recommended)
//   Time --> "HH:MM:SS" (same as OBJ_Set_Time) UNLESS you pass in the native date/time paramater (recommended)
//   Picture --> a base64 string. Remember to pass in the codec.
//   Blob --> a base64 string.

//Unless you need to do otherwise for backward compatibility, always pass true for the native
//date and time handling. That allows us to use dot notation in code to directly set date and
//time values instead of having to use OBJ_Get/Set_... methods which handle dates and times
//differently from before 4D supported them natively.

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_POINTER($3; $pTable)  //Expects a record to be loaded
C_TEXT($4; $tCodec)  //Optional. Used for picture fields. Extension (".png") or mime type ("image/jpeg")
C_BOOLEAN($5; $fNativeDateTime)  //Optional. Default is false for backward compatibility. If true, we use native 4D date and time values. 

$oObject:=$1
$tKey:=$2
$pTable:=$3
If (Count parameters>3)
	$tCodec:=$4
	If ($tCodec="")
		$tCodec:=".png"
	End if 
Else 
	$tCodec:=".png"  //Default for picture fields
End if 
If (Count parameters>4)
	$fNativeDateTime:=$5
Else 
	$fNativeDateTime:=False
End if 

C_TEXT($tLastKey)
C_LONGINT($lIndex)
C_OBJECT($oSubObject; $oRecordObject)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; False)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	$oRecordObject:=OB Get($oSubObject; $tLastKey; Is object)
	OBJ_ToRecord($oRecordObject; $pTable; $tCodec; $fNativeDateTime)
End if 
