//%attributes = {"folder":"Objects General","lang":"en"}
//Expects a record to be loaded in read/write mode in the passed in table. Sets each field
//from the passed in object. It is up to you to save the record, or to ensure it isn't a
//duplicate record, etc.

//When the values are placed into the record's fields, it is done based on the current field
//name and type. If the object contains a field name that isn't recognized by the table
//structure, it will be ignored. If the structure has fields that aren't in the object, they
//will not be touched at all.

//Unless you need to do otherwise for backward compatibility, always pass true for the native
//date and time handling. That allows us to use dot notation in code to directly set date and
//time values instead of having to use OBJ_Get/Set_... methods which handle dates and times
//differently from before 4D supported them natively.


C_OBJECT($1; $oRecord)  //Expects the record object to be passed in here
C_POINTER($2; $pTable)
C_TEXT($3; $tCodec)  //Optional. Used for picture fields. Extension (".png") or mime type ("image/jpeg")
C_BOOLEAN($4; $fNativeDateTime)  //Optional. Default is false for backward compatibility. If true, we use native 4D date and time values.

$oRecord:=$1
$pTable:=$2
If (Count parameters>2)
	$tCodec:=$3
	If ($tCodec="")
		$tCodec:=".png"
	End if 
Else 
	$tCodec:=".png"  //Default for picture fields
End if 
If (Count parameters>3)
	$fNativeDateTime:=$4
Else 
	$fNativeDateTime:=False
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
						If ($fNativeDateTime=False)
							$tJSONValue:=OB Get($oRecord; $tFieldName; Is text)
							$pField->:=OBJP_ConvertToDate($tJSONValue)
						Else 
							$pField->:=OB Get($oRecord; $tFieldName)
						End if 
						
					: (Type($pField->)=Is time)
						If ($fNativeDateTime=False)
							$tJSONValue:=OB Get($oRecord; $tFieldName; Is text)
							$pField->:=Time($tJSONValue)
						Else 
							$pField->:=OB Get($oRecord; $tFieldName)
						End if 
						
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
