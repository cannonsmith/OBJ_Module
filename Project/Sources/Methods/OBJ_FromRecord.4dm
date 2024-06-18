//%attributes = {"folder":"Objects General","lang":"en"}
//Expects a record to be loaded in the passed in table. Returns an object that contains each
//field and its value.

//Unless you need to do otherwise for backward compatibility, always pass true for the native
//date and time handling. That allows us to use dot notation in code to directly set date and
//time values instead of having to use OBJ_Get/Set_... methods which handle dates and times
//differently from before 4D supported them natively.

C_POINTER($1; $pTable)
C_TEXT($2; $tCodec)  //Optional. Used for picture fields. Extension (".png") or mime type ("image/jpeg"). Blank for default
C_BOOLEAN($3; $fNativeDateTime)  //Optional. Default is false for backward compatibility. If true, we use native 4D date and time values. 
C_OBJECT($0; $oRecord)

$pTable:=$1
If (Count parameters>1)
	$tCodec:=$2
	If ($tCodec="")
		$tCodec:=".png"
	End if 
Else 
	$tCodec:=".png"  //Default for picture fields
End if 
If (Count parameters>2)
	$fNativeDateTime:=$3
Else 
	$fNativeDateTime:=False
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
				If ($fNativeDateTime=False)
					$tConvertedValue:=String(Year of($pField->); "0000")+"-"+\
						String(Month of($pField->); "00")+"-"+\
						String(Day of($pField->); "00")
					OB SET($oRecord; $tFieldName; $tConvertedValue)
				Else   //4D native type
					OB SET($oRecord; $tFieldName; $pField->)
				End if 
				
			: (Type($pField->)=Is time)
				If ($fNativeDateTime=False)
					$tConvertedValue:=String(($pField->+0)\3600; "00")+":"+\
						String((($pField->+0)\60)%60; "00")+":"+\
						String(($pField->+0)%60; "00")
					OB SET($oRecord; $tFieldName; $tConvertedValue)
				Else   //4D native type
					OB SET($oRecord; $tFieldName; $pField->)
				End if 
				
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

