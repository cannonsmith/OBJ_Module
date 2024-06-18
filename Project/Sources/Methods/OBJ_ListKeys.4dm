//%attributes = {}
//Returns a list of key names that are children to the passed in object.
//Optionally, it can return the types as 4D thinks they are. See the documentation for
//OB GET PROPERTY NAMES. Of course, it will think that the objects we treat differently
//(date, time, blob, picture, etc.) are strings.

C_OBJECT($1; $oObject)
C_TEXT($2; $tKey)  //Can use dot notation. Blank for the top level.
C_POINTER($3; $pChildKeyNames)
C_POINTER($4; $pChildKey4DTypes)  //Optional. Will return the types.

$oObject:=$1
$tKey:=$2
$pChildKeyNames:=$3
If (Count parameters>3)
	$pChildKey4DTypes:=$4
End if 

C_TEXT($tLastKey)
C_LONGINT($lIndex)
C_OBJECT($oSubObject; $oNullObject)
ARRAY OBJECT($aoObjectArray; 0)

//Remove any elements already in the arrays
DELETE FROM ARRAY($pChildKeyNames->; 1; Size of array($pChildKeyNames->))
If (Count parameters>3)
	DELETE FROM ARRAY($pChildKey4DTypes->; 1; Size of array($pChildKey4DTypes->))
End if 

//Figure out the subobject we want to get a list
If ($tKey="")  //Top level so just use passed in object
	$oSubObject:=$oObject
	
Else   //Get the subobject based on dot notation, etc.
	//Note that is will actually be the parent object as OBJ_ListKeys expects the last
	//key in the keypath to be an object.
	$oSubObject:=OBJP_GetSubObject($oObject; $tKey; ->$tLastKey; ->$lIndex; False)
	If ($lIndex=0)  //If no index is involved, just get a reference to the child object
		$oSubObject:=OB Get($oSubObject; $tLastKey; Is object)
		
	Else   //Otherwise, pull out of the object array and get a reference to the object element
		OB GET ARRAY($oSubObject; $tLastKey; $aoObjectArray)
		If ($lIndex<=Size of array($aoObjectArray))
			$oSubObject:=$aoObjectArray{$lIndex}
		Else 
			$oSubObject:=$oNullObject
		End if 
	End if 
	
End if 

If (OBJ_IsValid($oSubObject)=True)  //If we found an actual object...
	If (Count parameters>3)
		OB GET PROPERTY NAMES($oSubObject; $pChildKeyNames->; $pChildKey4DTypes->)
	Else 
		OB GET PROPERTY NAMES($oSubObject; $pChildKeyNames->)
	End if 
End if 
