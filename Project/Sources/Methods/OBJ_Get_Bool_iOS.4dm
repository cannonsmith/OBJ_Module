//%attributes = {}
//Returns a boolean value. When using NSJSONSerialization in iOS (or OS X)
//to create a JSON string, booleans aren't supported directly. It can consume
//JSON booleons, but converts them to an NSNumber as 0 or 1. So when JSON
//is returned from NSJSONSerialization, we need to look for a 0 or 1 and
//convert it to a boolean. So, use this method instead of OBJ_Get_Bool if
//you know this conversion is needed.

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_BOOLEAN($0; $fValue)

$oObject:=$1
$tKey:=$2
$fValue:=False

C_TEXT($tLastKey)
C_LONGINT($lIndex)
C_OBJECT($oSubObject)
ARRAY LONGINT($alArray; 0)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; False)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	If ($lIndex=0)
		$fValue:=Choose(OB Get($oSubObject; $tLastKey; Is longint)=0; False; True)
	Else   //The last key refers to an index within an array
		OB GET ARRAY($oSubObject; $tLastKey; $alArray)
		If ($lIndex<=Size of array($alArray))
			$fValue:=Choose($alArray{$lIndex}=0; False; True)
		End if 
	End if 
End if 

$0:=$fValue
