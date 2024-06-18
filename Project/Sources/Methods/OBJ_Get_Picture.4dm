//%attributes = {"folder":"Objects Get and Set","lang":"en"}
//Returns a picture value. It should have previously been base64 encoded.

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_TEXT($3; $tCodec)  //Extension (".png") or mime type ("image/jpeg")
C_PICTURE($0; $gValue)

$oObject:=$1
$tKey:=$2
$tCodec:=$3

C_TEXT($tLastKey; $tJSONValue)
C_BLOB($xBlob)
C_LONGINT($lIndex)
C_OBJECT($oSubObject)
ARRAY TEXT($atArray; 0)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; False)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	If ($lIndex=0)
		$tJSONValue:=OB Get($oSubObject; $tLastKey)
		CONVERT FROM TEXT($tJSONValue; "US-ASCII"; $xBlob)
		BASE64 DECODE($xBlob)
		BLOB TO PICTURE($xBlob; $gValue; $tCodec)
	Else   //The last key refers to an index within an array
		OB GET ARRAY($oSubObject; $tLastKey; $atArray)
		If ($lIndex<=Size of array($atArray))
			$tJSONValue:=$atArray{$lIndex}
			CONVERT FROM TEXT($tJSONValue; "US-ASCII"; $xBlob)
			BASE64 DECODE($xBlob)
			BLOB TO PICTURE($xBlob; $gValue; $tCodec)
		End if 
	End if 
End if 

$0:=$gValue
