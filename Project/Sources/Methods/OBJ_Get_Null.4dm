//%attributes = {}
//Returns true if a key's value is set to null. False otherwise.

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation
C_BOOLEAN($0; $fIsNull)

$oObject:=$1
$tKey:=$2
$fIsNull:=False

C_TEXT($tLastKey)
C_LONGINT($lIndex)
C_OBJECT($oSubObject)
ARRAY OBJECT($aoArray; 0)

$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; False)
If ((OBJ_IsValid($oSubObject)=True) & ($tLastKey#""))
	If ($lIndex=0)
		$fIsNull:=(OB Get type($oSubObject; $tLastKey)=Is null)
	Else   //The last key refers to an index within an array. 
		//Only an object array can have a null element
		OB GET ARRAY($oSubObject; $tLastKey; $aoArray)
		If ($lIndex<=Size of array($aoArray))
			$fIsNull:=(OBJ_IsValid($aoArray{$lIndex})=False)  //Treat undefined object in object arrary as null
		End if 
	End if 
End if 

$0:=$fIsNull
