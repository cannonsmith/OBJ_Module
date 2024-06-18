//%attributes = {}
//Converts an object into a JSON string. You choose whether it is "pretty
//printed" or not.

C_OBJECT($1; $oObject)
C_BOOLEAN($2; $fUsePrettyPrint)  //Optional, default is False
C_TEXT($0; $tJSONString)

$oObject:=$1
If (Count parameters>1)
	$fUsePrettyPrint:=$2
Else 
	$fUsePrettyPrint:=False
End if 
$tJSONString:=""

If (OBJ_IsValid($oObject)=True)
	If ($fUsePrettyPrint=False)
		$tJSONString:=JSON Stringify($oObject)
	Else 
		$tJSONString:=JSON Stringify($oObject; *)
	End if 
End if 

$0:=$tJSONString
