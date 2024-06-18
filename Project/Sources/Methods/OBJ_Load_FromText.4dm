//%attributes = {}
//Expects a JSON string and will turn it into an object.

//Expects the JSON string to have an object ("{}") at the top level,
//not an array ("[]"). If it looks like the top level is an array
//(ie. the first character is a "["), the entire array will be automatically
//embedded in a new top level object named "OBJ".

//Use OBJ_IsValid after the call to know if this method was able
//to parse the JSON into an object.

C_TEXT($1; $tRawJSON)
C_OBJECT($0; $tJSON)

$tRawJSON:=$1

C_TEXT($tCurrentOnErrMethod)

If ($tRawJSON#"")
	If ($tRawJSON[[1]]="[")
		$tRawJSON:="{\"OBJ\":"+$tRawJSON+"}"
	End if 
	
	$tCurrentOnErrMethod:=Method called on error
	ON ERR CALL("OBJP_OnErrIgnore")
	$tJSON:=JSON Parse($tRawJSON)
	ON ERR CALL($tCurrentOnErrMethod)  //Restore 
End if 

$0:=$tJSON
