//%attributes = {"folder":"Objects Load and Save","lang":"en"}
//Converts an object into a JSON string and then GZIPs it into a blob.
//Good for sending across the internet.

C_OBJECT($1; $oObject)
C_BOOLEAN($2; $fUsePrettyPrint)  //Optional, default is False
C_BLOB($0; $xBlob)  //GZIPed JSON is returned in a blob

$oObject:=$1
If (Count parameters>1)
	$fUsePrettyPrint:=$2
Else 
	$fUsePrettyPrint:=False
End if 

C_TEXT($tJSONString)

$tJSONString:=OBJ_Save_ToText($oObject; $fUsePrettyPrint)
CONVERT FROM TEXT($tJSONString; UTF8 text without length; $xBlob)
COMPRESS BLOB($xBlob; GZIP best compression mode)

$0:=$xBlob
