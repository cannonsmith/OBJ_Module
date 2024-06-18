//%attributes = {"folder":"Objects Load and Save","lang":"en"}
//Takes an object and writes it to disk. No compression is added.

//Note that versions of this method previous to 2017-08-30 used "UTF8 text without length"
//as a parameter to TEXT TO DOCUMENT instead of "UTF-8". This was a bug which caused special
//characters (†, ©, etc.) to be lost in the save. However, using "UTF-8", while correct,
//includes a BOM character at the beginning of the file which can cause JSON Parse to choke
//if the JSON has been downloaded from a website (seems okay for local files).
//OBJ_Load_FromText has been updated to check for and ignore the BOM character when present.
//But if you are using old versions of OBJ_Load_FromURL, it may fail.

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
TEXT TO DOCUMENT($tFilepath; $tJSONString; "UTF-8")
ON ERR CALL($tCurrentOnErrMethod)  //Restore 
