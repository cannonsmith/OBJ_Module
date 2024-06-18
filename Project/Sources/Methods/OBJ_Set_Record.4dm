//%attributes = {"folder":"Objects Get and Set","lang":"en"}
//Creates or updates a key with the loaded record of the passed in table.
//All 4D field types will be converted. The following go through special conversion and
//will look like strings in the actual JSON:
//   Date --> "YYYY-MM-DD" (same as OBJ_Set_Date) UNLESS you pass in the native date/time paramater (recommended)
//   Time --> "HH:MM:SS" (same as OBJ_Set_Time) UNLESS you pass in the native date/time paramater (recommended)
//   Picture --> becomes a base64 string. Remember to pass in the codec.
//   Blob --> becomes a base64 string.

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

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; True)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	$oRecordObject:=OBJ_FromRecord($pTable; $tCodec; $fNativeDateTime)
	OBJ_Set_Object($oObject; $tKey; $oRecordObject)
End if 
