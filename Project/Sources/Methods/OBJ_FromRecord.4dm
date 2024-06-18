//%attributes = {}
//Expects a record to be loaded in the passed in table. Returns an object that contains each
//field and its value.

C_POINTER($1; $pTable)
C_TEXT($2; $tCodec)  //Optional. Used for picture fields. Extension (".png") or mime type ("image/jpeg")
C_OBJECT($0; $oRecord)

$pTable:=$1
If (Count parameters>1)
	$tCodec:=$2
Else 
	$tCodec:=".png"  //Default for picture fields
End if 

C_LONGINT($x; $lLastFieldNumber)
C_TEXT($tFieldName; $tConvertedValue)
C_POINTER($pField)

$oRecord:=OBJ_Create

$lLastFieldNumber:=Get last field number($pTable)
For ($x; 1; $lLastFieldNumber)
	If (Is field number valid($pTable; $x)=True)
		$pField:=Field(Table($pTable); $x)
		$tFieldName:=Field name($pField)
		Case of 
			: (Type($pField->)=Is date)
				$tConvertedValue:=String(Year of($pField->); "0000")+"-"+\
					String(Month of($pField->); "00")+"-"+\
					String(Day of($pField->); "00")
				OB SET($oRecord; $tFieldName; $tConvertedValue)
				
			: (Type($pField->)=Is time)
				$tConvertedValue:=String(($pField->+0)\3600; "00")+":"+\
					String((($pField->+0)\60)%60; "00")+":"+\
					String(($pField->+0)%60; "00")
				OB SET($oRecord; $tFieldName; $tConvertedValue)
				
			: (Type($pField->)=Is picture)
				PICTURE TO BLOB($pField->; $xBlob; $tCodec)
				BASE64 ENCODE($xBlob)
				$tConvertedValue:=Convert to text($xBlob; "US-ASCII")
				OB SET($oRecord; $tFieldName; $tConvertedValue)
				
			: (Type($pField->)=Is BLOB)
				$xBlob:=$pField->  //Copy so we don't mess with the original record
				BASE64 ENCODE($xBlob)
				$tConvertedValue:=Convert to text($xBlob; "US-ASCII")
				OB SET($oRecord; $tFieldName; $tConvertedValue)
				
			Else 
				OB SET($oRecord; $tFieldName; $pField->)
				
		End case 
	End if 
End for 

$0:=$oRecord

