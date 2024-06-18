//%attributes = {"folder":"Objects Load and Save","lang":"en"}
//Expects a JSON string in the clipboard and will turn it into an object.

//Expects the JSON string to have an object ("{}") at the top level,
//not an array ("[]"). If it looks like the top level is an array
//(ie. the first character is a "["), the entire array will be automatically
//embedded in a new top level object named "OBJ".

//Use OBJ_IsValid after the call to know if this method was able
//to parse the JSON into an object.

C_OBJECT($0; $oObject)

C_TEXT($tJSONString)

$tJSONString:=Get text from pasteboard
$oObject:=OBJ_Load_FromText($tJSONString)

$0:=$oObject
