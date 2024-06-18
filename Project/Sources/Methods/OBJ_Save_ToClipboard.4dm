//%attributes = {"folder":"Objects Load and Save","lang":"en"}
//Converts an object into a JSON string and throws it in the clipboard

C_OBJECT($1; $oObject)
C_BOOLEAN($2; $fUsePrettyPrint)  //Optional, default is True

$oObject:=$1
If (Count parameters>1)
	$fUsePrettyPrint:=$2
Else 
	$fUsePrettyPrint:=True
End if 

C_TEXT($tJSONString)

$tJSONString:=OBJ_Save_ToText($oObject; $fUsePrettyPrint)
SET TEXT TO PASTEBOARD($tJSONString)
