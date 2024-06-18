//%attributes = {}
//Expects the passed in file to have an uncompressed JSON string as it's contents.

//Expects the JSON string to have an object ("{}") at the top level,
//not an array ("[]"). If it looks like the top level is an array
//(ie. the first character is a "["), the entire array will be automatically
//embedded in a new top level object named "OBJ".

//Use OBJ_IsValid after the call to know if this method was able
//to parse the JSON into an object.

C_TEXT($1; $tFilepath)
C_OBJECT($0; $oObject)

$tFilepath:=$1

C_TEXT($tJSONString)

If (Test path name($tFilepath)=Is a document)
	$tJSONString:=Document to text($tFilepath)
	$oObject:=OBJ_Load_FromText($tJSONString)
End if 

$0:=$oObject
