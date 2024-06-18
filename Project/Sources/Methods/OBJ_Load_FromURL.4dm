//%attributes = {}
//Expects a JSON string to be returned after calling the URL.

//Expects the JSON string to have an object ("{}") at the top level,
//not an array ("[]"). If it looks like the top level is an array
//(ie. the first character is a "["), the entire array will be automatically
//embedded in a new top level object named "OBJ".

//Use OBJ_IsValid after the call to know if this method was able
//to parse the JSON into an object.

C_TEXT($1; $tURL)
C_OBJECT($0; $oObject)

$tURL:=$1

C_LONGINT($lHTTPCode)
C_TEXT($tJSONString; $tCurrentOnErrMethod)

$tCurrentOnErrMethod:=Method called on error
ON ERR CALL("OBJP_OnErrIgnore")
$lHTTPCode:=HTTP Get($tURL; $tJSONString)
ON ERR CALL($tCurrentOnErrMethod)  //Restore 
$oObject:=OBJ_Load_FromText($tJSONString)

$0:=$oObject
