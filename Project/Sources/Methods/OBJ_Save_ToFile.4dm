//%attributes = {}
//Takes an object and writes it to disk. No compression is added.

C_OBJECT($1; $oObject)
C_TEXT($2; $tFilepath)  //If it already exists, it will be overwritten
C_BOOLEAN($3; $fUsePrettyPrint)  //Optional, default is true.

$oObject:=$1
$tFilepath:=$2
If (Count parameters>2)
	$fUsePrettyPrint:=$3
Else 
	$fUsePrettyPrint:=True
End if 

C_TEXT($tJSONString; $tCurrentOnErrMethod)

$tCurrentOnErrMethod:=Method called on error
$tJSONString:=OBJ_Save_ToText($oObject; $fUsePrettyPrint)
ON ERR CALL("OBJP_OnErrIgnore")
TEXT TO DOCUMENT($tFilepath; $tJSONString; UTF8 text without length)
ON ERR CALL($tCurrentOnErrMethod)  //Restore 
