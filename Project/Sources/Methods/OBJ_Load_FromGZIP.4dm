//%attributes = {}
//Expects a GZIPed blob with a JSON string in it.

//Expects the JSON string to have an object ("{}") at the top level,
//not an array ("[]"). If it looks like the top level is an array
//(ie. the first character is a "["), the entire array will be automatically
//embedded in a new top level object named "OBJ".

//Use OBJ_IsValid after the call to know if this method was able
//to parse the JSON into an object.


C_BLOB($1; $xBlob)
C_OBJECT($0; $xObject)

$xBlob:=$1

C_TEXT($tJSONString)

EXPAND BLOB($xBlob)
$tJSONString:=Convert to text($xBlob; UTF8 text without length)
$xObject:=OBJ_Load_FromText($tJSONString)

$0:=$xObject
