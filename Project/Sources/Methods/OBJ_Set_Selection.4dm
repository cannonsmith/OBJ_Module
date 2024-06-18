//%attributes = {}
//Creates or updates a key with the current selection of the passed in table. Internally, we also
//record the table name and the count of records that are in the selection.

//All 4D field types will be converted. The following go through special conversion and
//will look like strings in the actual JSON:
//   Date --> "YYYY-MM-DD" (same as OBJ_Set_Date)
//   Time --> "HH:MM:SS" (same as OBJ_Set_Time)
//   Picture --> becomes a base64 string. Remember to pass in the codec.
//   Blob --> becomes a base64 string.

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_POINTER($3; $pTable)
C_TEXT($4; $tCodec)  //Optional. Used for picture fields. Extension (".png") or mime type ("image/jpeg")

$oObject:=$1
$tKey:=$2
$pTable:=$3
If (Count parameters>3)
	$tCodec:=$4
Else 
	$tCodec:=".png"  //Default for picture fields
End if 

C_LONGINT($x; $lIndex)
C_TEXT($tLastKey)
C_OBJECT($oSubObject; $oRecord)
ARRAY OBJECT($aoRecords; 0)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; True)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	
	For ($x; 1; Records in selection($pTable->))
		GOTO SELECTED RECORD($pTable->; $x)
		$oRecord:=OBJ_FromRecord($pTable; $tCodec)
		APPEND TO ARRAY($aoRecords; $oRecord)
	End for 
	OBJ_Set_Array($oObject; $tKey; ->$aoRecords)
	
End if 
