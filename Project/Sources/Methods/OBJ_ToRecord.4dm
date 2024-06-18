//%attributes = {}
//Expects a record to be loaded in read/write mode in the passed in table. Sets each field
//from the passed in object. It is up to you to save the record, or to ensure it isn't a
//duplicate record, etc.

//When the values are placed into the record's fields, it is done based on the current field
//name and type. If the object contains a field name that isn't recognized by the table
//structure, it will be ignored. If the structure has fields that aren't in the object, they
//will not be touched at all.

C_OBJECT($1; $oRecord)  //Expects the record object to be passed in here
C_POINTER($2; $pTable)
C_TEXT($3; $tCodec)  //Optional. Used for picture fields. Extension (".png") or mime type ("image/jpeg")

$oRecord:=$1
$pTable:=$2
If (Count parameters>2)
	$tCodec:=$3
Else 
	$tCodec:=".png"  //Default for picture fields
End if 

C_LONGINT($x; $lLastFieldNumber)
C_TEXT($tFieldName; $tJSONValue)
C_POINTER($pField)

If (OBJ_IsValid($oRecord)=True)
	
	$lLastFieldNumber:=Get last field number($pTable)
	For ($x; 1; $lLastFieldNumber)
		
		If (Is field number valid($pTable; $x)=True)
			
			$pField:=Field(Table($pTable); $x)
			$tFieldName:=Field name($pField)
			If (OBJ_DoesKeyExist($oRecord; $tFieldName)=True)
				Case of 
					: (Type($pField->)=Is date)
						$tJSONValue:=OB Get($oRecord; $tFieldName; Is text)
						$pField->:=OBJP_ConvertToDate($tJSONValue)
						
					: (Type($pField->)=Is time)
						$tJSONValue:=OB Get($oRecord; $tFieldName; Is text)
						$pField->:=Time($tJSONValue)
						
					: (Type($pField->)=Is picture)
						$tJSONValue:=OB Get($oRecord; $tFieldName)
						CONVERT FROM TEXT($tJSONValue; "US-ASCII"; $xBlob)
						BASE64 DECODE($xBlob)
						BLOB TO PICTURE($xBlob; $pField->; $tCodec)
						
					: (Type($pField->)=Is BLOB)
						$tJSONValue:=OB Get($oRecord; $tFieldName)
						CONVERT FROM TEXT($tJSONValue; "US-ASCII"; $pField->)
						BASE64 DECODE($pField->)
						
					Else 
						$pField->:=OB Get($oRecord; $tFieldName)
						
				End case 
			End if 
			
		End if 
		
	End for 
	
End if 
